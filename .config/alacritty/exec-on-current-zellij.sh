#!/bin/sh
SESSION=$(cat /Users/jimmy/.config/current_zellij_session)
SESSION_ARG="--session $SESSION"
/opt/homebrew/bin/zellij $SESSION_ARG $@

