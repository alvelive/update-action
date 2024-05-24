#!/bin/bash
set -e

err() {
  printf "%s\n" "$*" >&2
}

escape() {
  sed 's/[`~!@#$%^&*()-_=+{}\|;:",<.>/?]/\\&/g'
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

  local escaped_match=$(echo "$match" | escape)
  local escaped_replace=$(echo "$replace" | escape)

  sed "s|$escaped_match|$escaped_replace|g" "$template" | tee "$output" >/dev/null
  replaced_content=$(grep "$replace" "$output")

  if [ -z "$replaced_content" ]; then
    err "Failed to replace '$match' with '$replace' in '$template'. Output does not contain '$replace'."
    exit 1
  else
    echo "Replaced '$match' with '$replace' in '$template' and saved to '$output'."
  fi
}

main
