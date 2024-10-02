#!/bin/sh

echo "[$PID] [$(date)] Running write current zellij session..."

# File to store the window title
OUTPUT_FILE="/Users/jimmy/.config/current_zellij_session"
touch $OUTPUT_FILE

# Function to get the active window title using AppleScript
get_active_window_title() {
  # Use AppleScript to get the active window title
  osascript -e 'tell application "System Events"
    -- Get the frontmost application process
    set frontAppProcess to first application process whose frontmost is true
    set frontAppName to name of frontAppProcess
    
    -- Get the list of windows for the frontmost application
    set frontWindows to windows of frontAppProcess
    
    repeat with aWindow in frontWindows
        -- Check if the window is focused (i.e., its "AXMain" attribute is true)
        if value of attribute "AXMain" of aWindow is true then
            set windowName to name of aWindow
            exit repeat
        end if
    end repeat
end tell

-- Return the name of the frontmost window
return windowName'
}

# Initialize previous title
previous_title=""

# Infinite loop to monitor the active window
while true; do
  # Get the current active window title
  current_title=$(get_active_window_title)

  # If the title has changed, write it to the file
  if [ "$current_title" != "$previous_title" ]; then
    current_session=$(echo $current_title | sed -n 's/Zellij (\(.*\)).*/\1/p')
    if [ -n "$current_session" ]; then
      echo "[$(date)] $current_session"
      echo "$current_session" > "$OUTPUT_FILE"
      previous_title="$current_title"
    fi
  fi

  # Sleep for a short while before checking again (to reduce CPU usage)
  sleep 0.1
done

echo "[$PID] [$(date)] Ending write current zellij session."
