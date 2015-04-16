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

(defvar notmuch-packages
  '(notmuch)
)

(defvar notmuch-excluded-packages '())

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
     )))
