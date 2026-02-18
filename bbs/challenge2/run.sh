#!/opt/pwn.college/bash

set -euo pipefail

cd /challenge
source ./lib/ansi.sh
source ./lib/bbs_core.sh

expected_hash="$(load_expected_hash ./meta/flag.sha256)"
solved=0

render_screen() {
  draw_header "Challenge 2: The Phreaker's Trail"
  draw_retro_logo
  draw_signal_meter
  printf '\n'
  cat <<'ART'
      .----.      .----.      .----.
  ___/ 2600 \____/ TRACE\____/ LOGS \\
 /___\______ /___\______ /___\______/
ART
  printf '\n'
  printf '%b' "${C_YLW}Objective:${C_RST} Trace after-hours traffic and decode payload.\n"
  printf '%b' "${C_YLW}Hint:${C_RST} Curfew + 2600 tone lines identify the key handle.\n"
  if [ -f /flag ]; then
    printf '%b' "${C_GRN}/flag is available.${C_RST}\n"
  fi
  printf '\n'
}

show_note() {
  render_screen
  show_module_bar "Sysop Curfew Note"
  cat ./sysop_note.txt
  printf '\n'
  press_any_key
}

show_logs() {
  local mode="$1"
  render_screen
  case "$mode" in
    all)
      show_module_bar "All Call Logs"
      cat ./call_logs.log
      ;;
    2600)
      show_module_bar "2600 Hz Filter"
      grep 'tone=2600' ./call_logs.log
      ;;
    curfew)
      show_module_bar "Curfew Window Filter"
      grep -E ' 23:| 00:' ./call_logs.log
      ;;
  esac
  printf '\n'
  press_any_key
}

payload_inspector() {
  render_screen
  show_module_bar "Payload Inspector"
  printf '%b' "${C_YLW}Handle:${C_RST} "
  local handle
  read_choice handle || { printf '\n'; return; }

  handle="$(printf '%s' "$handle" | tr '[:lower:]' '[:upper:]')"
  if [ -z "$handle" ]; then
    printf '%b' "${C_RED}No handle entered.${C_RST}\n\n"
    press_any_key
    return
  fi

  local row
  row="$(awk -F'|' -v u="$handle" '$2=="user="u {print; exit}' ./call_logs.log)"
  if [ -z "$row" ]; then
    printf '%b' "${C_RED}No payload found for ${handle}.${C_RST}\n"
  else
    printf '%b' "${C_GRN}%s${C_RST}\n" "$(printf '%s\n' "$row" | awk -F'|' '{print $6}')"
  fi

  printf '\n'
  press_any_key
}

decoder_lab() {
  render_screen
  show_module_bar "Base64 Decoder Lab"
  printf '%b' "${C_YLW}Payload:${C_RST} "
  local payload
  read_choice payload || { printf '\n'; return; }

  if [ -z "$payload" ]; then
    printf '%b' "${C_RED}No payload entered.${C_RST}\n"
  else
    printf '%b' "${C_GRN}Decoded:${C_RST} "
    decode_b64 "$payload" || true
  fi

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
    "Sysop Curfew Note"
    "View 2600 Hz Logs"
    "View Curfew Timeline"
    "Payload Inspector"
    "Decoder Lab"
    "Submit Flag"
    "Disconnect"
  )

  while [ "$solved" -eq 0 ]; do
    arrow_menu_select "Challenge 2 Hub" options pick render_screen

    case "$pick" in
      0)
        show_note
        ;;
      1)
        show_logs 2600
        ;;
      2)
        show_logs curfew
        ;;
      3)
        payload_inspector
        ;;
      4)
        decoder_lab
        ;;
      5)
        submit_terminal
        ;;
      -1|6)
        echo "Disconnecting..."
        break
        ;;
    esac
  done
}

render_screen
modem_handshake
slow_print "Use arrows to navigate forensic modules and unlock /flag." 0.01
press_any_key "Press any key to enter the forensic hub..."

hub_loop
