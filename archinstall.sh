# iwctl station wlan0 connect wifi_name

# curl -fsSL0 moppediert.github.io/dotfiles/archinstall.sh && sh -e archinstall.sh

curl -fsSLO moppediert.github.io/dotfiles/user_configuration.json
curl -fsSLO moppediert.github.io/dotfiles/user_credentials.json
echo "Archinstall password: "
read -s archinstall_password
archinstall --config user_configuration.json --creds user_credentials.json --creds-decryption-key "${archinstall_password}"
