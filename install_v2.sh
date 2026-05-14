#!/usr/bin/env bash
# Ansible-based bootstrap entrypoint (v2).
#   sh <(curl -fsSL https://bachgg.github.io/dotfiles/install_v2.sh)
#
# Phase 1 (ArchISO):       run archinstall.
# Phase 2 (installed sys): install ansible, clone repo, run playbook.
# Extra args are passed straight to ansible-playbook, e.g.:
#   install_v2.sh --tags shell
#   install_v2.sh --check
#   install_v2.sh --skip-tags reboot

set -euo pipefail

REPO_URL="https://github.com/bachgg/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"
BASE_URL="https://bachgg.github.io/dotfiles"

# --- Phase 1: ArchISO -------------------------------------------------------
if [ -d /run/archiso ]; then
  curl -fsSLO "${BASE_URL}/user_configuration.json"
  curl -fsSLO "${BASE_URL}/user_credentials.json"
  read -r -s -p "Archinstall password: " archinstall_password
  echo
  archinstall \
    --config user_configuration.json \
    --creds  user_credentials.json \
    --creds-decryption-key "${archinstall_password}"
  exit 0
fi

# --- Phase 2: installed system ---------------------------------------------
sudo pacman -Sy --needed --noconfirm git ansible base-devel

if [ ! -d "${DOTFILES_DIR}" ]; then
  git clone --recurse-submodules "${REPO_URL}" "${DOTFILES_DIR}"
fi

cd "${DOTFILES_DIR}/ansible"
ansible-galaxy collection install -r requirements.yml

exec ansible-playbook -i inventory.ini playbook.yml --ask-become-pass "$@"
