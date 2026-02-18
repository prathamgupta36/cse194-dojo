#!/opt/pwn.college/bash

if [ -t 1 ]; then
  C_RST='\033[0m'
  C_CYN='\033[36m'
  C_GRN='\033[32m'
  C_YLW='\033[33m'
  C_RED='\033[31m'
  C_MAG='\033[35m'
  C_BLU='\033[34m'
  C_WHT='\033[97m'
  C_DIM='\033[2m'
else
  C_RST=''
  C_CYN=''
  C_GRN=''
  C_YLW=''
  C_RED=''
  C_MAG=''
  C_BLU=''
  C_WHT=''
  C_DIM=''
fi

slow_print() {
  local text="$1"
  local delay="${2:-0.01}"
  local i char
  for ((i = 0; i < ${#text}; i++)); do
    char="${text:$i:1}"
    printf '%s' "$char"
    sleep "$delay"
  done
  printf '\n'
}

modem_handshake() {
  printf '%b' "${C_DIM}Dialing 555-BBS-1986...${C_RST}\n"
  sleep 0.2
  printf '%b' "${C_DIM}Carrier detected...${C_RST}\n"
  sleep 0.2
  printf '%b' "${C_GRN}CONNECT 2400${C_RST}\n"
  sleep 0.15
}

draw_header() {
  local title="$1"
  if [ -t 1 ]; then
    clear 2>/dev/null || true
  fi
  printf '%b' "${C_CYN}============================================================${C_RST}\n"
  printf '%b' "${C_CYN}                 RETRO CITY BULLETIN BOARD                  ${C_RST}\n"
  printf '%b' "${C_CYN}============================================================${C_RST}\n"
  printf '%b' "${C_YLW}${title}${C_RST}\n"
  printf '\n'
}

draw_retro_logo() {
  printf '%b' "${C_MAG}  ____  ____   ____     ____ ___ _______   __${C_RST}\n"
  printf '%b' "${C_MAG} |  _ \\| __ ) / ___|   / ___|_ _|_   _\\ \\ / /${C_RST}\n"
  printf '%b' "${C_CYN} | |_) |  _ \\| |  _   | |    | |  | |  \\ V / ${C_RST}\n"
  printf '%b' "${C_CYN} |  _ <| |_) | |_| |  | |___ | |  | |   | |  ${C_RST}\n"
  printf '%b' "${C_BLU} |_| \\_\\____/ \\____|___\\____|___| |_|   |_|  ${C_RST}\n"
  printf '%b' "${C_BLU}                    |_____|                  ${C_RST}\n"
}

draw_signal_meter() {
  printf '%b' "${C_DIM}Signal ${C_RST}${C_GRN}[#######]${C_RST} ${C_DIM}2400 baud stable${C_RST}\n"
}

draw_panel_top() {
  local title="$1"
  printf '%b' "${C_CYN}+----------------------------------------------------------+${C_RST}\n"
  printf "${C_CYN}| ${C_YLW}%-56s${C_CYN} |${C_RST}\n" "$title"
  printf '%b' "${C_CYN}+----------------------------------------------------------+${C_RST}\n"
}

draw_panel_item() {
  local key="$1"
  local text="$2"
  printf "${C_CYN}| ${C_MAG}[%s]${C_RST} %-52s${C_CYN} |${C_RST}\n" "$key" "$text"
}

draw_panel_bottom() {
  printf '%b' "${C_CYN}+----------------------------------------------------------+${C_RST}\n"
}

scanline() {
  local text="$1"
  printf '%b' "${C_DIM}> ${text}${C_RST}\n"
  sleep 0.06
}
