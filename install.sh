#!/data/data/com.termux/files/usr/bin/sh

clear
printf "\e[1;35m"
echo "=============================================="
echo "         Termux Basic Package Installer       "
echo "               by Divine =/                   "
echo "=============================================="
printf "\e[0m\n"

echo -e "\e[1;36m[~] Checking internet connection...\e[0m"
if ! ping -c 1 google.com >/dev/null 2>&1; then
  echo -e "\e[1;31m[✘] No internet connection. Please connect!\e[0m"
  exit 1
fi
echo -e "\e[1;32m[✔] Internet OK.\e[0m\n"

spinner() {
  local pid=$1
  local delay=0.08
  local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    i=$(( (i+1) %10 ))
    printf "\r\e[1;33m[%s] Installing...\e[0m" "${spinstr:$i:1}"
    sleep $delay
  done
  printf "\r\e[1;32m[✔] Done!         \e[0m\n"
}

progress_bar() {
  local width=30
  for ((i=0; i<=width; i++)); do
    printf "\r\e[1;34m[%-*s] %d%%\e[0m" $width "$(printf '#%.0s' $(seq 1 $i))" $(( i * 100 / width ))
    sleep 0.03
  done
  echo
}

echo -e "\e[1;36m[~] Updating Termux packages...\e[0m"
pkg update -y >/dev/null 2>&1 && pkg upgrade -y >/dev/null 2>&1 &
spinner $!
echo

packages=(
  git python curl perl ruby bash clang man rust
  zip unzip wget openssl openssh nodejs ffmpeg htop
  screen ripgrep fd fzf bat tealdeer tmux jq rsync mpv
  pulseaudio pv ncurses-utils
)

echo -e "\e[1;36m[~] Installing packages...\e[0m"
for pkg in "${packages[@]}"; do
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    echo -e "• \e[1;32m$pkg already installed\e[0m"
  else
    echo -ne "• Installing \e[1;33m$pkg\e[0m..."
    pkg install "$pkg" -y >/dev/null 2>&1 &
    spinner $!
  fi
done

echo
echo -e "\e[1;35m[~] Finalizing setup...\e[0m"
progress_bar
echo
echo -e "\e[1;32m=============================================="
echo "   ✔ All packages have been installed!        "
echo "==============================================\e[0m"
