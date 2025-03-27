; -*-Lisp-*-
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(desktop-save-mode 1)

;; set keybind to maximize emacs
(global-set-key (kbd "M-RET") 'toggle-frame-maximized)

;; beacon
;;(beacon-mode 1)

;; set custom
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; ag
;;(setq ag-executable "c:/p/ag/ag.exe")
;;(require 'ag)

(set-face-attribute 'default nil
		    :family "Dejavu Sans Mono"
		    :height 100)

;; load themes
;;(load-theme 'zenburn t)
(load-theme 'ef-dream t)
;;(load-theme 'spacemacs-dark t)
;;(load-theme 'dracula t)

;; mode lines local vars

(defface my-modeline-background
  '((t :background "#e3c9c2" :foreground "#1b1a1f" :inherit bold))
  "Face with custom background for use on the mode line.")

;; variable for buffer name in modeline
(defvar-local my-modeline-buffer-name
    '(:eval
      (when (mode-line-window-selected-p)
	(list
	 (propertize "b: " 'face 'warning)
	 (propertize (buffer-name) 'face 'my-modeline-background))))
  "Mode line construct to display the buffer name.")

;; variable for major mode customization
(defvar-local my-modeline-major-mode
    '(:eval
      (list
       (propertize "m: " 'face 'error)
       (propertize (symbol-name major-mode) 'face 'epa-validity-high)))
  "Mode line construct to display the major mode.")

(defvar-local my-modeline-line-number-mode
    '(:eval
      (propertize (line-number-mode) 'face 'epa-validity-high))
  "Mode line construct to display line numbers.")

;; mode risk-local-variable call for local variables
;; local variables must be added here before being called
(dolist (construct '(my-modeline-buffer-name
		     my-modeline-major-mode
		     my-modeline-line-number-mode))
  (put construct 'risky-local-variable t))

;;default mode line format
(setq-default mode-line-format
	      '("%e"
		"  "
		my-modeline-buffer-name
		"  "
		my-modeline-major-mode
		"  "
		my-modeline-line-number-mode))
	
(defun nshell()
  "Open a new instance of eshell"
  (interactive)
  (eshell 'N))

(require 'package)

(package-initialize)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'org-tempo)

;; hide emphasis markers globally, maybe
;;(setq org-hide-emphasis-markers t)

;; function to hide blocks in org mode
(defun org-toggle-block-startup ()
  (interactive)
  (if org-hide-block-startup
      (set-variable 'org-hide-block-startup nil)
    (set-variable 'org-hide-block-startup t))
  (org-mode-restart))

;; function to toggle org emphasis on or off with C-e e
(defun org-toggle-emphasis ()
  "Toggle hiding/showing of org emphasis markers."
  (interactive)
  (if org-hide-emphasis-markers
      (set-variable 'org-hide-emphasis-markers nil)
    (set-variable 'org-hide-emphasis-markers t))
  (org-mode-restart))

(define-key org-mode-map (kbd "C-c e") 'org-toggle-emphasis)
(define-key org-mode-map (kbd "C-c b") 'org-toggle-block-startup)

;; org mode hook to automatically set bullet and indent mode
(require 'org-bullets)
(add-hook 'org-mode-hook
	  (lambda ()
	    (org-bullets-mode 1)
	    (org-indent-mode 1)))

;; auto-switch to org-mode when an org file is opened
(setq auto-mode-alist
      '(
	("\\.org$" . org-mode)
	("\\.org.gpg$" . org-mode)
	("\\.ref$" . org-mode)
	("\\.ref.gpg$" . org-mode)
	("\\.notes$" . org-mode)))

;; load doom emacs theme
(setq doom-themes-enable-bold t
      doom-themes-enable-italic t)
;;(load-theme 'doom-one t)
(doom-themes-visual-bell-config)
(doom-themes-neotree-config)

(setq doom-themes-treemacs-theme "doom-atom")
(doom-themes-treemacs-config)
(doom-themes-org-config)

;; Emacs Dashboard config
(require 'dashboard)
(dashboard-setup-startup-hook)
(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

(setq dashboard-banner-logo-title "emcs")
(setq dashboard-startup-banner 3)
;;(setq dashboard-center-content 1)
(setq dashboard-show-shortcuts nil)

;;(setq dashboard-items '((recents . 5)
;;			(bookmarks . 5)
;;			(projects . 5)))
(setq vertico-resize nil)
(vertico-mode 1)
(marginalia-mode 1)
(file-name-shadow-mode 1)

;;kill other buffers
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer (buffer-list)))))

;;kill all dired buffers
(defun kill-all-dired-buffers ()
  "Kill all dired buffers."
  (interactive)
  (save-excursion
    (let ((count 0))
      (dolist (buffer (buffer-list))
	(set-buffer buffer)
	(when (equal major-mode 'dired-mode)
	  (setq count (1+ count))
	  (kill-buffer buffer)))
      (message "Killed %i dired buffer(s)." count))))

;; elfeed feeds
(setq elfeed-feeds (quote
		    (("https://www.reddit.com/r/linux.rss" reddit linux)
		     ("https://www.dailywire.com/feeds/rss.xml" dailywire news)
		     ("https://www.reddit.com/r/emacs.rss" reddit linux emacs)
		     ("https://hackaday.com/blog/feed/" hackaday linux hacking)
		     ("https://www.reddit.com/r/emacs_lisp.rss" reddit lisp emacs))))
