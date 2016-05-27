;;; main.el

;; loads, etc
(let ((elisp-dir (expand-file-name "auto" my-emacs-d-elisp-dir)))
  ;; add the src directory to the load path
  (add-to-list 'load-path elisp-dir)
  ;; load specific files
  (when (file-exists-p elisp-dir)
    (let ((default-directory elisp-dir))
      (normal-top-level-add-subdirs-to-load-path))))
(setq autoload-file (concat my-emacs-d-dir "loaddefs.el"))
(setq package-user-dir (concat my-emacs-d-dir "elpa"))
(setq custom-file (concat my-emacs-d-dir "custom.el"))

;; requires
(require 'cl)
(require 'cl-lib)
(require 'saveplace)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)

;; loads other files
(load "my-packages.el")

(load "my-defuns.el")

(load "my-misc.el")

(load "my-hooks.el")

(load "my-registers.el")

(load "my-python.el")

(load "my-bindings.el")

;; load user/system specific files
(cl-flet ((sk-load (base)
         (let* ((path          (expand-file-name base my-emacs-d-dir))
                (literate      (concat path ".org"))
                (encrypted-org (concat path ".org.gpg"))
                (plain         (concat path ".el"))
                (encrypted-el  (concat path ".el.gpg")))
           (cond
            ((file-exists-p encrypted-org) (org-babel-load-file encrypted-org))
            ((file-exists-p encrypted-el)  (load encrypted-el))
            ((file-exists-p literate)      (org-babel-load-file literate))
            ((file-exists-p plain)         (load plain)))))
       (remove-extension (name)
         (string-match "\\(.*?\\)\.\\(org\\(\\.el\\)?\\|el\\)\\(\\.gpg\\)?$" name)
         (match-string 1 name)))
  (let ((user-dir (expand-file-name user-login-name my-emacs-d-dir)))
    ;; load system-specific config
    (sk-load system-name)
    ;; load user-specific config
    (sk-load user-login-name)
    ;; load any files in the user's directory
    (when (file-exists-p user-dir)
      (add-to-list 'load-path user-dir)
      (mapc #'sk-load
            (remove-duplicates
             (mapcar #'remove-extension
                     (directory-files user-dir t ".*\.\\(org\\|el\\)\\(\\.gpg\\)?$"))
             :test #'string=)))))

(load custom-file 'noerror)
