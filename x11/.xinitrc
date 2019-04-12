#!/bin/sh
[[ -f ~/.Xresources ]] && xrdb ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -f ~/.xprofile ]] && . ~/.xprofile

exec i3
