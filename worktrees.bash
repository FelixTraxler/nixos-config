# A function so cd changes the calling shell. Usage: cwt [initial search]
cwt() {
  local field path branch selected
  local -a entries=()

  git rev-parse --git-dir >/dev/null || return

  # NUL-delimited porcelain preserves spaces and other characters in paths.
  while IFS= read -r -d '' field; do
    case "$field" in
      'worktree '*) path=${field#worktree }; branch='(detached)' ;;
      'branch '*) branch=${field#branch refs/heads/} ;;
      bare) path= ;;
      '')
        if [[ -n "$path" ]]; then
          entries+=("$branch"$'\t'"$path")
        fi
        ;;
    esac
  done < <(git worktree list --porcelain -z)

  ((${#entries[@]})) || return 1
  IFS= read -r -d '' selected < <(
    printf '%s\0' "${entries[@]}" |
      fzf --read0 --print0 --no-multi --delimiter=$'\t' \
        --height=40% --layout=reverse --border \
        --prompt='Worktree> ' --query="$*"
  ) || return 0

  builtin cd -- "${selected#*$'\t'}"
}
