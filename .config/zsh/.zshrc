# Tmux autoattach.
if [ -x "$(command -v tmux)" ] && [ -z "${TMUX}" ]; then
 tmux new-session
fi
#Luke's config for the Zoomer Shell
#Enable colors and change prompt:
autoload -U colors && colors
#PROMPT="%F{green}%?%f%B%F{10}%n%f%b%F{green}@%f%B%F{green}%T%f%b%B%F{yellow}%~%f%b %F{green}:%f"
PROMPT="%B%F{green}%T%f%b%F{yellow}%~%f"
# History in cache directory:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history

#Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/profile" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/profile"
# No ugly mark
PROMPT_EOL_MARK=
# Autocomplete.
setopt extendedglob
setopt no_list_ambiguous
setopt GLOB_COMPLETE      # Show autocompletion menu with globs
setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
setopt GLOB_DOTS
unsetopt CASE_GLOB
zstyle ':completion:*' menu select
zmodload zsh/complist
# Load more completions.
fpath=($HOME/.config/zsh/plugins/zsh-completions/src $fpath)
_comp_options+=(globdots)  # Include hidden files.
# Use hjlk in menu selection (during completion)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^xg' clear-screen
bindkey -M menuselect '^xi' vi-insert                      # Insert
bindkey -M menuselect '^xh' accept-and-hold                # Hold
bindkey -M menuselect '^xn' accept-and-infer-next-history  # Next
bindkey -M menuselect '^xu' undo                           # Undo

autoload -U compinit; compinit

# Don't glob urls.
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Only work with the Zsh function vman
compdef vman="man"
# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate
# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true
zle -C alias-expension complete-word _generic
bindkey '^Xa' alias-expension
zstyle ':completion:alias-expension:*' completer _expand_alias
# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' keep-prefix true
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Backspace delete
bindkey -v '^?' backward-delete-char

#Change cursor shape for different vi modes.
function zle-keymap-select {
 if [[ ${KEYMAP} == vicmd ]] ||
  [[ $1 = 'block' ]]; then
  echo -ne '\e[1 q'
 elif [[ ${KEYMAP} == main ]] ||
  [[ ${KEYMAP} == viins ]] ||
  [[ ${KEYMAP} = '' ]] ||
  [[ $1 = 'beam' ]]; then
  echo -ne '\e[4 q'
 fi
}
zle -N zle-keymap-select
zle-line-init() {
 zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
 echo -ne "\e[4 q"
}
zle -N zle-line-init
echo -ne '\e[4 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[4 q' ;} # Use beam shape cursor for each new prompt.

