#!/bin/bash

THEME_NAME=vienna
THEME_URL=https://github.com/keichi/vienna

# Intall hugo by golang.
go get -v github.com/spf13/hugo

# Clone theme if not exists.
if [ ! -d themes/$THEME_NAME ]; then
  git clone $THEME_URL themes/$THEME_NAME
fi

# Build.
hugo -t $THEME_NAME
