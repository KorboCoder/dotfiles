SESSION_NAME="main"
NIX_BIN_PATH="$HOME/.nix-profile/bin"

# Check if the session already exists
$NIX_BIN_PATH/tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? -eq 0 ]; then
  # If the session exists, reattach to it
  $NIX_BIN_PATH/tmux attach-session -t $SESSION_NAME
else
  # If the session doesn't exist, start a new one
  $NIX_BIN_PATH/tmux new-session -s $SESSION_NAME -d
  $NIX_BIN_PATH/tmux attach-session -t $SESSION_NAME
fi
