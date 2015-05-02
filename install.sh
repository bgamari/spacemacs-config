#!/bin/bash

if [ ! -d $HOME/.emacs.d ]; then
    git clone git://github.com/syl20bnr/spacemacs $HOME/.emacs.d
fi

ln -s .emacs.d/init.el $HOME/.emacs
ln -s .spacemacs-config/spacemacs $HOME/.spacemacs

cabal install ghc-mod stylish-haskell hlint
