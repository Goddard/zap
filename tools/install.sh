#!/bin/sh
#
# This script has code initially used from github.com/ohymzsh project
# Thanks OhMyZsh for an amazing project
#
set -e

# Default settings
ZAP_ROOT=${ZAP_ROOT:-~/.zap}

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

error() {
	echo ${RED}"Error: $@"${RESET} >&2
}

setup_color() {
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
}

main() {
  setup_color
  mkdir -p "$ZAP_ROOT"
  echo "$YELLOW Downloading the latest 🗲 Zap Release $RESET"
  if command_exists wget; then
    wget -O "$ZAP_ROOT/zap-x86_64.AppImage" -q --show-progress \
      https://github.com/srevinsaju/zap/releases/download/continuous/zap-x86_64.AppImage
  elif command_exists curl; then
    curl -LJO --progress-bar -o "$ZAP_ROOT/zap-x86_64.AppImage" --silent \
      https://github.com/srevinsaju/zap/releases/download/continuous/zap-x86_64.AppImage
  else
    error Zap requires wget or curl to download the zap binary.
    exit 1
  fi
  chmod +x "$ZAP_ROOT/zap-x86_64.AppImage"
  echo "Adding zap to PATH"
  if command_exists systemd-path; then
    BIN_PATH=$(systemd-path user-binaries)
  else
    mkdir -p ~/.local/bin
    if ! echo "$PATH"|grep -q ~/.local/bin; then
      error "$HOME/.local/bin is not on PATH, Consider adding it to PATH for
      full support"
      error "Add the following lines to your ~/.bashrc or ~/.zshrc file"
      error '\nexport PATH=$PATH:~/.local/bin'
      BIN_PATH="$HOME/.local/bin"
    else
      BIN_PATH="$HOME/.local/bin"
    fi
  fi


  echo "$ZAP_ROOT/zap-x86_64.AppImage \"\$@\"" > "$BIN_PATH/zap"
  chmod +x "$BIN_PATH/zap"
  hash -r
  echo "$YELLOW 🗲 Zap $RESET is installed"
  echo ""
  echo "  • Join our chat on $BLUE Discord $RESET: https://discord.gg/Yv7KC68"
  echo "  • Found an issue? Report it now on $BLUE GitHub $RESET @ https://github.com/srevinsaju/zap/issues"
  echo "  • Have questions? Hope on to $BLUE #Appimage $RESET on IRC freenode
  .net"
  echo ""
  echo "Try it now by running $GREEN zap $RESET on your terminal"
  echo "Have fun!"

}

main "$@"