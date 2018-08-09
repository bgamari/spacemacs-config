;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

;; From https://www.reddit.com/r/emacs/comments/67ud9h/xref_question/
(defun my/do-then-quit (&rest args)
  (let ((win (selected-window)))
    (apply (car args) (rest args))
    (quit-window nil win)))

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
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
   dotspacemacs-configuration-layer-path '( "~/.spacemacs.d/private/" )
   ;; List of configuration layers to load.
   ;; `M-m f e R' (Emacs style) to install them.
   dotspacemacs-configuration-layers
   '(octave
     helm
     emacs-lisp
     neotree
     ruby
     windows-scripts
     php
     csv
     sql
     yaml
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom)
     auto-completion
     spell-checking syntax-checking latex
     notmuch python c-c++
     html javascript markdown git github
     idris asciidoc rust purescript
     nixos
     (haskell :variables haskell-enable-ghc-mod-support nil)
     version-control
     )

   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages
   '(dts-mode
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
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/user-config ()
  "Called at very end of initialization"

  ;; From https://www.reddit.com/r/emacs/comments/67ud9h/xref_question/
  (advice-add #'xref-goto-xref :around #'my/do-then-quit)

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
    (setq desktop-path "."))

  ;; see https://github.com/NixOS/nix-mode/issues/36
  (eval-after-load 'nix-mode
    (add-hook 'nix-mode-hook
              (lambda ()
                (setq-local indent-line-function #'indent-relative)))))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   frame-title-format "%b - emacs"
   projectile-enable-caching t

   ;; File path pointing to emacs 27.1 executable compiled with support
   ;; for the portable dumper (this is currently the branch pdumper).
   ;; (default "emacs-27.0.50")
   dotspacemacs-emacs-pdumper-executable-file "emacs-27.0.50"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=~/.emacs.d/.cache/dumps/spacemacs.pdmp
   ;; (default spacemacs.pdmp)
   dotspacemacs-emacs-dumper-dump-file "spacemacs.pdmp"

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default nil)
   dotspacemacs-verify-spacelpa-archives nil

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; If non-nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-startup-lists '(recents projects)

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(zenburn
                         flatui
                         professional
                         solarized-light
                         solarized-dark
                         spacemacs-dark
                         spacemacs-light
                         leuven
                         monokai)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `vim-powerline' and `vanilla'. The first three
   ;; are spaceline themes. `vanilla' is default Emacs mode-line. `custom' is a
   ;; user defined themes, refer to the DOCUMENTATION.org for more info on how
   ;; to create your own spaceline theme. Value can be a symbol or list with\
   ;; additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 13
                               :weight normal
                               :width normal)

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, pressing
   ;; `p' several times cycles through the elements in the `kill-ring'.
   ;; (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t' or `relative' line numbers are turned on in all `prog-mode' and
   ;; `text-mode' derivatives. If set to `relative', line numbers are relative.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil
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
 '(ahs-case-fold-search nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ahs-idle-interval 0.25)
 '(ahs-idle-timer 0 t)
 '(ahs-inhibit-face-list nil)
 '(asm-comment-char 35)
 '(browse-url-browser-function (quote browse-url-firefox))
 '(browse-url-firefox-program "firefox")
 '(compilation-message-face (quote default))
 '(confirm-kill-emacs (quote y-or-n-p))
 '(csv-separators (quote ("," "	" "	")))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(desktop-path (quote (".")))
 '(desktop-save nil)
 '(desktop-save-mode nil)
 '(evil-escape-mode nil)
 '(evil-want-Y-yank-to-eol nil)
 '(expand-region-contract-fast-key "V")
 '(expand-region-reset-fast-key "r")
 '(fci-rule-color "#383838")
 '(flycheck-checkers
   (quote
    (ada-gnat asciidoctor asciidoc c/c++-clang c/c++-gcc c/c++-cppcheck cfengine chef-foodcritic coffee coffee-coffeelint coq css-csslint css-stylelint d-dmd dockerfile-hadolint elixir-dogma emacs-lisp emacs-lisp-checkdoc erlang eruby-erubis fortran-gfortran go-gofmt go-golint go-vet go-build go-test go-errcheck go-unconvert groovy haml handlebars haskell-ghc haskell-hlint html-tidy javascript-eslint javascript-jshint javascript-jscs javascript-standard json-jsonlint json-python-json less less-stylelint lua-luacheck lua perl perl-perlcritic php php-phpmd php-phpcs processing protobuf-protoc pug puppet-parser puppet-lint python-flake8 python-pylint python-pycompile r-lintr racket rpm-rpmlint markdown-mdl nix rst-sphinx rst ruby-rubocop ruby-reek ruby-rubylint ruby ruby-jruby rust-cargo rust scala scala-scalastyle scheme-chicken scss-lint scss-stylelint sass/scss-sass-lint sass scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim slim-lint sql-sqlint systemd-analyze tex-chktex tex-lacheck texinfo typescript-tslint verilog-verilator xml-xmlstarlet xml-xmllint yaml-jsyaml yaml-ruby)))
 '(git-commit-summary-max-length 70)
 '(haskell-compile-cabal-build-command "cd %s && cabal new-build --ghc-option=-ferror-spans")
 '(haskell-indent-spaces 4)
 '(haskell-indentation-ifte-offset 4)
 '(haskell-indentation-layout-offset 4)
 '(haskell-indentation-left-offset 4)
 '(haskell-interactive-popup-error nil t)
 '(haskell-notify-p t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote auto))
 '(haskell-stylish-on-save nil)
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
 '(message-ignored-mail-headers
   "^\\([GF]cc\\|Resent-Fcc\\|Xref\\|X-Draft-From\\|X-Gnus-Agent-Meta-Information\\|Date\\):")
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
    (rvm ruby-tools ruby-test-mode rubocop rspec-mode robe rbenv rake minitest chruby bundler inf-ruby ghub let-alist auctex-latexmk powershell creole-mode phpunit phpcbf php-extras php-auto-yasnippets drupal-mode php-mode ascii-art-to-unicode winum fuzzy solarized-theme groovy-mode csv-mode seq nix-mode hide-comnt helm-nixos-options company-nixos-options nixos-options pug-mode org ht yapfify py-isort dumb-jump cargo intero github-search marshal evil-unimpaired sql-indent yaml-mode purescript-mode json-snatcher prop-menu request logito pkg-info epl flx goto-chg undo-tree pos-tip uuidgen toc-org thrift org-plus-contrib org-bullets livid-mode skewer-mode simple-httpd live-py-mode link-hint hlint-refactor helm-hoogle flycheck-purescript eyebrowse evil-visual-mark-mode evil-ediff company-ghci column-enforce-mode py-yapf ledger-mode web-completion-data f packed xterm-color haml-mode gitignore-mode rustfmt eshell-z bracketed-paste bind-key psc-ide orgit help-fns+ auto-complete diminish popup bind-map hl-todo pcache persp-mode lorem-ipsum github-clone evil-indent-plus ace-jump-helm-line hydra magit-annex ws-butler evil-magit restart-emacs helm-flx helm-company evil-mc auto-compile deferred dash spaceline idris-mode markup-faces company iedit gh which-key quelpa package-build use-package s web-mode toml-mode tagedit stan-mode spacemacs-theme shell-pop racer pyvenv pytest pyenv-mode paradox notmuch neotree mmm-mode markdown-toc magit-gitflow macrostep linum-relative leuven-theme julia-mode js2-refactor info+ indent-guide ido-vertical-mode helm-swoop helm-projectile helm-make helm-ag google-translate golden-ratio github-browse-file git-link gh-md expand-region exec-path-from-shell evil-terminal-cursor-changer evil-search-highlight-persist evil-matchit evil-jumper evil-indent-textobject evil-escape elisp-slime-nav cmake-mode clean-aindent-mode aggressive-indent ace-window ace-link avy names anaconda-mode json-rpc auctex ghc dash-functional tern anzu smartparens highlight flycheck haskell-mode projectile helm helm-core parent-mode yasnippet multiple-cursors js2-mode json-reformat magit magit-popup git-commit with-editor async markdown-mode spinner rust-mode evil magit-gh-pulls professional-theme zenburn-theme web-beautify volatile-highlights visual-fill-column vi-tilde-fringe spray smooth-scrolling smeargle slim-mode shm scss-mode scad-mode sass-mode rfringe rainbow-delimiters qml-mode pythonic psci powerline popwin pip-requirements pcre2el page-break-lines open-junk-file multi-term move-text monokai-theme matlab-mode llvm-mode less-css-mode json-mode js-doc jade-mode hy-mode hungry-delete hindent highlight-parentheses highlight-numbers highlight-indentation helm-themes helm-pydoc helm-mode-manager helm-gitignore helm-descbinds helm-css-scss helm-c-yasnippet haskell-snippets gitconfig-mode gitattributes-mode git-timemachine git-messenger gist fringe-helper flycheck-rust flycheck-pos-tip flycheck-haskell flx-ido flatui-theme fill-column-indicator fancy-battery evil-visualstar evil-tutor evil-surround evil-numbers evil-nerd-commenter evil-lisp-state evil-iedit-state evil-exchange evil-args evil-anzu eval-sexp-fu eshell-prompt-extras esh-help emmet-mode dts-mode disaster define-word cython-mode company-web company-tern company-statistics company-racer company-quickhelp company-ghc company-cabal company-c-headers company-auctex company-anaconda coffee-mode cmm-mode clang-format buffer-move auto-yasnippet auto-highlight-symbol auto-dictionary arduino-mode adoc-mode adaptive-wrap ac-ispell)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(pos-tip-background-color "#eee8d5")
 '(pos-tip-foreground-color "#586e75")
 '(psc-ide-add-import-on-completion t t)
 '(psc-ide-rebuild-on-save nil t)
 '(ring-bell-function (quote ignore))
 '(safe-local-variable-values
   (quote
    ((eval c-set-offset
           (quote access-label)
           (quote -))
     (eval c-set-offset
           (quote substatement-open)
           0)
     (eval c-set-offset
           (quote arglist-cont-nonempty)
           (quote +))
     (eval c-set-offset
           (quote arglist-cont)
           0)
     (eval c-set-offset
           (quote arglist-intro)
           (quote +))
     (eval c-set-offset
           (quote inline-open)
           0)
     (eval c-set-offset
           (quote defun-open)
           0)
     (eval c-set-offset
           (quote innamespace)
           0)
     (indicate-empty-lines . t)
     (haskell-tags-on-save)
     (engine . ctemplate)
     (sgml-parent-document "users_guide.xml" "book")
     (sgml-parent-document "users_guide.xml" "book" "chapter" "sect1")
     (sgml-parent-document "users_guide.xml" "book" "chapter")
     (buffer-file-coding-system . utf-8-unix))))
 '(savehist-autosave-interval 600)
 '(select-enable-primary t)
 '(send-mail-function (quote sendmail-send-it))
 '(sendmail-program "msmtp")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(sql-product (quote postgres))
 '(tags-case-fold-search nil)
 '(user-full-name "Ben Gamari")
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
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 118 :width normal :foundry "PfEd" :family "Inconsolata"))))
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil))))
 '(evil-search-highlight-persist-highlight-face ((t (:inherit region :background "burlywood4"))))
 '(notmuch-crypto-part-header ((t (:foreground "deep sky blue"))))
 '(notmuch-tag-face ((t (:foreground "DarkSlateGray3")))))
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-ispell-requires 4 t)
 '(ahs-case-fold-search nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ahs-idle-interval 0.25)
 '(ahs-idle-timer 0 t)
 '(ahs-inhibit-face-list nil)
 '(asm-comment-char 35)
 '(browse-url-browser-function (quote browse-url-firefox))
 '(browse-url-firefox-program "firefox")
 '(compilation-message-face (quote default))
 '(confirm-kill-emacs (quote y-or-n-p))
 '(csv-separators (quote ("," "	" "	")))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(desktop-path (quote (".")))
 '(desktop-save nil)
 '(desktop-save-mode nil)
 '(evil-escape-mode nil)
 '(evil-want-Y-yank-to-eol nil)
 '(expand-region-contract-fast-key "V")
 '(expand-region-reset-fast-key "r")
 '(fci-rule-color "#383838")
 '(flycheck-checkers
   (quote
    (ada-gnat asciidoctor asciidoc c/c++-clang c/c++-gcc c/c++-cppcheck cfengine chef-foodcritic coffee coffee-coffeelint coq css-csslint css-stylelint d-dmd dockerfile-hadolint elixir-dogma emacs-lisp emacs-lisp-checkdoc erlang eruby-erubis fortran-gfortran go-gofmt go-golint go-vet go-build go-test go-errcheck go-unconvert groovy haml handlebars haskell-ghc haskell-hlint html-tidy javascript-eslint javascript-jshint javascript-jscs javascript-standard json-jsonlint json-python-json less less-stylelint lua-luacheck lua perl perl-perlcritic php php-phpmd php-phpcs processing protobuf-protoc pug puppet-parser puppet-lint python-flake8 python-pylint python-pycompile r-lintr racket rpm-rpmlint markdown-mdl nix rst-sphinx rst ruby-rubocop ruby-reek ruby-rubylint ruby ruby-jruby rust-cargo rust scala scala-scalastyle scheme-chicken scss-lint scss-stylelint sass/scss-sass-lint sass scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim slim-lint sql-sqlint systemd-analyze tex-chktex tex-lacheck texinfo typescript-tslint verilog-verilator xml-xmlstarlet xml-xmllint yaml-jsyaml yaml-ruby)))
 '(git-commit-summary-max-length 70)
 '(haskell-compile-cabal-build-command "cd %s && cabal new-build --ghc-option=-ferror-spans")
 '(haskell-indent-spaces 4)
 '(haskell-indentation-ifte-offset 4)
 '(haskell-indentation-layout-offset 4)
 '(haskell-indentation-left-offset 4)
 '(haskell-interactive-popup-error nil t)
 '(haskell-notify-p t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote auto))
 '(haskell-stylish-on-save nil)
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
 '(message-ignored-mail-headers
   "^\\([GF]cc\\|Resent-Fcc\\|Xref\\|X-Draft-From\\|X-Gnus-Agent-Meta-Information\\|Date\\):")
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
    (dhall-mode yasnippet-snippets symon string-inflection spaceline-all-the-icons all-the-icons memoize ruby-refactor ruby-hash-syntax pippel pipenv password-generator overseer nameless magithub ghub+ apiwrap magit-svn json-navigator hierarchy importmagic epc ctable concurrent impatient-mode htmlize helm-xref helm-rtags helm-purpose window-purpose imenu-list helm-notmuch google-c-style git-gutter-fringe+ git-gutter-fringe git-gutter+ git-gutter flyspell-correct-helm flyspell-correct flycheck-rtags evil-lion evil-goggles evil-cleverparens paredit editorconfig diff-hl dante lcr counsel-projectile counsel swiper ivy company-rtags rtags company-php ac-php-core xcscope centered-cursor-mode browse-at-remote font-lock+ rvm ruby-tools ruby-test-mode rubocop rspec-mode robe rbenv rake minitest chruby bundler inf-ruby ghub let-alist auctex-latexmk powershell creole-mode phpunit phpcbf php-extras php-auto-yasnippets drupal-mode php-mode ascii-art-to-unicode winum fuzzy solarized-theme groovy-mode csv-mode seq nix-mode hide-comnt helm-nixos-options company-nixos-options nixos-options pug-mode org ht yapfify py-isort dumb-jump cargo intero github-search marshal evil-unimpaired sql-indent yaml-mode purescript-mode json-snatcher prop-menu request logito pkg-info epl flx goto-chg undo-tree pos-tip uuidgen toc-org thrift org-plus-contrib org-bullets livid-mode skewer-mode simple-httpd live-py-mode link-hint hlint-refactor helm-hoogle flycheck-purescript eyebrowse evil-visual-mark-mode evil-ediff company-ghci column-enforce-mode py-yapf ledger-mode web-completion-data f packed xterm-color haml-mode gitignore-mode rustfmt eshell-z bracketed-paste bind-key psc-ide orgit help-fns+ auto-complete diminish popup bind-map hl-todo pcache persp-mode lorem-ipsum github-clone evil-indent-plus ace-jump-helm-line hydra magit-annex ws-butler evil-magit restart-emacs helm-flx helm-company evil-mc auto-compile deferred dash spaceline idris-mode markup-faces company iedit gh which-key quelpa package-build use-package s web-mode toml-mode tagedit stan-mode spacemacs-theme shell-pop racer pyvenv pytest pyenv-mode paradox notmuch neotree mmm-mode markdown-toc magit-gitflow macrostep linum-relative leuven-theme julia-mode js2-refactor info+ indent-guide ido-vertical-mode helm-swoop helm-projectile helm-make helm-ag google-translate golden-ratio github-browse-file git-link gh-md expand-region exec-path-from-shell evil-terminal-cursor-changer evil-search-highlight-persist evil-matchit evil-jumper evil-indent-textobject evil-escape elisp-slime-nav cmake-mode clean-aindent-mode aggressive-indent ace-window ace-link avy names anaconda-mode json-rpc auctex ghc dash-functional tern anzu smartparens highlight flycheck haskell-mode projectile helm helm-core parent-mode yasnippet multiple-cursors js2-mode json-reformat magit magit-popup git-commit with-editor async markdown-mode spinner rust-mode evil magit-gh-pulls professional-theme zenburn-theme web-beautify volatile-highlights visual-fill-column vi-tilde-fringe spray smooth-scrolling smeargle slim-mode shm scss-mode scad-mode sass-mode rfringe rainbow-delimiters qml-mode pythonic psci powerline popwin pip-requirements pcre2el page-break-lines open-junk-file multi-term move-text monokai-theme matlab-mode llvm-mode less-css-mode json-mode js-doc jade-mode hy-mode hungry-delete hindent highlight-parentheses highlight-numbers highlight-indentation helm-themes helm-pydoc helm-mode-manager helm-gitignore helm-descbinds helm-css-scss helm-c-yasnippet haskell-snippets gitconfig-mode gitattributes-mode git-timemachine git-messenger gist fringe-helper flycheck-rust flycheck-pos-tip flycheck-haskell flx-ido flatui-theme fill-column-indicator fancy-battery evil-visualstar evil-tutor evil-surround evil-numbers evil-nerd-commenter evil-lisp-state evil-iedit-state evil-exchange evil-args evil-anzu eval-sexp-fu eshell-prompt-extras esh-help emmet-mode dts-mode disaster define-word cython-mode company-web company-tern company-statistics company-racer company-quickhelp company-ghc company-cabal company-c-headers company-auctex company-anaconda coffee-mode cmm-mode clang-format buffer-move auto-yasnippet auto-highlight-symbol auto-dictionary arduino-mode adoc-mode adaptive-wrap ac-ispell)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(pos-tip-background-color "#eee8d5")
 '(pos-tip-foreground-color "#586e75")
 '(psc-ide-add-import-on-completion t t)
 '(psc-ide-rebuild-on-save nil t)
 '(ring-bell-function (quote ignore))
 '(safe-local-variable-values
   (quote
    ((eval c-set-offset
           (quote access-label)
           (quote -))
     (eval c-set-offset
           (quote substatement-open)
           0)
     (eval c-set-offset
           (quote arglist-cont-nonempty)
           (quote +))
     (eval c-set-offset
           (quote arglist-cont)
           0)
     (eval c-set-offset
           (quote arglist-intro)
           (quote +))
     (eval c-set-offset
           (quote inline-open)
           0)
     (eval c-set-offset
           (quote defun-open)
           0)
     (eval c-set-offset
           (quote innamespace)
           0)
     (indicate-empty-lines . t)
     (haskell-tags-on-save)
     (engine . ctemplate)
     (sgml-parent-document "users_guide.xml" "book")
     (sgml-parent-document "users_guide.xml" "book" "chapter" "sect1")
     (sgml-parent-document "users_guide.xml" "book" "chapter")
     (buffer-file-coding-system . utf-8-unix))))
 '(savehist-autosave-interval 600)
 '(select-enable-primary t)
 '(send-mail-function (quote sendmail-send-it))
 '(sendmail-program "msmtp")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(sql-product (quote postgres))
 '(tags-case-fold-search nil)
 '(user-full-name "Ben Gamari")
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
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil))))
 '(evil-search-highlight-persist-highlight-face ((t (:inherit region :background "burlywood4"))))
 '(notmuch-crypto-part-header ((t (:foreground "deep sky blue"))))
 '(notmuch-tag-face ((t (:foreground "DarkSlateGray3")))))
)
