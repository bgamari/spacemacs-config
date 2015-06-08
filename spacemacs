(defun dotspacemacs/layers ()
  "Configuration Layers declaration."
  (setq-default
   dotspacemacs-configuration-layer-path '("~/.spacemacs-config/private/")
   dotspacemacs-configuration-layers
   '(
     syntax-checking
     haskell notmuch python extra-langs c-c++
     html javascript markdown git
     )
   dotspacemacs-excluded-packages '()
   dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration."
  (setq-default
   frame-title-format "%b - emacs"

   dotspacemacs-editing-style 'vim
   dotspacemacs-additional-packages '(llvm-mode dts-mode)
   ;; If non nil output loading progess in `*Messages*' buffer.
   dotspacemacs-verbose-loading nil
   dotspacemacs-startup-banner 'official
   dotspacemacs-always-show-changelog t
   dotspacemacs-startup-lists '(recents projects)
   dotspacemacs-themes '(zenburn
                         solarized-light
                         solarized-dark
                         leuven
                         monokai
                         zenburn)
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
   dotspacemacs-persistent-server t
   dotspacemacs-default-package-repository nil
   )
  ;; User initialization goes here
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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-ispell-requires 4)
 '(ahs-case-fold-search nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ahs-idle-interval 0.25)
 '(ahs-idle-timer 0 t)
 '(ahs-inhibit-face-list nil)
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(expand-region-contract-fast-key "V")
 '(expand-region-reset-fast-key "r")
 '(haskell-indentation-left-offset 4)
 '(haskell-interactive-popup-error nil t)
 '(haskell-notify-p t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote auto))
 '(haskell-stylish-on-save nil)
 '(haskell-tags-on-save t)
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
 '(magit-diff-use-overlays nil)
 '(mail-envelope-from (quote header))
 '(mail-host-address "smart-cactus.org")
 '(mail-self-blind t)
 '(mail-specify-envelope-from t)
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
 '(mml2015-signers (quote ("Benjamin Gamari <ben@smart-cactus.org>")))
 '(notmuch-archive-tags (quote ("-inbox" "-unseen")))
 '(notmuch-saved-searches
   (quote
    ((:name "inbox" :query "tag:inbox" :key "i")
     (:name "unread" :query "tag:unread and tag:unseen" :key "u")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "t")
     (:name "drafts" :query "tag:draft" :key "d")
     (:name "all mail" :query "*" :key "a"))))
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
 '(org-agenda-files
   (quote
    ("~/org/ta.org" "~/org/thesis.org" "~/org/projects.org" "~/org/tasks.org")))
 '(org-mobile-directory "/scpc:ben@mw0.mooo.com:mobile-org")
 '(pos-tip-background-color "#eee8d5")
 '(pos-tip-foreground-color "#586e75")
 '(ring-bell-function (quote ignore) t)
 '(safe-local-variable-values
   (quote
    ((sgml-parent-document "users_guide.xml" "book")
     (sgml-parent-document "users_guide.xml" "book" "chapter" "sect1")
     (sgml-parent-document "users_guide.xml" "book" "chapter")
     (buffer-file-coding-system . utf-8-unix))))
 '(send-mail-function (quote sendmail-send-it))
 '(sendmail-program "/usr/local/bin/msmtp")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(user-mail-address "ben@smart-cactus.org")
 '(weechat-color-list
   (quote
    (unspecified "#fdf6e3" "#eee8d5" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#657b83" "#839496")))
 '(x-select-enable-primary t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:foreground "#DCDCCC" :background "#3F3F3F"))))
 '(notmuch-crypto-part-header ((t (:foreground "deep sky blue"))))
 '(notmuch-tag-face ((t (:foreground "DarkSlateGray3")))))

