#!/opt/pwn.college/bash

hash_text() {
  printf '%s' "$1" | sha256sum | awk '{print $1}'
}

load_expected_hash() {
  local path="${1:-./meta/flag.sha256}"
  if [ ! -f "$path" ]; then
    printf '%b' "${C_RED}Missing expected hash file: ${path}${C_RST}\n"
    return 1
  fi
  tr -d '[:space:]' <"$path"
}

submit_flag() {
  local guess="$1"
  local expected_hash="$2"

  if [ -z "$guess" ]; then
    printf '%b' "${C_RED}Usage: submit FLAG{...}${C_RST}\n"
    return 2
  fi

  if [ "$(hash_text "$guess")" = "$expected_hash" ]; then
    printf '%b' "${C_GRN}Correct. Challenge solved.${C_RST}\n"
    return 0
  fi

  printf '%b' "${C_RED}Not correct yet. Keep digging.${C_RST}\n"
  return 1
}

unlock_flag_file() {
  local flag_value="$1"
  printf '%s\n' "$flag_value" >/flag
  show_module_bar "Flag Unlocked"
  printf '%b' "${C_GRN}/flag is now available:${C_RST}\n"
  cat /flag
}

decode_rot13() {
  printf '%s\n' "$1" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
}

decode_b64() {
  local input="$1"
  local decoded
  if decoded="$(printf '%s' "$input" | base64 -d 2>/dev/null)"; then
    printf '%s\n' "$decoded"
    return 0
  fi

  printf '%b' "${C_RED}Invalid base64 payload.${C_RST}\n"
  return 1
}

decode_hex() {
  local input="${1// /}"

  if [ -z "$input" ] || [ $(( ${#input} % 2 )) -ne 0 ] || [[ ! "$input" =~ ^[0-9A-Fa-f]+$ ]]; then
    printf '%b' "${C_RED}Invalid hex payload.${C_RST}\n"
    return 1
  fi

  printf '%b\n' "$(printf '%s' "$input" | sed 's/../\\x&/g')"
}

show_module_bar() {
  local text="$1"
  printf '%b' "${C_BLU}[${text}]${C_RST}\n"
}

read_choice() {
  local out_var="$1"
  local value
  if IFS= read -r value; then
    printf -v "$out_var" '%s' "$value"
    return 0
  fi

  printf -v "$out_var" ''
  return 1
}

press_any_key() {
  local msg="${1:-Press any key to continue...}"
  printf '%b' "${C_DIM}${msg}${C_RST}"

  local key next
  if IFS= read -rsn1 key; then
    if [ "$key" = $'\e' ]; then
      IFS= read -rsn2 -t 0.001 next || true
    fi
  fi
  printf '\n'
}

read_nav_key() {
  local key next third

  IFS= read -rsn1 key || return 1

  if [ -z "$key" ] || [ "$key" = $'\n' ] || [ "$key" = $'\r' ]; then
    printf 'enter'
    return 0
  fi

  if [ "$key" = $'\e' ]; then
    if IFS= read -rsn1 -t 0.001 next; then
      if [ "$next" = '[' ]; then
        if IFS= read -rsn1 -t 0.001 third; then
          case "$third" in
            A) printf 'up' ;;
            B) printf 'down' ;;
            C) printf 'right' ;;
            D) printf 'left' ;;
            *) printf 'esc' ;;
          esac
        else
          printf 'esc'
        fi
      else
        printf 'esc'
      fi
    else
      printf 'esc'
    fi
    return 0
  fi

  case "$key" in
    k|K)
      printf 'up'
      ;;
    j|J)
      printf 'down'
      ;;
    q|Q|b|B)
      printf 'back'
      ;;
    *)
      printf 'other'
      ;;
  esac
}

draw_arrow_menu() {
  local title="$1"
  local selected="$2"
  local options_name="$3"
  local hint="${4:-Use arrow keys and Enter. q = back.}"
  local -n options_ref="$options_name"

  draw_panel_top "$title"

  local i
  for i in "${!options_ref[@]}"; do
    if [ "$i" -eq "$selected" ]; then
      printf "${C_CYN}| ${C_GRN}> %-54s${C_CYN} |${C_RST}\n" "${options_ref[$i]}"
    else
      printf "${C_CYN}|   %-54s${C_CYN} |${C_RST}\n" "${options_ref[$i]}"
    fi
  done

  draw_panel_bottom
  printf '%b' "${C_DIM}${hint}${C_RST}\n"
}

arrow_menu_select() {
  local title="$1"
  local options_name="$2"
  local out_index_var="$3"
  local render_fn="${4:-}"
  local hint="${5:-Use arrow keys and Enter. q = back.}"
  local -n options_ref="$options_name"

  local selected=0
  local key

  while true; do
    if [ -n "$render_fn" ]; then
      "$render_fn"
    elif [ -t 1 ]; then
      clear 2>/dev/null || true
    fi

    draw_arrow_menu "$title" "$selected" "$options_name" "$hint"

    key="$(read_nav_key)" || return 1

    case "$key" in
      up)
        selected=$((selected - 1))
        if [ "$selected" -lt 0 ]; then
          selected=$((${#options_ref[@]} - 1))
        fi
        ;;
      down)
        selected=$((selected + 1))
        if [ "$selected" -ge "${#options_ref[@]}" ]; then
          selected=0
        fi
        ;;
      enter)
        printf -v "$out_index_var" '%d' "$selected"
        return 0
        ;;
      back)
        printf -v "$out_index_var" '%d' -1
        return 0
        ;;
      *)
        ;;
    esac
  done
}
