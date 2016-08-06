#!/bin/bash

if [ ! -d $HOME/.emacs.d ]; then
    git clone git://github.com/syl20bnr/spacemacs $HOME/.emacs.d
fi

cabal install ghc-mod stylish-haskell hlint
