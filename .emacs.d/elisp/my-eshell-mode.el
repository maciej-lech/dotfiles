;;; my-eshell-mode.el

(add-hook 'eshell-mode-hook (lambda ()
			      (nlinum-mode -1)))
