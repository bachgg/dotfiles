FROM --platform=amd64 archlinux:latest

RUN pacman -Sy --noconfirm sudo git
RUN groupadd -g 1000 megroup && useradd -m -u 1000 -g megroup me
RUN echo 'abc' | passwd me -s
RUN echo 'me   ALL=(ALL:ALL) ALL' >> /etc/sudoers

WORKDIR /home/me

USER me
