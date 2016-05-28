;;; my-packages.el

(let ((elisp-dir (expand-file-name "auto" my-emacs-d-elisp-dir)))
  ;; add the auto directory to the load path
  (add-to-list 'load-path elisp-dir)
  ;; load specific files
  (when (file-exists-p elisp-dir)
    (let ((default-directory elisp-dir))
      (normal-top-level-add-subdirs-to-load-path))))

(setq autoload-file (concat my-emacs-d-dir "loaddefs.el"))
(setq package-user-dir (concat my-emacs-d-dir "elpa"))

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

(setq package-archives
      '(("gnu"         . "http://elpa.gnu.org/packages/")
        ("org"         . "http://orgmode.org/elpa/")
        ("melpa"       . "http://melpa.org/packages/")
        ("marmalade"   . "http://marmalade-repo.org/packages/")))
(package-initialize)

(defvar my-packages
  '(magit
    smex
    auto-complete
    nlinum
    autopair
    undo-tree
    ace-jump-mode
    powerline
    projectile
    python-mode
    ac-python
    epc
    jedi
    elpy
    pep8
    rope-read-mode)
  "Libraries that should be installed by default (currently none).")

(defun my-loadable-p (package)
  "Check if PACKAGE is loadable from a directory in `load-path'."
  (let ((load-file (concat (symbol-name package) ".el")))
    (catch 'file-found
      (dolist (dir load-path)
        (let ((path (expand-file-name load-file dir)))
          (when (file-exists-p path)
            (throw 'file-found path)))))))

(defun my-install-if-needed (&rest packages)
  "Install PACKAGES using ELPA if they are not loadable or installed locally."
  (when packages
    (unless package-archive-contents
      (package-refresh-contents))
    (dolist (package packages)
      (unless (or (my-loadable-p package)
                  (package-installed-p package))
        (package-install package)))))

(defun my-load (file &optional header-or-tag)
  "Load configuration from other my-*.org files.
If the optional argument is the id of a subtree then only
configuration from within that subtree will be loaded.  If it is
not an id then it will be interpreted as a tag, and only subtrees
marked with the given tag will be loaded.

For example, to load all of my-lisp.org simply
add (my-load \"lisp\") to your configuration.

To load only the 'window-system' config from
my-misc-recommended.org add
 (my-load \"misc-recommended\" \"window-system\")
to your configuration."
  (let ((file (expand-file-name (if (string-match "my-.+\.org" file)
                                    file
                                  (format "my-%s.org" file))
                                my-emacs-d-dir)))
    (org-babel-load-file
     (if header-or-tag
         (let* ((base (file-name-nondirectory file))
                (dir  (file-name-directory file))
                (partial-file (expand-file-name
                               (concat "." (file-name-sans-extension base)
                                       ".part." header-or-tag ".org")
                               dir)))
           (unless (file-exists-p partial-file)
             (with-temp-file partial-file
               (insert
                (with-temp-buffer
                  (insert-file-contents file)
                  (save-excursion
                    (condition-case nil ;; collect as a header
                        (progn
                          (org-link-search (concat"#"header-or-tag))
                          (org-narrow-to-subtree)
                          (buffer-string))
                      (error ;; collect all entries with as tags
                       (let (body)
                         (org-map-entries
                          (lambda ()
                            (save-restriction
                              (org-narrow-to-subtree)
                              (setq body (concat body "\n" (buffer-string)))))
                          header-or-tag)
                         body))))))))
           partial-file)
       file))))

;; install packages if needed
(apply 'my-install-if-needed my-packages)
