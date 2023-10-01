(local has-requirement (and (executable? "fzf")
                            (pcall require "fzf")))

(local fzf (match (pcall require "fzf")
             (true fzf_) fzf_
             _ nil))

(when (not (nil? fzf))
  (tset fzf :default_options 
        {:border false 
         :fzf_cli_args "--layout=reverse --ansi --info=inline-right "}))

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

[has-requirement {: picker-pane : picker-win}]
