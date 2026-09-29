;;; -*- lexical-binding: t; -*-

;; ---- UI cleanup ----
;; (menu-bar-mode / tool-bar-mode / scroll-bar-mode are GUI-only and have no
;; effect under `emacs -nw`, so they're omitted here.)
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)
(column-number-mode t)
(global-display-line-numbers-mode t)
(show-paren-mode t)
(setq-default indent-tabs-mode nil)

;; ---- Package setup ----
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(setq use-package-always-ensure t)

;; ---- Theme ----
;; installed solarized-theme via Mx package-install
(use-package emacs
  :ensure nil
  :config
  (load-theme 'solarized-dark t))

;; ---- Sane file handling ----
(setq make-backup-files nil)          ; don't scatter foo.lisp~ everywhere
(setq auto-save-default nil)
(setq create-lockfiles nil)
(recentf-mode 1)
(savehist-mode 1)
(save-place-mode 1)

;; ---- Lisp / SLIME setup ----
(use-package slime
  :config
  (setq inferior-lisp-program "sbcl")
  (setq common-lisp-hyperspec-root
        (concat "file://" (expand-file-name "~/.hyperspec/HyperSpec/")))
  (setq browse-url-browser-function 'eww-browse-url))

(use-package paredit
  :hook ((lisp-mode . paredit-mode)
         (slime-repl-mode . paredit-mode)))

(use-package rainbow-delimiters
  :hook ((lisp-mode . rainbow-delimiters-mode)
         (slime-repl-mode . rainbow-delimiters-mode)))

;; ---- Org-Mode setup ----

;; Must do this so the agenda knows where to look for my files
(setq org-agenda-files '("~/Documents/org-notes/"))

;; Associate all org files with org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)

;; Wrap the lines in org mode so that things are easier to read
(add-hook 'org-mode-hook 'visual-line-mode)

;; org-agenda config
(define-key global-map "\C-ca" 'org-agenda)

;; Capture templates taken from https://orgmode.org/manual/Capture-templates.html
(define-key global-map "\C-cc" 'org-capture)
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Documents/org-notes/todo.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+olp+datetree "~/Documents/org-notes/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ("n" "Note" entry (file+headline "~/Documents/org-notes/inbox.org" "Notes")
         "** %?")
        ("s" "Scheduled event" entry (file+headline "~/Documents/org-notes/inbox.org" "Scheduled")
         "** %? %^t")))
