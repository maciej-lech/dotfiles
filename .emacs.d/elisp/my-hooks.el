;;; my-hooks.el

(add-hook 'my-coding-hook 'my-local-column-number-mode)

(add-hook 'my-coding-hook 'my-local-comment-auto-fill)

(when (window-system)
  (add-hook 'my-coding-hook 'my-pretty-lambdas))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
