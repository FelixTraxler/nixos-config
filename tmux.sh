#!/usr/bin/env bash
set -euo pipefail

SESSION="nixos-config"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  exec tmux attach -t "$SESSION"
fi

tmux new-session -d -s "$SESSION" -c "$DIR" -n lazygit "lazygit"
tmux new-window -t "$SESSION" -c "$DIR" -n nvim "nvim"
tmux new-window -t "$SESSION" -c "$DIR" -n shell
tmux select-window -t "$SESSION:shell"
exec tmux attach -t "$SESSION"
