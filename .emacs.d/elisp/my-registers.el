
(dolist
    (r `((?i (file . ,(concat my-emacs-d-dir "init.el")))
         (?I (file . ,(let* ((user user-login-name)
                             (org (expand-file-name (concat user ".org") my-emacs-d-dir))
                             (el  (expand-file-name (concat user ".el") my-emacs-d-dir))
                             (dir (expand-file-name user my-emacs-d-dir)))
                        (cond
                         ((file-exists-p org) org)
                         ((file-exists-p el)  el)
                         (t dir)))))
         (?m (file . ,(concat my-emacs-d-elisp-dir "main.el")))
         (?r (file . ,(concat my-emacs-d-elisp-dir "registers.el")))))
  (set-register (car r) (cadr r)))
