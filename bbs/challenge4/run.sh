#!/opt/pwn.college/bash

set -euo pipefail

cd /challenge
source ./lib/ansi.sh
source ./lib/bbs_core.sh

expected_hash="$(load_expected_hash ./meta/flag.sha256)"
solved=0

render_screen() {
  draw_header "Challenge 4: The Midnight Crash"
  draw_retro_logo
  draw_signal_meter
  printf '\n'
  cat <<'ART'
      ________________________________
     /   MIDNIGHT CRASH RECOVERY     \\
    |  [! ] NODE FAILURE 00:14       |
    |  [# ] FRAGMENTS IN ./stash      |
    |  [* ] REBUILD FLAG TIMELINE     |
     \________________________________/
ART
  printf '\n'
  printf '%b' "${C_YLW}Objective:${C_RST} Rebuild incident flag from encoded fragments.\n"
  printf '%b' "${C_YLW}Hint:${C_RST} Follow ops order, decode in workbench.\n"
  if [ -f /flag ]; then
    printf '%b' "${C_GRN}/flag is available.${C_RST}\n"
  fi
  printf '\n'
}

show_incident() {
  render_screen
  show_module_bar "Incident Timeline"
  cat ./incident.log
  printf '\n'
  press_any_key
}

show_ops() {
  render_screen
  show_module_bar "Ops Recovery Guide"
  cat ./ops_guide.txt
  printf '\n'
  press_any_key
}

stash_browser() {
  local options=(
    "mailbag.rot13"
    "packet.b64"
    "panic.hex"
    "Back"
  )

  while true; do
    arrow_menu_select "Stash Browser" options pick render_screen

    case "$pick" in
      -1|3)
        return
        ;;
      0)
        render_screen
        show_module_bar "mailbag.rot13"
        cat ./stash/mailbag.rot13
        printf '\n'
        press_any_key
        ;;
      1)
        render_screen
        show_module_bar "packet.b64"
        cat ./stash/packet.b64
        printf '\n'
        press_any_key
        ;;
      2)
        render_screen
        show_module_bar "panic.hex"
        cat ./stash/panic.hex
        printf '\n'
        press_any_key
        ;;
    esac
  done
}

decode_workbench() {
  local modes=(
    "ROT13"
    "BASE64"
    "HEX"
    "Back"
  )

  local mode_idx payload

  while true; do
    arrow_menu_select "Decode Workbench" modes mode_idx render_screen

    case "$mode_idx" in
      -1|3)
        return
        ;;
      0)
        render_screen
        show_module_bar "ROT13 Decoder"
        printf '%b' "${C_YLW}Payload:${C_RST} "
        read_choice payload || { printf '\n'; return; }
        printf '%b' "${C_GRN}Decoded:${C_RST} $(decode_rot13 "$payload")\n\n"
        press_any_key
        ;;
      1)
        render_screen
        show_module_bar "Base64 Decoder"
        printf '%b' "${C_YLW}Payload:${C_RST} "
        read_choice payload || { printf '\n'; return; }
        printf '%b' "${C_GRN}Decoded:${C_RST} "
        decode_b64 "$payload" || true
        printf '\n'
        press_any_key
        ;;
      2)
        render_screen
        show_module_bar "Hex Decoder"
        printf '%b' "${C_YLW}Payload:${C_RST} "
        read_choice payload || { printf '\n'; return; }
        printf '%b' "${C_GRN}Decoded:${C_RST} "
        decode_hex "$payload" || true
        printf '\n'
        press_any_key
        ;;
    esac
  done
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
    "Incident Timeline"
    "Ops Recovery Guide"
    "Stash Browser"
    "Decode Workbench"
    "Submit Flag"
    "Disconnect"
  )

  while [ "$solved" -eq 0 ]; do
    arrow_menu_select "Challenge 4 Hub" options pick render_screen

    case "$pick" in
      0)
        show_incident
        ;;
      1)
        show_ops
        ;;
      2)
        stash_browser
        ;;
      3)
        decode_workbench
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

render_screen
modem_handshake
slow_print "Use arrows to traverse recovery modules and unlock /flag." 0.01
press_any_key "Press any key to enter the recovery hub..."

hub_loop
