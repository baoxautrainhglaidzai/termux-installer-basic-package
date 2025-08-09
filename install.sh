#!/data/data/com.termux/files/usr/bin/sh

clear
echo "=============================================="
echo "        Termux Basic Package Installer        "
echo "                 by Divine =/                  "
echo "=============================================="
echo

# Kiểm tra kết nối mạng
echo "Checking internet connection..."
if ping -c 1 google.com >/dev/null 2>&1; then
  echo "Internet connection OK."
else
  echo "No internet connection detected. Please connect and try again."
  exit 1
fi
echo

spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    i=$(( (i+1) %4 ))
    printf "\r[%c] Installing..." "${spinstr:$i:1}"
    sleep $delay
  done
  printf "\r[✔] Installed     \n"
}

install_package() {
  local pkg_name=$1
  if dpkg -s "$pkg_name" >/dev/null 2>&1; then
    echo "• $pkg_name is already installed ✅"
  else
    echo "• Installing $pkg_name..."
    pkg install "$pkg_name" -y >/dev/null 2>&1 &
    spinner $!
    # Kiểm tra lại sau khi cài
    if dpkg -s "$pkg_name" >/dev/null 2>&1; then
      echo "• $pkg_name installed successfully."
    else
      echo "⚠ Failed to install $pkg_name. Please check manually."
    fi
  fi
  echo
}

echo "Updating packages..."
pkg update -y >/dev/null 2>&1 && pkg upgrade -y >/dev/null 2>&1
echo

packages=(
  git python curl perl ruby bash clang man rust
  zip unzip wget openssl openssh nodejs ffmpeg htop
  screen ripgrep fd fzf bat tealdeer tmux jq rsync mpv
  pulseaudio pv ncurses-utils
)

echo "Installing packages..."
for pkg in "${packages[@]}"; do
  install_package "$pkg"
done

echo "=============================================="
echo "✔ All packages have been installed!"
echo "=============================================="
