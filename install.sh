#!/usr/bin/env bash

git submodule update --init
if [ ! -h $HOME/.emacs.d ]; then
    ln -s $HOME/.spacemacs.d/spacemacs-root $HOME/.emacs.d
fi

cabal install ghc-mod stylish-haskell hlint
