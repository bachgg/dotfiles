#!/bin/sh
NO_SESSIONS=$(/opt/homebrew/bin/zellij list-sessions -n | grep -v EXITED | wc -l)
echo $NO_SESSIONS > ~/.zellij-sessions
SESSION_ARG="" 
if [ "${NO_SESSIONS}" -ge 2 ]; then
  echo "more than one session..."
  WINDOW_TITLE=$(osascript -e '
  on run argv
  global frontApp, frontAppName, windowTitle

  set windowTitle to ""
  tell application "System Events"
      set frontApp to first application process whose frontmost is true
      set frontAppName to name of frontApp
      tell process frontAppName
          tell (1st window whose value of attribute "AXMain" is true)
              set windowTitle to value of attribute "AXTitle"
          end tell
      end tell
  end tell

  return {windowTitle}
  end run')

  ZELLIJ_SESSION=$(echo $WINDOW_TITLE | sed -n 's/Zellij (\(.*\)).*/\1/p')
  SESSION_ARG="--session $ZELLIJ_SESSION"
  echo $SESSION_ARG
fi
echo "$SESSION_ARG $@" >> ~/.zellij-sessions
/opt/homebrew/bin/zellij $SESSION_ARG $@

