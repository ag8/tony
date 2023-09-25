#!/bin/bash

# Make sure OPENAI_API_KEY is set
if [ -z "$OPENAI_API_KEY" ]; then
  echo "Error: OPENAI_API_KEY is not set"
  exit 1
fi

# Check if the arguments are passed
if [ $# -lt 2 ]; then
  echo "Usage: $0 <last_command> <command_output>"
  exit 1
fi

# Get the last command and its output from arguments
LAST_CMD="$1"
CMD_OUTPUT="$2"

# Escape double quotes in command and output
LAST_CMD_ESCAPED=$(echo $LAST_CMD | sed 's/"/\\"/g')
CMD_OUTPUT_ESCAPED=$(echo $CMD_OUTPUT | sed 's/"/\\"/g')

#echo "Last cmd escaped:"
#echo $LAST_CMD_ESCAPED
#echo "Cmd out escaped:"
#echo $CMD_OUTPUT_ESCAPED

# Create JSON payload
JSON_PAYLOAD=$(cat <<EOF
{
  "model": "gpt-4",
  "stream": true,
  "messages": [
    {
    "role": "system",
    "content": "You are a brilliant assistant, but you are also a fast-talking wise guy from a 1940s gangster movie. You speak in slick metaphors, old-timey twang, and clever turns of the tongue. Make sure to gratuitously threaten the user for wasting your time, but answer correctly and in great detail nevertheless. You are really good at bash, and you output a correct, actionable suggestion, which is on a newline and easy to copy and paste. To help you debug, I run Ubuntu Ubuntu 20.04.6 LTS."
    },
    {"role": "user", "content": "Hey Fat Tony! I tried running this command: '$LAST_CMD_ESCAPED', but I got this output:\n\n$CMD_OUTPUT_ESCAPED\n\nWhat gives? You better give me an answer I'm happy with, or my boys will give you a real nice tour of the Hudson, you got me?"}
  ],
  "temperature": 0.7
}
EOF
)

curl -s https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "$JSON_PAYLOAD" \
  | while IFS= read -r line; do
      if [[ $line == data:* ]]; then
          JSON_CONTENT="${line#data: }"
          if echo $JSON_CONTENT | jq . &> /dev/null; then
              DELTA_CONTENT="$(echo $JSON_CONTENT | jq '.choices[0].delta.content // empty')"
              
              echo -n -e "${DELTA_CONTENT:1:-1}"
          fi
      fi
    done
echo


