# Minimal Arch image for testing the Ansible playbook in CI.
# Builds a non-root user with passwordless sudo, copies the repo in,
# and pre-installs the Galaxy collections so test runs are offline-friendly.
FROM archlinux:latest

RUN pacman -Syu --noconfirm \
        git ansible base-devel sudo openssh which && \
    useradd -m -G wheel -s /bin/bash tester && \
    echo 'tester ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/tester && \
    chmod 0440 /etc/sudoers.d/tester

USER tester
WORKDIR /home/tester

COPY --chown=tester:tester . /home/tester/dotfiles
WORKDIR /home/tester/dotfiles/ansible

RUN ansible-galaxy collection install -r requirements.yml
