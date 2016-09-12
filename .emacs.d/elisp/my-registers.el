;;; my-registers.el

(dolist
    (r `((?i (file . ,(concat user-emacs-directory "init.el")))
         (?I (file . ,(let* ((user user-login-name)
                             (org (expand-file-name (concat user ".org") user-emacs-directory))
                             (el  (expand-file-name (concat user ".el") user-emacs-directory))
                             (dir (expand-file-name user user-emacs-directory)))
                        (cond
                         ((file-exists-p org) org)
                         ((file-exists-p el)  el)
                         (t dir)))))
         (?m (file . ,(concat user-emacs-elisp-directory "main.el")))
         (?r (file . ,(concat user-emacs-elisp-directory "my-registers.el")))))
  (set-register (car r) (cadr r)))
