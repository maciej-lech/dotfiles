;;; my-custom.el

;; load user/system specific files
(cl-flet ((sk-load (base)
         (let* ((path          (expand-file-name base user-emacs-directory))
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
  (let ((user-dir (expand-file-name user-login-name user-emacs-directory)))
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

;;; load custom
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)
