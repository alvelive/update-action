#!/bin/bash
set -e

err() {
  printf "%s\n" "$*" >&2
}

main() {
  local should_exit=0

  if [ -z "$template" ]; then
    err "template is required"
    should_exit=1
  fi

  if [ -z "$output" ]; then
    err "output is required"
    should_exit=1
  fi

  if [ -z "$match" ]; then
    err "match is required"
    should_exit=1
  fi

  if [ -z "$replace" ]; then
    err "replace is required"
    should_exit=1
  fi

  if [ ! -f "$template" ]; then
    err "File not found: $template"
    should_exit=1
  fi

  if [ $should_exit -eq 1 ]; then
    exit 1
  fi

  read -r sed_command <<EOF
sed 's|$match|$replace|g' '$template' | tee '$output' > /dev/null
EOF

  bash -c "$sed_command"
  read -r replaced_content <<<"$(cat "$output" | grep "$replace")"

  if [ -z "$replaced_content" ]; then
    read -r error_msg <<EOF
Failed to replace "$match" with "$replace" in "$template"
Output does not contain "$replace"
EOF
    err "$error_msg"
    exit 1
  else
    cat <<EOF
Replaced "$match" with "$replace" in "$template" and saved to "$output"
EOF
  fi
}

main
