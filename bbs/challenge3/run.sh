#!/opt/pwn.college/bash

set -euo pipefail

cd /challenge
source ./lib/ansi.sh
source ./lib/bbs_core.sh

expected_hash="$(load_expected_hash ./meta/flag.sha256)"
solved=0

render_screen() {
  draw_header "Challenge 3: Door Game Backdoor"
  draw_retro_logo
  draw_signal_meter
  printf '\n'
  cat <<'ART'
      _______________________________
     /  GALACTIC TRADE DOOR ARCADE  \\
    |  __  __  __  __  __  __  __   |
    | |__||__||__||__||__||__||__|  |
    |   INPUT TRUST RISK: ACTIVE    |
     \_______________________________/
ART
  printf '\n'
  printf '%b' "${C_YLW}Objective:${C_RST} Trigger legacy input flaw and recover secret.\n"
  printf '%b' "${C_YLW}Hint:${C_RST} Source audit reveals trust boundary failure.\n"
  if [ -f /flag ]; then
    printf '%b' "${C_GRN}/flag is available.${C_RST}\n"
  fi
  printf '\n'
}

show_bulletin() {
  render_screen
  show_module_bar "Sysop Bulletin"
  cat ./bulletin.txt
  printf '\n'
  press_any_key
}

show_doors() {
  render_screen
  show_module_bar "Door Directory"
  cat <<'DOORS'
1) galactic  - Galactic Trade Door v1.2
2) archives  - Offline (maintenance)
DOORS
  printf '\n'
  press_any_key
}

launch_door() {
  render_screen
  show_module_bar "Launching Galactic Trade Door"
  bash ./door_game.sh || true
  printf '\n'
  press_any_key
}

show_source() {
  render_screen
  show_module_bar "Source Audit Console"
  cat ./door_game.sh
  printf '\n'
  press_any_key
}

submit_terminal() {
  render_screen
  show_module_bar "Flag Submit Terminal"
  printf '%b' "${C_YLW}Enter FLAG{...}:${C_RST} "
  local guess
  read_choice guess || { printf '\n'; return; }

  if submit_flag "$guess" "$expected_hash"; then
    unlock_flag_file "$guess"
    solved=1
  fi

  printf '\n'
  press_any_key
}

hub_loop() {
  local options=(
    "Read Sysop Bulletin"
    "Open Door Directory"
    "Launch Galactic Trade Door"
    "Open Source Audit Console"
    "Submit Flag"
    "Disconnect"
  )

  while [ "$solved" -eq 0 ]; do
    arrow_menu_select "Challenge 3 Hub" options pick render_screen

    case "$pick" in
      0)
        show_bulletin
        ;;
      1)
        show_doors
        ;;
      2)
        launch_door
        ;;
      3)
        show_source
        ;;
      4)
        submit_terminal
        ;;
      -1|5)
        echo "Disconnecting..."
        break
        ;;
    esac
  done
}

chmod +x ./door_game.sh

render_screen
modem_handshake
slow_print "Use arrows to navigate the door arcade and unlock /flag." 0.01
press_any_key "Press any key to enter the arcade hub..."

hub_loop
