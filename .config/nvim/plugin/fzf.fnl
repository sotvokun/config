(local 
  [has-requirement 
   {: picker-pane 
    : picker-win}] (require :fzf-helper))

;; Health Check
;; --------------------

(when (not has-requirement)
  (do
    (vim.notify 
      "[fzf.fnl] necessary executable `fzf` does not exists"
      vim.log.levels.WARN)
    (lua "return")))


;; Utils
;; --------------------

(macro coroutine-wrap [func] `(fn [] ((coroutine.wrap ,func))))

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

(command :Files (coroutine-wrap (picker-win file-provider)))
(command :Buffers (coroutine-wrap (picker-pane buf-provider)))
(command :History (coroutine-wrap (picker-pane oldfiles-provider)))
(command :Rg 
  (fn [args]
    ((coroutine.wrap (picker-pane (build-rg-provider args.args)))))
  :nargs 1)
