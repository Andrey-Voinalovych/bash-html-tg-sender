#!/bin/bash
# ==================================================================
# Script to send html based messages via TG api with values calculated by runner (linux f.e.)
# DEMO:
# 1. For demo sending, just change BOT_TOKEN and NOTIFY_TG_IDS parameters in config file to yours.
# 2. run script with --send-html parameter. 
# 
# Expected output:
# Chat/User ids that were passed to conf file will receive message with runner uptime, cpu/mem load, requested user
# 
# Use own values:
# 1. To use your own values, change the template.html according to allowed tags by https://telegram-bot-sdk.readme.io/reference/sendmessage#html-style
# 2. Use {{key}} syntax to pass variables in html template.
# 3. To calculate values, add dictionary item in dynamic_variables.sh file. 
# 
# Important(!!!)
# {{key}} from html template and dictiorare key should be the same. 
# So if you passed {{my_cool_value}} in html you should add html_vars["my_cool_value"]=<runner command that you want to generate value>
# Important(!!!) 
# ==================================================================


# BOT / USER settings config
source bot-ping.conf
# Dynamic vars setup. Changable file based on your html template
source dynamic_variables.sh

# Utility finction to send requests to Telegram API
# Input parameters:
# chat_id - chat/user ids, in which you want your message to be send
# message - text that will be send in Telegram API to be used as a message from bot 
send_request(){
    chat_id=$1
    message=$(echo "$2" | sed 's/"/\\"/g')

    # NOTE: parse_mode key is hardcoded as HTML, but alternative value can be used for markdown text. 
    curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "{\"chat_id\":\"$chat_id\", \"text\":\"$message\", \"parse_mode\":\"HTML\"}" \
        "https://api.telegram.org/bot$BOT_TOKEN/sendMessage"
}

# Sending message to all chat/user ids from the .conf file
notify_all_users(){
    message=$1
    for user_id in "${NOTIFY_TG_IDS[@]}"; do
        send_request "$user_id" "$message"
    done
}

# Replacing html tags with calculated values
generate_message_html() {
    initialize_dynamic_variables

    #Reading contents of the file into variable
    html_content=$(<"$1")

    for key in "${!html_vars[@]}"; do
        # Escaping HTML symbols 
        safe_value=$(echo "${html_vars[$key]}" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
        
        # Changin all occurencies {{key}} for values from 'html_vars' array, using awk
        html_content=$(echo "$html_content" | awk -v k="{{${key}}}" -v v="$safe_value" '{gsub(k, v); print}')
    done
    echo "$html_content"
}


# ==================================================================
# Script access point
# ==================================================================
if [[ "$1" == "--send" ]]; then
    notify_all_users $2
elif [[ "$1" == "--send-html" ]]; then
    notify_all_users "$(generate_message_html $2)"
else
    echo "Incorrect Parameters!
    Usage:
    $0 --send <text> - sending custom plain text message
    $0 --send-html <path-to-file> - send html file content"
fi