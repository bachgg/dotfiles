#!/usr/bin/env bash
# End-to-end test for the Ansible playbook inside a disposable Arch container.
#
# 1. Builds the test image.
# 2. Runs the playbook for the container-safe tag set.
# 3. Runs it again and asserts nothing changed (idempotency check).
#
# Override the tag set with TAGS=..., e.g.:
#   TAGS=bootstrap,dotfiles ./ansible/test/run.sh
#
# Roles requiring real systemd/udev (wayland, input, bluetooth, audio, desktop,
# drivers, work, reboot) are skipped by default — test those in a VM.

set -euo pipefail

IMAGE="${IMAGE:-dotfiles-test}"
TAGS="${TAGS:-bootstrap,dotfiles,shell,languages}"
SKIP_TAGS="${SKIP_TAGS:-reboot}"

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${REPO_ROOT}"

echo "==> Building image (${IMAGE})"
docker build -t "${IMAGE}" -f ansible/test/Dockerfile .

run_play() {
  docker run --rm "${IMAGE}" \
    ansible-playbook -i inventory.ini playbook.yml \
      --tags "${TAGS}" --skip-tags "${SKIP_TAGS}" \
      "$@"
}

echo "==> Syntax check"
docker run --rm "${IMAGE}" ansible-playbook playbook.yml --syntax-check

echo "==> First run (apply)"
run_play | tee /tmp/dotfiles-run1.log

echo "==> Second run (idempotency)"
run_play | tee /tmp/dotfiles-run2.log

# PLAY RECAP lines look like:
#   localhost : ok=12 changed=0 unreachable=0 failed=0 skipped=3 ...
# We want changed=0 and failed=0 on the second run.
recap="$(grep -E '^localhost\s*:' /tmp/dotfiles-run2.log | tail -n1)"
echo "Recap: ${recap}"

changed="$(printf '%s\n' "${recap}" | sed -n 's/.*changed=\([0-9]\+\).*/\1/p')"
failed="$(printf '%s\n' "${recap}" | sed -n 's/.*failed=\([0-9]\+\).*/\1/p')"

if [ -z "${changed}" ] || [ -z "${failed}" ]; then
  echo "ERROR: could not parse PLAY RECAP" >&2
  exit 2
fi
if [ "${failed}" -ne 0 ]; then
  echo "ERROR: idempotency run had ${failed} failed task(s)" >&2
  exit 1
fi
if [ "${changed}" -ne 0 ]; then
  echo "ERROR: idempotency run had ${changed} changed task(s) — playbook is not idempotent" >&2
  exit 1
fi

echo "OK: playbook applied cleanly and is idempotent for tags=${TAGS}"
