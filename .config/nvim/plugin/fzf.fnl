(require-macros :macros)


;; Health Check
;; --------------------

(when (not (executable? "fzf"))
  (do
    (vim.notify 
      "[fzf.fnl] necessary executable `fzf` does not exists"
      vim.log.levels.WARN)
    (lua "return")))

(when (not (pcall require "fzf"))
  (do
    (vim.notify
      "[fzf.fnl] dependency plugin 'github.com/vijaymarupudi/nvim-fzf' does not exists"
      vim.log.levels.WARN)
    (lua "return")))

(local fzf (require :fzf))
(tset fzf 
      :default_options 
      {:border false
       :fzf_cli_args "--layout=reverse --ansi --info=inline-right "})

(local fzf-action (. (require :fzf.actions) :action))


;; Utils
;; --------------------

(macro coroutine-wrap [func]
  `(fn [] ((coroutine.wrap ,func))))

(fn picker-pane [provider ?opts]
  (let [[contents handler fzf-args] (provider)]
    (fn []
      (do
        (vim.cmd "horizontal new | set nonu")
        (let [result (fzf.provided_win_fzf contents fzf-args ?opts)]
          (when result (handler result)))))))

(fn picker-win [provider ?opts]
  (let [[contents handler fzf-args] (provider)]
    (fn []
      (let [result (fzf.fzf contents fzf-args ?opts)]
        (when result (handler result))))))

(fn parse-vimgrep-line [line]
  (let [parts [(string.match line "(.-):(%d+):(%d+):.*")]
        filename (head parts)
        row (tonumber (. parts 2))
        col (tonumber (. parts 3))]
    {: filename 
     : row 
     : col}))

(fn handler-edit [path-list]
  (vim.cmd (string.format "edit %s" (head path-list))))

(fn handler-edit-start-ln [path-list]
  (let [{: filename : row} (parse-vimgrep-line (head path-list))]
    (vim.cmd (string.format "edit +%d %s" row filename))))


;; Providers
;; -> [contents handler ?fzf-args]
;; --------------------

(fn file-provider []
  (let [contents "fd --type file"
        handler handler-edit]
    [contents handler "--prompt=\"Files> \""]))

(fn buf-provider []
  (let [buf-ids (vim.api.nvim_list_bufs)
        buf-paths (icollect [_ v (ipairs buf-ids)]
                    (vim.api.nvim_buf_get_name v))
        buf-rel (icollect [_ v (ipairs buf-paths)]
                  (vim.fn.fnamemodify v ":~:."))
        handler (fn [path] (vim.cmd (.. "buffer " (. path 1))))]
    [buf-rel handler "--prompt=\"Buffers> \""]))

(fn oldfiles-provider []
  (let [oldfiles vim.v.oldfiles
        cwd (vim.fn.getcwd)
        is-in-cwd (fn [p] (vim.startswith p cwd))
        contents (vim.tbl_filter is-in-cwd oldfiles)
        handler handler-edit]
    [contents handler "--prompt=\"History> \""]))

(fn build-rg-provider [input]
  (fn []
    (let [input_ (vim.fn.shellescape input)
          rgcmd (string.format "rg --vimgrep --no-heading --color ansi %s" input_)
          handler handler-edit-start-ln]
      [rgcmd handler "--prompt=\"Rg> \""])))


;; Commands
;; --------------------

(define-command Files (coroutine-wrap (picker-pane file-provider)))
(define-command Buffers (coroutine-wrap (picker-pane buf-provider)))
(define-command History (coroutine-wrap (picker-pane oldfiles-provider)))
(define-command Rg 
  (fn [args]
    ((coroutine.wrap (picker-pane (build-rg-provider args.args)))))
  {:nargs 1})
