;;; init.el --- Where all the magic begins
;;
;; Originally based on https://github.com/eschulte/emacs24-my

(package-initialize)

;; load Org-mode from source when the ORG_HOME environment variable is set
(when (getenv "ORG_HOME")
  (let ((org-lisp-dir (expand-file-name "lisp" (getenv "ORG_HOME"))))
    (when (file-directory-p org-lisp-dir)
      (add-to-list 'load-path org-lisp-dir)
      (require 'org))))

;; load the rest of the configuration in `after-init-hook'
(add-hook 'after-init-hook
 `(lambda ()
    ;; remember this directory
    (setq my-emacs-d-dir
          ,(file-name-directory (or load-file-name (buffer-file-name))))
    ;; remember elisp directory
    (setq my-emacs-d-elisp-dir
	  (expand-file-name "elisp" my-emacs-d-dir))
    (add-to-list 'load-path my-emacs-d-elisp-dir)
    ;; only load org-mode later if we didn't load it just now
    ,(unless (and (getenv "ORG_HOME")
                  (file-directory-p (expand-file-name "lisp"
                                                      (getenv "ORG_HOME"))))
       '(require 'org))
    ;; load up the starter kit
    (load "main")))
