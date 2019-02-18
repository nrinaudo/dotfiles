;TODO:
; - disable tab completion in ensime
; - better comments in ensime mode

(add-to-list 'load-path "~/.emacs.d/local/")

;; global variables
(setq
 inhibit-startup-screen t
 create-lockfiles nil
 make-backup-files nil
 column-number-mode t
 scroll-error-top-bottom t
 use-package-always-ensure t
 sentence-end-double-space nil
 mac-command-modifier 'meta
 mac-option-modifier nil
 require-final-newline t
 ns-pop-up-frames nil
 ns-right-option-modifier 'super
 org-log-done 'time
 next-line-add-newlines t
 )

(server-start)

(defalias 'list-buffers 'ibuffer)

; Makes sure trailing whitespaces are deleted whenever a buffer is saved.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; buffer local variables
(setq-default
 indent-tabs-mode nil
 tab-width 4
 c-basic-offset 4)

;; modes
(electric-indent-mode 1)
(electric-pair-mode 1)
(global-auto-revert-mode t)
(show-paren-mode 1)
(setq show-paren-style 'expression)
(setq show-paren-delay 0)

;; global keybindings
(global-unset-key (kbd "C-z"))

;; the package manager
(require 'package)
(setq
 package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                    ("org" . "http://orgmode.org/elpa/")
                    ("melpa" . "http://melpa.org/packages/")
                    ("melpa-stable" . "http://stable.melpa.org/packages/"))
 package-archive-priorities '(("melpa-stable" . 1)))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package golden-ratio
  :ensure t
  :diminish golden-ratio-mode
  :init
  (golden-ratio-mode 1))

;; - org mode ----------------------------------------------------------------------------------------------------------
;; ---------------------------------------------------------------------------------------------------------------------

(use-package ox-gfm
  :ensure t
  :init
  (eval-after-load "org"
    '(require 'ox-gfm nil t))
)

(use-package org-bullets
  :ensure t
  )

(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))




;; - Programming -------------------------------------------------------------------------------------------------------
;; ---------------------------------------------------------------------------------------------------------------------

(setq js-indent-level 2)

(use-package helm
  :bind (("M-x" . helm-M-x)
         ("C-x b"   . helm-mini)
         ("C-x C-f" . helm-find-files)
         ("C-c h o" . helm-occur))
  )

(use-package helm-projectile
  :ensure t
  :bind (("M-t" . helm-projectile-find-file)
         ("C-c p g"   . helm-projectile-find-file-dwim))
  :config
  (helm-projectile-on))

(use-package json-mode
  :mode "\\.json\\'")

(use-package yaml-mode
  :commands (yaml-mode)
  :mode ("\\.yml$" . yaml-mode))

(use-package markdown-mode
  :commands (markdown-mode)
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :config
  (add-hook 'markdown-mode-hook 'flyspell-mode)
 )

(use-package scala-mode
  :interpreter
  ("scala" . scala-mode)
  :config
  (add-hook 'scala-mode-hook 'subword-mode)
  (add-hook 'scala-mode-hook 'prettify-symbols-mode)
)

(use-package haskell-mode
  :ensure t
  :mode "\\.hs\\'"
  :init
  (add-hook 'haskell-mode-hook 'haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
  )

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  )

(use-package flycheck-haskell
  :init
  (add-hook 'haskell-mode-hook #'flycheck-haskell-setup)
)


;; (use-package flymake-cursor)

;; (use-package flymake-hlint
;;   :init
;;   (add-hook 'haskell-mode-hook 'flymake-hlint-load)
;; )

(setq
 haskell-font-lock-symbols 'unicode
 haskell-stylish-on-save t
 haskell-hoogle-command "hoogle --link"
)

(use-package ensime
  :ensure t
  :pin melpa-stable
  :init
  (setq
   ensime-startup-notification nil
   ensime-startup-snapshot-notification nil))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package exec-path-from-shell
  :ensure t
  )

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; - Appearance --------------------------------------------------------------------------------------------------------
;; ---------------------------------------------------------------------------------------------------------------------

(defconst
  pretty-symbols
  '(("<=" . ?≤)
    (">=" . ?≥)
    ("->" . ?→)
    ("<-" . ?←)
    ("=>" . ?⇒)
    ("<=>" . ?⇔)
    ("-->" . ?⟶)
    ("<->" . ?↔)
    ("<--" . ?⟵)
    ("<-->" . ?⟷)
    ("==>" . ?⟹)
    ("<==" . ?⟸)
    ("<==>" . ?⟺)
    ("~>" . ?⇝)
    ("<~" . ?⇜)
    ("++" . ?⧺)
    ("::" . ?⸬)
    ("..." . ?…)
    )
  "Prettify rules.")

(add-hook 'prog-mode-hook  (lambda ()
                             (setq prettify-symbols-alist pretty-symbols)))
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; Solarized
(setq color-themes '())
(use-package color-theme-solarized
  :config
  (customize-set-variable 'frame-background-mode 'dark)
  (load-theme 'solarized t))

(use-package linum
  :init (global-linum-mode t)
  )
(line-number-mode 1)
(column-number-mode 1)
(global-linum-mode 1)

(use-package fill-column-indicator
  :commands (fci-mode)
  :init
  (progn
    (add-hook 'prog-mode-hook 'fci-mode)
    (setq fci-rule-color "#073642"
          fci-rule-column 120)))

(use-package highlight-indent-guides
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'highlight-indent-guides-mode)
  (setq highlight-indent-guides-method 'column)
)

(set-default-font "Pragmata Pro")
(set-face-attribute 'default nil :font "Pragmata Pro" :height 100)
(set-face-font 'default "Pragmata Pro")

;; Highlights the current line.
(global-hl-line-mode 1)

;; Disables useless things.
(tool-bar-mode -1)
(menu-bar-mode 0)



; - Keyboard shortcuts -------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------
(bind-keys*
 ("M-p"     . backward-paragraph)
 ([home]    . beginning-of-line)
 ([end]     . end-of-line)
 ([C-end]   . end-of-buffer)
 ([C-home]  . beginning-of-buffer)
 ([C-right] . forward-word)
 ([C-left]  . backward-word)
 ("M-n"     . forward-paragraph)
 ("M-]"     . next-buffer)
 ("M-["     . previous-buffer))

(progn
  (require 'windmove)
  ;; use Shift+arrow_keys to move cursor around split panes
  (windmove-default-keybindings)
  ;; when cursor is on edge, move to the other side, as in a torus space
  (setq windmove-wrap-around t )
)

;; Maximises emacs on startup
(toggle-frame-maximized)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(frame-background-mode (quote dark))
 '(package-selected-packages
   (quote
    (flycheck-haskell flycheck yaml-mode use-package ox-gfm org-bullets minimap markdown-mode magit json-mode hydra highlight-indent-guides helm-projectile haskell-mode golden-ratio flymake-hlint flymake-cursor fill-column-indicator exec-path-from-shell ensime color-theme-solarized))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
