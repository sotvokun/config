(require-macros :svim.macros.vim)

(let [{: setup } (require :toggleterm)]
  (do
    (if (= 1 (call/fn has :win32))
          (setup { :shell :powershell })
          (setup {}))))
