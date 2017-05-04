;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t
   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '("~/.spacemacs.d/private/")
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     csv
     sql
     yaml
     auto-completion
     syntax-checking latex
     notmuch python extra-langs c-c++
     html javascript markdown git github emacs-lisp shell
     idris asciidoc rust purescript
     nixos
     (haskell :variables haskell-enable-ghc-mod-support nil)
     )

   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages
   '(llvm-mode
     dts-mode
     groovy-mode
     visual-fill-column
     ledger-mode
     flatui-theme
     professional-theme
     )
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages
   '(
     hl-todo ;https://github.com/tarsius/hl-todo/issues/14
     )
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and uninstall any
   ;; unused packages as well as their unused dependencies.
   ;; `used-but-keep-unused' installs only the used packages but won't uninstall
   ;; them if they become unused. `all' installs *all* packages supported by
   ;; Spacemacs and never uninstall them. (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/user-config ()
  "Called at very end of initialization"

  ;; GHC development
  (dir-locals-set-class-variables
   'ghc
   '((haskell-mode . ((flycheck-disabled-checkers . (haskell-ghc))
                      (haskell-tags-on-save . nil)))
     )
   )
  (dir-locals-set-directory-class "/opt/exp/ghc" 'ghc)

  (setq-default
   auto-mode-alist
   (append '(("Parser\\.y\\'" . fundamental-mode)
             ("\\.T\\'" . python-mode)
             ("\\.dump-prep\\'" . ghc-core-mode)
             ("\\.dump-spec\\'" . ghc-core-mode)
             ("\\.dump-ds\\'" . ghc-core-mode)
             ("\\.verbose-core2core.split\\'" . ghc-core-mode)
             ("\\.verbose-core2core.split/.+\\'" . ghc-core-mode)
             )
           auto-mode-alist))

  (add-hook 'haskell-mode-hook
            (lambda ()
              (cond ((string-match "DynFlags\\.hs" (buffer-file-name)) . (flycheck-mode 0)))
              (cond ((string-match "Parser\\.y" (buffer-file-name)) . (fundamental-mode)))
              ))

  ;; Override spacemacs' silly default
  ;;(setq desktop-dirname ".")
  ;; TODO: remove below
  (with-eval-after-load 'desktop
    (setq desktop-dirname ".")
    (setq desktop-path ".")))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration."
  (setq-default
   frame-title-format "%b - emacs"
   projectile-enable-caching t

   dotspacemacs-editing-style 'vim

   ;; If non nil output loading progess in `*Messages*' buffer.
   dotspacemacs-verbose-loading nil
   dotspacemacs-startup-banner 'official
   dotspacemacs-startup-buffer-responsive t
   dotspacemacs-always-show-changelog t
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-startup-lists '(recents projects)
   dotspacemacs-themes '(zenburn
                         flatui
                         professional
                         solarized-light
                         solarized-dark
                         leuven
                         monokai)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font '("Source Code Pro"
                               :size 13
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-command-key ":"
   dotspacemacs-enable-paste-micro-state t
   dotspacemacs-guide-key-delay 0.4
   dotspacemacs-loading-progress-bar t
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup nil
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 90
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-smooth-scrolling t
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-default-package-repository nil
   )
  ;; User initialization goes here
  (add-hook 'find-file-hook 'my-find-file-check-make-large-file-read-only-hook)
  )

(defun ben-search-archive-thread ()
  "Archive the currently selected thread (remove its \"inbox\" tag).

This function advances the next thread when finished."
  (interactive)
  (notmuch-search-tag "-inbox")
  (notmuch-search-tag "-unseen")
  (notmuch-search-next-thread))

(defun notmuch-show-mark-read ()
  "Mark the current message as read."
  (notmuch-show-tag-message "-unread")
  (notmuch-show-tag-message "-unseen"))

(defun my-find-file-check-make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 10 1024 1024))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (fundamental-mode)
    (message "Buffer is set to read-only because it is large.  Undo also disabled.")
    ))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-ispell-requires 4 t)
 '(ahs-case-fold-search nil t)
 '(ahs-default-range (quote ahs-range-whole-buffer) t)
 '(ahs-idle-interval 0.25 t)
 '(ahs-idle-timer 0 t)
 '(ahs-inhibit-face-list nil t)
 '(asm-comment-char 35)
 '(browse-url-browser-function (quote browse-url-firefox))
 '(browse-url-firefox-program "firefox")
 '(compilation-message-face (quote default))
 '(confirm-kill-emacs (quote y-or-n-p))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(desktop-path (quote (".")))
 '(desktop-save (quote ask-if-new))
 '(desktop-save-mode t)
 '(evil-escape-mode nil)
 '(evil-want-Y-yank-to-eol nil)
 '(expand-region-contract-fast-key "V")
 '(expand-region-reset-fast-key "r")
 '(fci-rule-color "#383838" t)
 '(git-commit-summary-max-length 70)
 '(haskell-compile-cabal-build-command "cd %s && cabal new-build --ghc-option=-ferror-spans")
 '(haskell-indent-spaces 4)
 '(haskell-indentation-ifte-offset 4)
 '(haskell-indentation-layout-offset 4)
 '(haskell-indentation-left-offset 4)
 '(haskell-interactive-popup-error nil t)
 '(haskell-notify-p t t)
 '(haskell-process-auto-import-loaded-modules t t)
 '(haskell-process-suggest-remove-import-lines t t)
 '(haskell-process-type (quote auto))
 '(haskell-stylish-on-save nil t)
 '(haskell-tags-on-save nil)
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#fdf6e3" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#586e75")
 '(highlight-tail-colors
   (quote
    (("#eee8d5" . 0)
     ("#B4C342" . 20)
     ("#69CABF" . 30)
     ("#69B7F0" . 50)
     ("#DEB542" . 60)
     ("#F2804F" . 70)
     ("#F771AC" . 85)
     ("#eee8d5" . 100))))
 '(hl-bg-colors
   (quote
    ("#DEB542" "#F2804F" "#FF6E64" "#F771AC" "#9EA0E5" "#69B7F0" "#69CABF" "#B4C342")))
 '(hl-fg-colors
   (quote
    ("#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3")))
 '(if (version< emacs-version "24.4"))
 '(ledger-binary-path "hledger")
 '(magit-diff-use-overlays nil)
 '(magit-use-overlays nil)
 '(mail-envelope-from (quote header))
 '(mail-host-address "smart-cactus.org")
 '(mail-self-blind t)
 '(mail-specify-envelope-from t)
 '(markdown-enable-math t)
 '(message-auto-save-directory "~/.mail/drafts")
 '(message-confirm-send t)
 '(message-directory "~/.mail/")
 '(message-forward-as-mime nil)
 '(message-forward-ignored-headers
   (quote
    ("^Content-Transfer-Encoding:" "^X-" "^Received:" "^DKIM-" "^Authentication-Results:")))
 '(message-mode-hook nil)
 '(message-sendmail-envelope-from (quote header))
 '(message-sendmail-extra-arguments nil)
 '(message-sendmail-f-is-evil nil)
 '(message-setup-hook (quote (mml-secure-sign-pgpmime)))
 '(mml-secure-key-preferences
   (quote
    ((OpenPGP
      (sign
       ("Benjamin Gamari <ben@smart-cactus.org>" "9B0A6C8780B5DFE09D0D946371507CE84BEE9FBF"))
      (encrypt))
     (CMS
      (sign)
      (encrypt)))))
 '(mml-secure-openpgp-signers (quote ("Benjamin Gamari <ben@smart-cactus.org>")))
 '(mml-secure-smime-signers
   (quote
    ("Benjamin Gamari <ben@smart-cactus.org>" "Benjamin Gamari <ben@well-typed.com>")))
 '(mml2015-signers (quote ("Benjamin Gamari <ben@smart-cactus.org>")))
 '(notmuch-archive-tags (quote ("-inbox" "-unseen")))
 '(notmuch-saved-searches
   (quote
    ((:name "inbox" :query "tag:inbox" :key "i")
     (:name "well-typed" :query "tag:inbox and tag:well-typed")
     (:name "drafts" :query "tag:draft" :key "d")
     (:name "todo" :query "tag:todo")
     (:name "to-review" :query "tag:to-review")
     (:name "unseen ghc tickets" :query "tag:ghc-tickets and tag:unseen"))))
 '(notmuch-search-line-faces
   (quote
    (("unread" :weight bold)
     ("flagged" :foreground "salmon"))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-tag-formats
   (quote
    (("unread"
      (propertize tag
                  (quote face)
                  (quote
                   (:foreground "red"))))
     ("flagged"
      (notmuch-tag-format-image-data tag
                                     (notmuch-tag-star-icon))
      (propertize tag
                  (quote face)
                  (quote
                   (:foreground "blue"))))
     (".bf_ham")
     (".bf_spam")
     ("list"
      (notmuch-apply-face tag
                          (quote
                           (:foreground "dark gray"))))
     ("inbox"
      (notmuch-apply-face tag
                          (quote
                           (:foreground "deep sky blue")))))))
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(org-agenda-files
   (quote
    ("~/org/ta.org" "~/org/thesis.org" "~/org/projects.org" "~/org/tasks.org")))
 '(org-mobile-directory "/scpc:ben@mw0.mooo.com:mobile-org")
 '(package-selected-packages
   (quote
    (winum fuzzy solarized-theme groovy-mode csv-mode seq nix-mode hide-comnt helm-nixos-options company-nixos-options nixos-options pug-mode org ht yapfify py-isort dumb-jump cargo intero github-search marshal evil-unimpaired sql-indent yaml-mode purescript-mode json-snatcher prop-menu request logito pkg-info epl flx goto-chg undo-tree pos-tip uuidgen toc-org thrift org-plus-contrib org-bullets livid-mode skewer-mode simple-httpd live-py-mode link-hint hlint-refactor helm-hoogle flycheck-purescript eyebrowse evil-visual-mark-mode evil-ediff company-ghci column-enforce-mode py-yapf ledger-mode web-completion-data f packed xterm-color haml-mode gitignore-mode rustfmt eshell-z bracketed-paste bind-key psc-ide orgit help-fns+ auto-complete diminish popup bind-map hl-todo pcache persp-mode lorem-ipsum github-clone evil-indent-plus ace-jump-helm-line hydra magit-annex ws-butler evil-magit restart-emacs helm-flx helm-company evil-mc auto-compile deferred dash spaceline idris-mode markup-faces company iedit gh which-key quelpa package-build use-package s web-mode toml-mode tagedit stan-mode spacemacs-theme shell-pop racer pyvenv pytest pyenv-mode paradox notmuch neotree mmm-mode markdown-toc magit-gitflow macrostep linum-relative leuven-theme julia-mode js2-refactor info+ indent-guide ido-vertical-mode helm-swoop helm-projectile helm-make helm-ag google-translate golden-ratio github-browse-file git-link gh-md expand-region exec-path-from-shell evil-terminal-cursor-changer evil-search-highlight-persist evil-matchit evil-jumper evil-indent-textobject evil-escape elisp-slime-nav cmake-mode clean-aindent-mode aggressive-indent ace-window ace-link avy names anaconda-mode json-rpc auctex ghc dash-functional tern anzu smartparens highlight flycheck haskell-mode projectile helm helm-core parent-mode yasnippet multiple-cursors js2-mode json-reformat magit magit-popup git-commit with-editor async markdown-mode spinner rust-mode evil magit-gh-pulls professional-theme zenburn-theme wolfram-mode window-numbering web-beautify volatile-highlights visual-fill-column vi-tilde-fringe spray smooth-scrolling smeargle slim-mode shm scss-mode scad-mode sass-mode rfringe rainbow-delimiters qml-mode pythonic psci powerline popwin pip-requirements pcre2el page-break-lines open-junk-file multi-term move-text monokai-theme matlab-mode llvm-mode less-css-mode json-mode js-doc jade-mode hy-mode hungry-delete hindent highlight-parentheses highlight-numbers highlight-indentation helm-themes helm-pydoc helm-mode-manager helm-gitignore helm-descbinds helm-css-scss helm-c-yasnippet haskell-snippets gitconfig-mode gitattributes-mode git-timemachine git-messenger gist fringe-helper flycheck-rust flycheck-pos-tip flycheck-haskell flx-ido flatui-theme fill-column-indicator fancy-battery evil-visualstar evil-tutor evil-surround evil-numbers evil-nerd-commenter evil-lisp-state evil-iedit-state evil-exchange evil-args evil-anzu eval-sexp-fu eshell-prompt-extras esh-help emmet-mode dts-mode disaster define-word cython-mode company-web company-tern company-statistics company-racer company-quickhelp company-ghc company-cabal company-c-headers company-auctex company-anaconda coffee-mode cmm-mode clang-format buffer-move auto-yasnippet auto-highlight-symbol auto-dictionary arduino-mode adoc-mode adaptive-wrap ac-ispell)))
 '(pos-tip-background-color "#eee8d5")
 '(pos-tip-foreground-color "#586e75")
 '(psc-ide-add-import-on-completion t t)
 '(psc-ide-rebuild-on-save nil t)
 '(ring-bell-function (quote ignore))
 '(safe-local-variable-values
   (quote
    ((haskell-tags-on-save)
     (engine . ctemplate)
     (sgml-parent-document "users_guide.xml" "book")
     (sgml-parent-document "users_guide.xml" "book" "chapter" "sect1")
     (sgml-parent-document "users_guide.xml" "book" "chapter")
     (buffer-file-coding-system . utf-8-unix))))
 '(savehist-autosave-interval 600)
 '(select-enable-primary t)
 '(send-mail-function (quote sendmail-send-it))
 '(sendmail-program "/usr/bin/msmtp")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(sql-product (quote postgres))
 '(tags-case-fold-search nil)
 '(user-mail-address "ben@smart-cactus.org")
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(weechat-color-list
   (quote
    (unspecified "#fdf6e3" "#eee8d5" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#657b83" "#839496"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "adobe" :slant normal :weight normal :height 115 :width normal))))
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil))))
 '(evil-search-highlight-persist-highlight-face ((t (:inherit region :background "burlywood4"))))
 '(notmuch-crypto-part-header ((t (:foreground "deep sky blue"))))
 '(notmuch-tag-face ((t (:foreground "DarkSlateGray3")))))
