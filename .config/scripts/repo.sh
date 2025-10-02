#!/bin/bash
set -e

name="$1"
if [ -z "$name" ]; then echo "Repo name missing" && exit 1; fi
cd "$HOME/workspace" && gh repo create "$name" --private --clone
