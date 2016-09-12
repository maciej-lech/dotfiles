;;; init.el --- Where all the magic begins

(package-initialize)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(setq user-emacs-elisp-directory (expand-file-name "elisp" user-emacs-directory))
(add-to-list 'load-path user-emacs-elisp-directory)

(let ((elisp-auto-dir (expand-file-name "auto" user-emacs-elisp-directory)))
  ;; add the auto directory to the load path
  (add-to-list 'load-path elisp-auto-dir)
  ;; load specific files
  (when (file-exists-p elisp-auto-dir)
    (let ((default-directory elisp-auto-dir))
      (normal-top-level-add-subdirs-to-load-path))))

(require 'my-packages)

(load custom-file)

(require 'cl)
(require 'cl-lib)
(require 'saveplace)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)
(require 'auto-complete)
(require 'auto-complete-config)
(require 'ido)
(require 'desktop)
(require 'nameses)
(require 'annals)

(load "my-defuns.el")
(load "my-misc.el")
(load "my-hooks.el")
(load "my-registers.el")
(load "my-python-mode.el")
(load "my-eshell-mode.el")
(load "my-bindings.el")
(load "my-custom.el")
