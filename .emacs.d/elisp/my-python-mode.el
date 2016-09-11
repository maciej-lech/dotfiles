;;; python.el

(require 'python-mode)

(elpy-enable)
;;(setq elpy-rpc-backend "jedi")

(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
