#!/usr/bin/env bash

set -e

PUML_FILE=$1
shift

if [ -z "$PUML_FILE" ]; then
  echo "Error: missing .puml parameter"
  exit 1
fi

if [ ! -f "$PUML_FILE" ]; then
  echo "Error: file $PUML_FILE does not exist"
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "Error: missing options parameter."
  exit 1
fi

echo "Searching options '$*' in file: $PUML_FILE"

FOUND=0

for OPTION in "$@"; do
  echo "➡️  Buscando: '$OPTION'"
  if grep -q "$OPTION" "$PUML_FILE"; then
    echo "Found: $OPTION"
    FOUND=1
    break
  fi
done

if [ $FOUND -eq 1 ]; then
  echo "Element was found in $PUML_FILE file."
  exit 0
else
  echo "Element was not found in $PUML_FILE file"
  exit 1
fi