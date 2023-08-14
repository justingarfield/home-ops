#!/usr/bin/env bash

# Huge thanks to https://fabianlee.org/2021/06/09/bash-using-printf-to-display-fixed-width-padded-string/ for the padding infos :)

# length of maximum padding
padding="....................................................."

function paddedMessage() {
    printf "%s%s %s\n" "$1" "${padding:${#1}}" "$2"
}
