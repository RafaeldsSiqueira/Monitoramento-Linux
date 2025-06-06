#!/bin/bash

source "$(dirname "$0")/.env"
MENSAGEM="$1"

curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID"  \
    -d text="$MENSAGEM" > /dev/null