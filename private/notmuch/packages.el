;;; packages.el --- notmuch Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq notmuch-packages
  '(notmuch)
)

(setq notmuch-excluded-packages '())

(defun notmuch/init-notmuch ()
  "Initialize notmuch"
  (use-package notmuch
    :defer t
    :config
    (progn
     ;; Fix helm
     ;; See id:m2vbonxkum.fsf@guru.guru-group.fi
     (setq notmuch-address-selection-function
           (lambda (prompt collection initial-input)
             (completing-read prompt (cons initial-input collection) nil t nil 'notmuch-address-history)))

     ;;(spacemacs/declare-prefix-for-mode 'notmuch-show-mode "n" "notmuch")
     ;;(spacemacs/declare-prefix-for-mode 'notmuch-show-mode "n." "MIME parts")

     (evilify notmuch-hello-mode notmuch-hello-mode-map)
     (evilify notmuch-show-mode notmuch-show-stash-map)
     (evilify notmuch-show-mode notmuch-show-part-map)
     (evilify notmuch-show-mode notmuch-show-mode-map
              (kbd "N") 'notmuch-show-next-message
              (kbd "n") 'notmuch-show-next-open-message)
     (evilify notmuch-tree-mode notmuch-tree-mode-map)
     (evilify notmuch-search-mode notmuch-search-mode-map)
     (evil-define-key 'visual notmuch-search-mode-map
              "*" 'notmuch-search-tag-all
              "a" 'notmuch-search-archive-thread
              "-" 'notmuch-search-remove-tag
              "+" 'notmuch-search-add-tag)

     (evil-leader/set-key-for-mode 'notmuch-show-mode
       "nc" 'notmuch-show-stack-cc
       "n|" 'notmuch-show-pipe-message
       "nw" 'notmuch-show-save-attachments
       "nv" 'notmuch-show-view-raw-message)
     )))
