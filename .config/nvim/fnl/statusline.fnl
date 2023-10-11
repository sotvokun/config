; - MACROS -----------

(macro buf-opt [buf opt]
  `(vim.api.nvim_buf_get_option (tonumber buf) ,(tostring opt)))


; - COMPONENT --------

(fn modified? [buf] 
  (if (buf-opt buf :modified) "[+]" ""))

(fn readonly? [buf]
  (if (buf-opt buf :readonly) "[RO]" ""))

(fn format? [buf]
  (match (buf-opt buf :fileformat)
    "dos" "[CRLF]"
    "mac" "[CR]"
    _ ""))

(fn encoding? [buf]
  (let [enc (buf-opt buf :fileencoding)]
    (match enc
      "utf-8" ""
      _ (.. "[" (vim.fn.toupper enc) "]"))))

(fn filetype [buf]
  (let [ft (buf-opt buf :filetype)]
    (match ft
      "" ""
      _ (.. "[" ft "]"))))

(fn filename [buf]
  (let [name (vim.api.nvim_buf_get_name buf)
        is-file (vim.fn.filereadable name)
        shorten-path (fn [path]
                       (if (> (length path) 75) (vim.fn.pathshorten path)
                         path))]
    (match name
      "" "[No Name]"
      _ (if (not is-file) name
          (shorten-path (vim.fn.fnamemodify name ":~:."))))))

(fn location [win]
  (let [row (vim.fn.line ".")
        col (vim.fn.virtcol ".")]
    (.. row ":" col)))

(fn mode []
  (let [{: mode} (vim.api.nvim_get_mode)
        text (match mode
               "v" "visual"
               "V" "visual-line"
               "\22" "visual-block"
               "s" "select"
               "S" "select-line"
               "\19" "select-block"
               "i" "insert"
               "r" "replace"
               "R" "replace"
               "Rv" "visual-replace"
               "c" "command"
               "cv" "ex"
               "ce" "ex"
               "!" "shell"
               "t" "terminal"
               _ "")
        hl (match mode
             (where (or "v" "V" "\22" "s" "S" "\19")) "StatusLineModeVisual"
             (where (or "i")) "StatusLineModeInsert"
             (where (or "r" "R" "Rv")) "StatusLineModeReplace"
             (where (or "c" "cv" "ce")) "StatusLineModeCommand"
             (where (or "t")) "StatusLineModeTerminal"
             (where (or "!")) "StatusLineModeShell"
             _ "Normal")]
    (.. "%#" hl "#" text "%*")))

; - EXPORT -----------

(fn group [...]
  (table.concat [...] ""))

(fn statusline []
  (let
    [buf (vim.api.nvim_get_current_buf)
     win (vim.api.nvim_get_current_win)
     comp [" "
           (filename buf)
           (group (modified? buf) 
                  (readonly? buf))
           "%="
           (mode)
           (group (filetype buf)
                  (format? buf)
                  (encoding? buf))
           (location win)]]
    (table.concat comp " ")))

{
 : statusline}
