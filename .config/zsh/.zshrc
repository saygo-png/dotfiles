#run profile

#tmux autoattach
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

#Basic auto/tab complete
setopt MENU_COMPLETE
setopt extendedglob
unsetopt CASE_GLOB
setopt no_list_ambiguous
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.
# vi mode
bindkey -v
export KEYTIMEOUT=1
#autoload tmux
#if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
#    tmux attach || tmux >/dev/null 2>&1
#fi
#Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
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
  #        rm -f "$tmp"
  [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
 fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
 test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
 alias ls='ls --color=auto'
 alias dir='dir --color=auto'
 alias vdir='vdir --color=auto'

 alias grep='grep --color=auto'
 alias fgrep='fgrep --color=auto'
 alias egrep='egrep --color=auto'
fi

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
#Load zsh-syntax-highlighting; should be last.
source /home/samsepi0l/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
