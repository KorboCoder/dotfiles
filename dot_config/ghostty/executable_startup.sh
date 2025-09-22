SESSION_NAME="main"
NIX_BIN_PATH="$HOME/.nix-profile/bin"

# function to attach to an empty session or create a new one
attach_to_empty_session_or_create_new(){

      # check for existing session with the starting name of  "main-"
      for sess in $("$NIX_BIN_PATH"/tmux list-sessions | grep  "^${SESSION_NAME}-" | awk '{print $1}' | sed -e "s/://" 2>/dev/null ); do
        # check if the ssession has no clients attached
        if [ "$( "$NIX_BIN_PATH"/tmux list-clients -t "$sess" 2>/dev/null | wc -l )" -eq 0 ]; then
            # connect to first empty session we find
            "$NIX_BIN_PATH"/tmux attach-session -t "$sess"
            return 0
        fi
      done
      # no empty session is found so we create a new group session
      "$NIX_BIN_PATH"/tmux new-session -t $SESSION_NAME
}

# Check if the group "main" exists
if "$NIX_BIN_PATH"/tmux has-session -t $SESSION_NAME 2>/dev/null; then
  # Group exists, check if the specific "main" session exists and has no clients attached
  if "$NIX_BIN_PATH"/tmux has-session -t $SESSION_NAME 2>/dev/null && [ "$(eval "$NIX_BIN_PATH"/tmux list-clients -t $SESSION_NAME 2>/dev/null | wc -l)" -eq 0 ]; then
    # "main" session is idle, attach to it
    "$NIX_BIN_PATH"/tmux attach-session -t $SESSION_NAME
  else
      attach_to_empty_session_or_create_new
  fi
else
  # No group exists, create a new detached session named "main". 
  # We detach it so the session is persistent in the background
  "$NIX_BIN_PATH"/tmux new-session -s $SESSION_NAME -d 

  # then attach to it
  "$NIX_BIN_PATH"/tmux attach-session -t $SESSION_NAME
fi
