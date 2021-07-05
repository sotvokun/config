;; ==============================
;;           Packages
;; ==============================
;; - Package repostiroy
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; - Install: evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

;; - Install: selectrum
(unless (and (package-installed-p 'selectrum)
	     (package-installed-p 'selectrum-prescient))
  (progn (package-install 'selectrum)
	 (package-install 'selectrum-prescient)))

;; ==============================
;;             Common
;; ==============================
;; ----- Settings for GUI -------
(if (window-system)
    (progn
;; - Disable the scroll bar
      (scroll-bar-mode -1)
;; - Disable the tool bar
      (tool-bar-mode -1)
;; - Disable the ring bell for warning
      (setq ring-bell-function 'ignore)
;; - Change the format of the frame title for GUI
      (setq frame-title-format '("%b " "%f"))))

;; --- Settings for Windows -----
(if (string= (window-system) (symbol-name 'w32))
    (progn))
    

;; ---------- Font --------------
;; - Set English font
(set-face-attribute 'default nil :font "Iosevka Pragmatus 12")
;; - Set CJK Font for CJK Charset
(set-fontset-font "fontset-default" 'han "Source Han Sans SC")

;; ---------- Theme -------------
(let ((hour (nth 2 (decode-time (current-time)))))
  (if (or (>= hour 18) (< hour 6))
      (load-theme 'dolch-dark t)
    (load-theme 'dolch-light t)))

;; --------- Backup -------------
(setq make-backup-files nil)

;; --------- Encoding -----------
(prefer-coding-system 'utf-8)
;; (set-language-environment 'utf-8)
;; (set-default-coding-systems 'utf-8)
;; (set-buffer-file-coding-system 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (setq coding-system-for-write 'utf-8)
;; (setq locale-coding-system 'utf-8)
;; (Setq set-keyboard-coding-system nil)

;; --- Disable Startup Screen ---
(setq inhibit-startup-screen t)

;; ==============================
;;       Packages Settings
;; ==============================
;; - Enable: evil
(require 'evil)
(evil-mode +1)

;; - Enable: selectrum
(selectrum-mode +1)
(selectrum-prescient-mode +1)

;; ==============================
;;       External Settings
;; ==============================
;; -------- mode line -----------
(load "~/.emacs.d/mode-line-init.el")
(require 'mode-line-init)
(setq-default mode-line-format (mode-line-init))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(selectrum-prescient evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
