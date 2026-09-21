;;; config.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

(require 'package)

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/"))

      package-archive-priorities
      '(("gnu"    . 30)
        ("nongnu" . 20)
        ("melpa"  . 10)))

(require 'use-package)

(setq use-package-always-ensure t)

(repeat-mode 1)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-message t
      use-short-answers t
      sentence-end-double-space nil)

(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (setcdr (assoc 'gnus-group-news-low-empty doom-themes-base-faces)
          '(:inherit 'gnus-group-mail-1-empty :weight 'normal))
  (load-theme 'doom-challenger-deep t))

(setq window-divider-default-right-width 1
      window-divider-default-bottom-width 1
      window-divider-default-places t)

(window-divider-mode 1)

(setq-default left-margin-width 1
              right-margin-width 1)

(setq split-height-threshold nil
      split-width-threshold 100)

(setq display-buffer-base-action
      '((display-buffer-reuse-window
         display-buffer-pop-up-window)))

(global-set-key (kbd "M-o") #'other-window)

(global-set-key (kbd "C-c w v") #'split-window-right)
(global-set-key (kbd "C-c w s") #'split-window-below)
(global-set-key (kbd "C-c w d") #'delete-window)
(global-set-key (kbd "C-c w o") #'delete-other-windows)

(global-set-key (kbd "C-c w k") #'enlarge-window)
(global-set-key (kbd "C-c w j") #'shrink-window)
(global-set-key (kbd "C-c w l") #'enlarge-window-horizontally)
(global-set-key (kbd "C-c w h") #'shrink-window-horizontally)
(global-set-key (kbd "C-c w =") #'balance-windows)

(defvar-keymap my/window-resize-repeat-map
  :repeat t
  "h" #'shrink-window-horizontally
  "j" #'shrink-window
  "k" #'enlarge-window
  "l" #'enlarge-window-horizontally)

(defun my/move-buffer-to-bottom-side ()
  (interactive)
  (let ((buf (current-buffer)))
    (delete-window)
    (display-buffer-in-side-window buf '((side . bottom) (window-height . 0.3)))))

(global-set-key (kbd "C-c w B") #'my/move-buffer-to-bottom-side)

(defun my/org-return-preserve-indent ()
  "Insert newline at same indentation level as current line."
  (interactive)
  (let ((col (current-indentation)))
    (newline)
    (indent-to col)))

(use-package org
  :ensure nil
  :custom
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-adapt-indentation nil)
  :bind
  (:map org-mode-map
        ("RET" . my/org-return-preserve-indent))
  :hook
  (org-mode . visual-line-mode)
  (org-mode . (lambda () (electric-indent-local-mode -1))))

(use-package org-modern
  :ensure t
  :custom
  (org-modern-hide-stars 'leading)
  :hook
  (org-mode . org-modern-mode))

(use-package org-appear
  :ensure t
  :after org
  :hook
  (org-mode . org-appear-mode))

(custom-set-faces
 '(org-level-1 ((t (:height 1.4 :weight bold))))
 '(org-level-2 ((t (:height 1.25 :weight bold))))
 '(org-level-3 ((t (:height 1.15 :weight bold)))))

(use-package vertico
  
  :custom
  (vertico-count 48)
  (vertico-resize t)
  (vertico-cycle t)
  :init
  (vertico-mode))


(use-package mini-frame
  :custom
  (mini-frame-show-parameters
   '((top . 40)
     (width . 0.70)
     (left . 0.5)
     (internal-border-width . 12)
     (child-frame-border-width . 1)))

  (mini-frame-resize t)
  (mini-frame-resize-min-height 1)

  ;; Must leave enough room for Vertico's candidates.
  (mini-frame-resize-max-height 50)

  :init
  (mini-frame-mode 1))

(use-package savehist
  :init
  (savehist-mode))


(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)


  (completion-category-overrides
   '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.15)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)
  :init
  (global-corfu-mode))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package consult
  :bind
  (;; Buffers
   ("C-x b" . consult-buffer)

   ;; Search current buffer
   ("C-s" . consult-line)

   ;; Search project/files with ripgrep
   ("M-s r" . consult-ripgrep)

   ;; Navigation
   ("M-g g" . consult-goto-line)
   ("M-g i" . consult-imenu)
   ("M-g o" . consult-outline)

   ;; Yank history
   ("M-y" . consult-yank-pop)))

(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings)))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(delete-selection-mode 1)

(electric-pair-mode 1)

(save-place-mode 1)

(recentf-mode 1)

(global-auto-revert-mode 1)

(winner-mode 1)

(use-package vundo
  :bind
  ("C-x u" . vundo))

(use-package which-key
  :custom
  (which-key-idle-delay 0.7)
  :init
  (which-key-mode 1))

(use-package helpful
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-h x" . helpful-command)))

(use-package magit
  :bind
  ("C-x g" . magit-status))

(use-package vterm
  :bind
  ("C-c t" . vterm)
  :custom
  (vterm-max-scrollback 10000)
  (vterm-timer-delay 0.01))

(add-to-list
 'display-buffer-alist
 '("\\*vterm\\*"
   (display-buffer-in-side-window)
   (side . bottom)
   (window-height . 0.30)))

(column-number-mode 1)

  (add-hook 'prog-mode-hook #'display-line-numbers-mode)

(use-package project
  :ensure nil)

(use-package eglot
  :ensure nil
  :commands eglot
  :bind
  (("C-c e r" . eglot-rename)
   ("C-c e a" . eglot-code-actions)
   ("C-c e f" . eglot-format)))

(use-package flymake
  :ensure nil
  :bind
  (("M-n" . flymake-goto-next-error)
   ("M-p" . flymake-goto-prev-error)
   ("C-c ! l" . consult-flymake)))

(use-package compile
  :ensure nil
  :custom
  (compilation-scroll-output 'first-error)
  :bind
  (("C-c c" . compile)
   ("C-c r" . recompile)))

(setq treesit-language-source-alist
      '((python "https://github.com/tree-sitter/tree-sitter-python")
        (go     "https://github.com/tree-sitter/tree-sitter-go")))

(when (treesit-available-p)
  (dolist (language '(python go))
    (unless (treesit-language-available-p language)
      (condition-case err
          (treesit-install-language-grammar language)
        (error
         (message "Could not install Tree-sitter grammar for %s: %s"
                  language err))))))

(defun my/go-setup ()
  (eglot-ensure)

  ;; Organize imports before saving.
  (add-hook 'before-save-hook
            (lambda ()
              (call-interactively #'eglot-code-action-organize-imports))
            nil t)

  ;; Format after imports have been organized.
  (add-hook 'before-save-hook #'eglot-format-buffer nil t))

(use-package go-ts-mode
  :ensure nil
  :mode ("\\.go\\'" . go-ts-mode)
  :hook
  (go-ts-mode . my/go-setup))

(when (eq system-type 'darwin)
  (setq mac-right-option-modifier 'none
        ns-right-option-modifier 'none))

(use-package clojure-mode
  :hook
  (clojure-mode . eglot-ensure))

(use-package cider
  :hook
  (clojure-mode . cider-mode)
  :custom
  (cider-repl-display-help-banner nil)
  (cider-save-file-on-load t)
  :bind
  (:map cider-mode-map
        ("C-c C-c" . cider-eval-defun-at-point)))

(use-package smartparens
  :hook
  ((clojure-mode
    cider-repl-mode
    emacs-lisp-mode
    lisp-mode) . smartparens-strict-mode)
  :config
  (require 'smartparens-config)
  :bind
  (:map smartparens-mode-map
        ;; Paredit-style slurp/barf. Avoids C-<arrow> which macOS
        ;; grabs for Mission Control / space switching.
        ("C-)" . sp-forward-slurp-sexp)
        ("C-}" . sp-forward-barf-sexp)
        ("C-(" . sp-backward-slurp-sexp)
        ("C-{" . sp-backward-barf-sexp)
        ("M-s"         . sp-splice-sexp)
        ("M-r"         . sp-raise-sexp)
        ("M-S"         . sp-split-sexp)
        ("M-J"         . sp-join-sexp)
        ("C-M-f"       . sp-forward-sexp)
        ("C-M-b"       . sp-backward-sexp)
        ("C-M-u"       . sp-backward-up-sexp)
        ("C-M-d"       . sp-down-sexp)
        ("C-M-k"       . sp-kill-sexp)
        ("C-M-w"       . sp-copy-sexp)
        ("C-M-t"       . sp-transpose-sexp)))

(dolist (hook '(clojure-mode-hook
                cider-repl-mode-hook
                emacs-lisp-mode-hook
                lisp-mode-hook))
  (add-hook hook (lambda () (electric-pair-local-mode -1))))

(defun clojure-auto-save-setup ()

  (setq-local auto-save-visited-interval 5)
  (auto-save-visited-mode 1))
  
(add-hook 'clojure-mode-hook #'clojure-auto-save-setup)

(defvar my/emacs-state-directory
  (expand-file-name "~/.local/state/emacs/"))

(defvar my/emacs-backup-directory
  (expand-file-name "backups/" my/emacs-state-directory))

(defvar my/emacs-autosave-directory
  (expand-file-name "autosaves/" my/emacs-state-directory))

(defvar my/emacs-lock-directory
  (expand-file-name "locks/" my/emacs-state-directory))

(dolist (dir (list my/emacs-backup-directory
                   my/emacs-autosave-directory
                   my/emacs-lock-directory))
  (make-directory dir t))

(setq backup-directory-alist
      `(("." . ,my/emacs-backup-directory)))

(setq auto-save-file-name-transforms
      `((".*" ,my/emacs-autosave-directory t)))

(setq lock-file-name-transforms
      `((".*" ,my/emacs-lock-directory t)))

(defvar my/emacs-transient-directory
  (expand-file-name "transient/" my/emacs-state-directory))

(make-directory my/emacs-transient-directory t)

(setq transient-history-file
      (expand-file-name "history.el" my/emacs-transient-directory))

(setq transient-values-file
      (expand-file-name "values.el" my/emacs-transient-directory))

(setq transient-levels-file
      (expand-file-name "levels.el" my/emacs-transient-directory))

(setq custom-file
      (expand-file-name "custom.el" user-emacs-directory))

(load custom-file 'noerror 'nomessage)
