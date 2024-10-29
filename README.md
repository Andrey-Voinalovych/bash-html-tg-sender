# Telegram HTML Message Sender Script

This script sends HTML-formatted messages to Telegram users or chats, leveraging the Telegram Bot API. It calculates values dynamically using commands from a runner (e.g., a Linux server), and customizes messages by substituting template variables with actual values.

## Demo Setup
To test the script's functionality:
1. Edit the `bot-ping.conf` file to set `BOT_TOKEN` and `NOTIFY_TG_IDS` with your own bot token and Telegram user/chat IDs.
2. Run the script with the `--send-html` parameter:
    ```bash
    ./send_message.sh --send-html <path-to-template.html>
    ```

### Expected Demo Output
All user/chat IDs listed in `NOTIFY_TG_IDS` in the configuration file will receive a message with:
- Server uptime
- CPU/memory load
- Requested user ID

## Customizing Messages

### Step 1: Edit Template HTML
To use your own variables and messages:
1. Modify the `template.html` file to include any allowed HTML tags (see the [Telegram Bot SDK reference](https://telegram-bot-sdk.readme.io/reference/sendmessage#html-style)).
2. Add custom variables using `{{key}}` syntax (e.g., `{{my_custom_value}}`) within `template.html`.

### Step 2: Configure Dynamic Variables
1. Add corresponding commands in `dynamic_variables.sh` for each `{{key}}` you defined in the HTML template. 
2. The keys in `dynamic_variables.sh` and `{{key}}` in `template.html` must match exactly.
3. Example if you've passed {{my_custom_value}} to html template:
   ```bash
   html_vars["my_custom_value"]="some_command_to_get_value"
