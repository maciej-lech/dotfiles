;;; my-misc.el

(load-theme 'monokai t)

(add-to-list 'default-frame-alist '(height . 43))
(add-to-list 'default-frame-alist '(width . 132))

(when window-system
  (setq frame-title-format (list '(buffer-file-name "%f" ("%b"))))
  (blink-cursor-mode -1)
  (tool-bar-mode -1)
  (when (require 'mwheel nil 'no-error) (mouse-wheel-mode t)))

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq visible-bell t
      echo-keystrokes 0.1
      font-lock-maximum-decoration t
      inhibit-startup-message t
      transient-mark-mode t
      color-theme-is-global t
      delete-by-moving-to-trash t
      shift-select-mode nil
      truncate-partial-width-windows nil
      uniquify-buffer-name-style 'forward
      whitespace-style '(trailing lines space-before-tab
                                  indentation space-after-tab)
      whitespace-line-column 100
      ediff-window-setup-function 'ediff-setup-windows-plain
      oddmuse-directory (concat user-emacs-directory "oddmuse")
      xterm-mouse-mode t
      save-place-file (concat user-emacs-directory "places")
      annals-active-directory (concat user-emacs-directory "annals")
      annals-archive-directory (concat user-emacs-directory "annals/archive"))

(scroll-bar-mode -1)
(menu-bar-mode -1)

(powerline-center-theme)
(setq powerline-default-separator 'wave)

(global-auto-complete-mode)
(ac-config-default)
(setq ac-use-quick-help t)

(global-nlinum-mode)

(autopair-global-mode)

(global-undo-tree-mode)

(auto-compression-mode t)

(recentf-mode 1)

(show-paren-mode 1)

(ido-mode t)
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-create-new-buffer 'always
      ido-use-filename-at-point t
      ido-max-prospects 10)

;;(desktop-save-mode 1)

(setq nameses-ido-mode 1)

;;(set-default 'indent-tabs-mode nil)
(set-default 'indicate-empty-lines t)
(set-default 'imenu-auto-rescan t)

(add-hook 'text-mode-hook 'turn-on-auto-fill)
(eval-after-load "ispell"
  '(when (executable-find ispell-program-name)
     (add-hook 'text-mode-hook 'turn-on-flyspell)))

(defvar my-coding-hook nil
  "Hook that gets run on activation of any programming mode.")

(defalias 'yes-or-no-p 'y-or-n-p)
;; Seed the random-number generator
(random t)

(defun my-pretty-lambdas ()
  (font-lock-add-keywords
   nil `(("(\\(lambda\\>\\)"
          (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                    ,(make-char 'greek-iso8859-7 107))
                    nil))))))

(when (boundp 'hippie-expand-try-functions-list)
  (delete 'try-expand-line hippie-expand-try-functions-list)
  (delete 'try-expand-list hippie-expand-try-functions-list))

(setq backup-directory-alist `(("." . ,(expand-file-name
                                        (concat user-emacs-directory "backups")))))

(setq diff-switches "-u")

(eval-after-load 'diff-mode
  '(progn
     (set-face-foreground 'diff-added "green4")
     (set-face-foreground 'diff-removed "red3")))
