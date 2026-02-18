#!/usr/bin/exec-suid -- /bin/bash
set -euo pipefail

cd /challenge
source ./lib/ansi.sh
source ./lib/bbs_core.sh

expected_hash="$(load_expected_hash ./meta/flag.sha256)"
solved=0

mail_subjects=(
  "Welcome to Retro City"
  "Modem Etiquette Tips"
  "Rules Follow-up"
  "Private: Sysop Welcome Gift"
)

mail_files=(
  "./mail/01_welcome.txt"
  "./mail/02_modem_tips.txt"
  "./mail/03_rules_followup.txt"
  "./mail/04_sysop_gift.txt"
)

mail_read=(0 0 0 0)

intro_mail_unlocked() {
  [ "${mail_read[0]}" -eq 1 ] && [ "${mail_read[1]}" -eq 1 ] && [ "${mail_read[2]}" -eq 1 ]
}

mail_progress() {
  local count=0
  local idx
  for idx in 0 1 2; do
    if [ "${mail_read[$idx]}" -eq 1 ]; then
      count=$((count + 1))
    fi
  done
  printf '%d/3' "$count"
}

mail_status() {
  local idx="$1"
  if [ "$idx" -eq 3 ] && ! intro_mail_unlocked; then
    printf 'LOCKED'
    return
  fi

  if [ "${mail_read[$idx]}" -eq 1 ]; then
    printf 'READ'
  else
    printf 'NEW '
  fi
}

render_screen() {
  draw_header "Challenge 1: First Login, New User"
  draw_retro_logo
  draw_signal_meter
  printf '\n'
  cat <<'ART'
      ________________________________________
     /         NEW USER WELCOME NODE          \
    |  BOARD ACCESS: ACTIVE                    |
    |  NETMAIL THREAD: CHECK REQUIRED          |
     \________________________________________/
ART
  printf '\n'
  printf '%b' "${C_YLW}Objective:${C_RST} Recover the hidden flag from BBS content.\n"
  printf '%b' "${C_YLW}Hint:${C_RST} NetMail item 4 unlocks after reading onboarding thread.\n"
  printf '%b' "${C_DIM}Onboarding mail read: $(mail_progress)${C_RST}\n"
  if intro_mail_unlocked; then
    printf '%b' "${C_GRN}Priority mail unlocked in NetMail inbox.${C_RST}\n"
  fi
  if [ -f /flag ]; then
    printf '%b' "${C_GRN}/flag is available.${C_RST}\n"
  fi
  printf '\n'
}

show_boards() {
  render_screen
  show_module_bar "Message Boards"
  cat <<'TXT'
1) general
2) rules
3) trading
TXT
  printf '\n'
  press_any_key
}

read_board_menu() {
  local options=(
    "general"
    "rules"
    "trading"
    "Back"
  )

  while true; do
    arrow_menu_select "Board Browser" options pick render_screen
    case "$pick" in
      -1|3)
        return
        ;;
      0)
        render_screen
        cat ./boards/general.txt
        printf '\n'
        press_any_key
        ;;
      1)
        render_screen
        cat ./boards/rules.txt
        printf '\n'
        press_any_key
        ;;
      2)
        render_screen
        cat ./boards/trading.txt
        printf '\n'
        press_any_key
        ;;
    esac
  done
}

show_who() {
  render_screen
  show_module_bar "Who Is Online"
  cat <<'WHO'
BYTEKID      1200 baud
CATMODEM     2400 baud
BLUEBOX      2400 baud
NEWUSER      2400 baud
WHO
  printf '\n'
  press_any_key
}

decoder_lab() {
  render_screen
  show_module_bar "ROT13 Decoder Lab"
  printf '%b' "${C_YLW}Enter text to decode:${C_RST} "
  local text
  read_choice text || { printf '\n'; return; }

  if [ -z "$text" ]; then
    printf '%b' "${C_RED}No text entered.${C_RST}\n"
  else
    printf '%b' "${C_GRN}Decoded:${C_RST} $(decode_rot13 "$text")\n"
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

mail_center() {
  local options

  while [ "$solved" -eq 0 ]; do
    options=(
      "01 [$(mail_status 0)] ${mail_subjects[0]}"
      "02 [$(mail_status 1)] ${mail_subjects[1]}"
      "03 [$(mail_status 2)] ${mail_subjects[2]}"
      "04 [$(mail_status 3)] ${mail_subjects[3]}"
      "Back to Hub"
    )

    arrow_menu_select "NetMail Inbox" options pick render_screen

    case "$pick" in
      -1|4)
        return
        ;;
      0|1|2)
        render_screen
        cat "${mail_files[$pick]}"
        mail_read[$pick]=1
        printf '\n'
        press_any_key
        ;;
      3)
        if ! intro_mail_unlocked; then
          render_screen
          printf '%b' "${C_RED}Message locked: read onboarding mail 01-03 first.${C_RST}\n\n"
          press_any_key
        else
          render_screen
          cat "${mail_files[3]}"
          mail_read[3]=1
          printf '\n'
          press_any_key
        fi
        ;;
    esac
  done
}

hub_loop() {
  local hub_options=(
    "NetMail Inbox"
    "Message Boards"
    "Board Browser"
    "Decoder Lab"
    "Who Is Online"
    "Submit Flag"
    "Disconnect"
  )

  while [ "$solved" -eq 0 ]; do
    arrow_menu_select "Challenge 1 Hub" hub_options pick render_screen

    case "$pick" in
      0)
        mail_center
        ;;
      1)
        show_boards
        ;;
      2)
        read_board_menu
        ;;
      3)
        decoder_lab
        ;;
      4)
        show_who
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
slow_print "Navigate using arrow keys like a classic board terminal." 0.01
slow_print "Read mail threads, decode clues, and unlock /flag when solved." 0.01
press_any_key "Press any key to enter the hub..."

hub_loop
