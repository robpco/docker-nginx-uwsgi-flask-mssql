#!/usr/bin/env sh

# Send Slack notifications
#   requires ENVVAR CI_SLACK_WEBHOOK_URL
#   requires curl

CHANNEL=$1
MESSAGE=$2

if [ -z "$CHANNEL" ] || [ -z "$MESSAGE" ] || [ -z "$CI_SLACK_WEBHOOK_URL" ]; then
  echo -e "Missing argument(s) - Use: \$1 = channel, \$2 = message"
  echo "also set environment variable CI_SLACK_WEBHOOK_URL"
else
  curl -s -X POST --data-urlencode 'payload={"channel": "'"$CHANNEL"'", "username": "gitlab-ci", "text": "'"$MESSAGE"'", "icon_emoji": ":gitlab:"}' "$CI_SLACK_WEBHOOK_URL"
fi
