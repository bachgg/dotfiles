## What
Archlinux, Wayland, Niri window manager & everything else. Check `./installation` directory for  details.

## How
### Inside ArchISO
`iwctl station wlan0 connect <A Wifi Network>`

`sh <(curl -fsSL bachgg.github.io/dotfiles/install.sh)`

This runs the `archinstall` TUI.

### After reboot
`sh <(curl -fsSL bachgg.github.io/dotfiles/install.sh)`

This installs everything declared in `./installation` directory.

### Ansible-based (v2, experimental)
The same flow is also available via Ansible. See [ansible/](ansible/).

```sh
sh <(curl -fsSL bachgg.github.io/dotfiles/install_v2.sh)
# or, with a slice / dry-run:
cd ~/dotfiles/ansible
ansible-playbook -i inventory.ini playbook.yml -K --tags shell --check
```
## What works
- [x] Wifi
- [x] Bluetooth
- [x] Audio + Bluetooth headphones
- [x] Webcam & screensharing
- [x] Brightness & volume control keys
- [x] Screenshot
- [ ] Screencast
- [ ] Universal copy/paste shortcut (instead of Ctrl + Shift + C inside terminal and Ctrl + C everywhere else)
- [ ] Special characters shortcut (ä, ö, ü & ß)
- [ ] Windows/MacOS-like window cycling with Super + Tab