#Use lf to switch directories and bind it to ctrl-o
lfcd () {
 tmp="$(mktemp)"
 lf -last-dir-path="$tmp" "$@"
 if [ -f "$tmp" ]; then
  dir="$(cat "$tmp")"
  rmw "$tmp"
  [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
 fi
}
bindkey -s '^o' 'lfcd\n'
# Use fzf to switch dirs and bind it to ctrl-f
fzfcd () {
 dir=$(find ~/builds ~/.local/bin ~/ -mindepth 1 -maxdepth 4 | fzf)
 if [ -z $dir ]; then
  exit 1
 fi
 [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
}
bindkey -s '^f' 'fzfcd\n'
# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
# Plugins
#fpath+=("${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zsh-completions/zsh-completions.plugin.zsh") || return

#git prompt
#Simple Zsh prompt with Git status.

#Source gitstatus.plugin.zsh from $GITSTATUS_DIR or from the same directory
#in which the current script resides if the variable isn't set.
export GITSTATUS_DIR="$HOME/.config/zsh/gitstatus"
source "${GITSTATUS_DIR:-${${(%):-%x}:h}}/gitstatus.plugin.zsh" || return
GITSTATUS_LOG_LEVEL=DEBUG
#Sets GITSTATUS_PROMPT to reflect the state of the current git repository. Empty if not
#in a git repository. In addition, sets GITSTATUS_PROMPT_LEN to the number of columns
#$GITSTATUS_PROMPT will occupy when printed.
#
#Example:
#
#  GITSTATUS_PROMPT='master ⇣42⇡42 ⇠42⇢42 *42 merge ~42 +42 !42 ?42'
#  GITSTATUS_PROMPT_LEN=39
#
#  master  current branch
#     ⇣42  local branch is 42 commits behind the remote
#     ⇡42  local branch is 42 commits ahead of the remote
#     ⇠42  local branch is 42 commits behind the push remote
#     ⇢42  local branch is 42 commits ahead of the push remote
#     *42  42 stashes
#   merge  merge in progress
#     ~42  42 merge conflicts
#     +42  42 staged changes
#     !42  42 unstaged changes
#     ?42  42 untracked files
function gitstatus_prompt_update() {
 emulate -L zsh
 typeset -g  GITSTATUS_PROMPT=''
 typeset -gi GITSTATUS_PROMPT_LEN=3

  #Call gitstatus_query synchronously. Note that gitstatus_query can also be called
  #asynchronously; see documentation in gitstatus.plugin.zsh.
  gitstatus_query 'MY'                  || return 1  # error
  [[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0  # not a git repo

  local      clean='%F{green}'   # green foreground
  local   modified='%F{yellow}'  # yellow foreground
  local  untracked='%F{orange}'   # blue foreground
  local conflicted='%F{red}'  # red foreground

  local p

  local where  # branch name, tag or commit
  if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
   where=$VCS_STATUS_LOCAL_BRANCH
  elif [[ -n $VCS_STATUS_TAG ]]; then
   p+='%f#'
   where=$VCS_STATUS_TAG
  else
   p+='%f@'
   where=${VCS_STATUS_COMMIT[1,8]}
  fi

  (( $#where > 32 )) && where[13,-13]="…"  # truncate long branch names and tags
  p+="${clean}${where//\%/%%}"             # escape %

  #⇣42 if behind the remote.
  (( VCS_STATUS_COMMITS_BEHIND )) && p+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
  #⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
  (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && p+=" "
  (( VCS_STATUS_COMMITS_AHEAD  )) && p+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
  #⇠42 if behind the push remote.
  (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
  (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" "
  #⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
  (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && p+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
  #*42 if have stashes.
  (( VCS_STATUS_STASHES        )) && p+=" ${clean}*${VCS_STATUS_STASHES}"
  #'merge' if the repo is in an unusual state.
  [[ -n $VCS_STATUS_ACTION     ]] && p+=" ${conflicted}${VCS_STATUS_ACTION}"
  #~42 if have merge conflicts.
  (( VCS_STATUS_NUM_CONFLICTED )) && p+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
  # +42 if have staged changes.
  (( VCS_STATUS_NUM_STAGED     )) && p+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
  # !42 if have unstaged changes.
  (( VCS_STATUS_NUM_UNSTAGED   )) && p+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
  # ?42 if have untracked files. It's really a question mark, your font isn't broken.
  (( VCS_STATUS_NUM_UNTRACKED  )) && p+=" ${untracked}?${VCS_STATUS_NUM_UNTRACKED}"

  GITSTATUS_PROMPT="${p}%f"

  # The length of GITSTATUS_PROMPT after removing %f and %F.
  GITSTATUS_PROMPT_LEN="${(m)#${${GITSTATUS_PROMPT//\%\%/x}//\%(f|<->F)}}"
 }

#Start gitstatusd instance with name "MY". The same name is passed to
#gitstatus_query in gitstatus_prompt_update. The flags with -1 as values
#enable staged, unstaged, conflicted and untracked counters.
gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'

#On every prompt, fetch git status and set GITSTATUS_PROMPT.
autoload -Uz add-zsh-hook
add-zsh-hook precmd gitstatus_prompt_update

#Enable/disable the right prompt options.
setopt no_prompt_bang prompt_percent prompt_subst

#Customize prompt. Put $GITSTATUS_PROMPT in it to reflect git status.
#
#Example:
#
#  user@host ~/projects/skynet master ⇡42
#  % █
#
#The current directory gets truncated from the left if the whole prompt doesn't fit on the line.
PROMPT=$PROMPT
PROMPT+='${GITSTATUS_PROMPT:+ $GITSTATUS_PROMPT}'      # git status
PROMPT+=$'\n'                                          # new line
PROMPT+='%F{green}>%f'
# Load zoxide (cd replacement)
eval "$(zoxide init zsh)"
#Load zsh-syntax-highlighting; should be last.
source "$HOME"/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
