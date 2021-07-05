;; ===============================
;;            Utilities
;; ===============================
;; ------------ evil -------------
(defun evil-state-tag () 
  (let ((tag evil-mode-line-tag))
    (if (string-match "^\\s-<\\(\\w+\\)>\\s-$" tag)
	(match-string 1 tag) nil)))

(defun evil-state-vim-style (prefix postfix)
  (let ((result (evil-state-tag)))
    (cond ((string= result "N")  "")
	  ((string= result "E")
	   (propertize (concat prefix "EMACS" postfix)
		       'face '(:foreground "#622486" :weight bold)))
	  ((string= result "I")  (concat prefix "INSERT" postfix))
	  ((string= result "V")  (concat prefix "VISUAL" postfix))
	  ((string= result "Vb") (concat prefix "VISUAL BLOCK" postfix))
	  ((string= result "Vl") (concat prefix "VISUAL LINE" postfix))
	  (nil result))))

;; ----------- coding ------------
(defun mode-line-coding-system-info ()
  (let* ((code (symbol-name buffer-file-coding-system))
	 (codepage (if (string-match "^\\(.*\\)\\-\\(unix\\|dos\\|mac\\)$" code)
		       (match-string 1 code) nil))
	 (lineend (if codepage (match-string 2 code) nil)))
    (concat (upcase codepage)
	    " "
	    (cond ((string= lineend "unix") "LF")
		  ((string= lineend "dos") "CRLF")
		  ((string= lineend "mac") "CR")
		  "???"))))

;; --------- modification --------
(defun mode-line-buffer-modification ()
  (let ((status (format-mode-line "%&")))
    (if (not (string= status "-"))
	(propertize "*" 'face '(:foreground "#A83232" :weight bold))
        " ")))

;; ===============================
;;               Main
;; ===============================
;; ----- render to two align -----
(defun mode-line-render (left right)
  (let ((center-space (- (window-width) (+ (length (format-mode-line left))
					   (length (format-mode-line right))))))
    (list left
	  (format (format "%%%ds" center-space) "")
	  right)))

;; -------- Initialization -------
(defun mode-line-init ()
  '(:eval (mode-line-render
	   ; LEFT PANEL
	   '((:eval (mode-line-buffer-modification))
	     " "
	     (:eval (propertize (format-mode-line "%b")
				'face '(:weight bold)))
	     (:eval (evil-state-vim-style " [" "] ")))

	   ; RIGHT PANEL
	   '("L%l:%c "
	     (:eval (mode-line-coding-system-info))
	     " "
	     mode-line-modes))))

(provide 'mode-line-init)
