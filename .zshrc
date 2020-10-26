profiles=~/.profiles
source "${profiles}/functions"

## Pre Configurations {{{

# for sierra
ssh-add -A &> /dev/null

# Avoid 'no matches found' error.
setopt nullglob

# Add PATH and MAN_PATH.
init_paths

# Initialize EDITOR.
init_editor

# Initialize LANG.
init_lang

## }}}

## Aliases {{{

init_aliases

## }}}

## Zsh Basic Configurations {{{

# Initialize hook functions array.
typeset -ga preexec_functions
typeset -ga precmd_functions

# Use emacs key bindings.
bindkey -e

# Use colors.
autoload -Uz colors
colors

# Expand parameters in the prompt.
setopt prompt_subst

# Show current directory on right prompt.
# RPROMPT="%{$fg[blue]%}%~%{$reset_color%}"

# Report slow system execution times
export REPORTTIME=3

# Change directory if the command doesn't exist.
setopt auto_cd

# Resume the command if the command is suspended.
setopt auto_resume

# No beep.
setopt no_beep

# Enable expansion from {a-c} to a b c.
setopt brace_ccl

# Enable spell check.
setopt correct

# Expand =command to the path of the command.
setopt equals

# Use #, ~ and ^ as regular expression.
setopt extended_glob

# No follow control by C-s and C-q.
setopt no_flow_control

# Don't send SIGHUP to background jobs when shell exits.
setopt no_hup

# Show long list for jobs command.
setopt long_list_jobs

# Enable completion after = like --prefix=/usr...
setopt magic_equal_subst

# Append / if complete directory.
setopt mark_dirs

# Don't show completions when using *.
setopt glob_complete

# Perform implicit tees or cats when multiple redirections are attempted.
setopt multios

# Use numeric sort instead of alphabetic sort.
setopt numeric_glob_sort

# Enable file names using 8 bits, important to rendering Japanese file names.
setopt print_eightbit

# Don't push multiple copies of the same directory onto the directory stack.
setopt pushd_ignore_dups

# Show CR if the prompt doesn't end with CR.
unsetopt promptcr

# Remove any right prompt from display when accepting a command line.
setopt transient_rprompt

# Pushd by cd -[tab]
setopt auto_pushd

# Don't report the status of background and suspended jobs.
setopt no_check_jobs

# Remove directory word by C-w.
autoload -Uz select-word-style
select-word-style bash

# }}}

## Zsh VCS Info and RPROMPT {{{

if autoload +X vcs_info 2> /dev/null; then
	autoload -Uz vcs_info
	zstyle ':vcs_info:*' enable git cvs svn # hg - slow, it scans all parent directories.
	zstyle ':vcs_info:*' formats '%s %b'
	zstyle ':vcs_info:*' actionformats '%s %b (%a)'
	precmd_vcs_info() {
		psvar[1]=""
		LANG=en_US.UTF-8 vcs_info
		[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
	}
	precmd_functions+=precmd_vcs_info
	# PROMPT="${PROMPT}%1(V.%F{green}%1v%f .)"
	# PROMPT="${PROMPT}%{$fg[blue]%}%~%{$reset_color%} %1(V.%F{green}%1v%f .)"
	PROMPT="%m %# %{$fg[blue]%}%~%{$reset_color%} %1(V.%F{green}%1v%f .)"
fi

# }}}

## Zsh Completion System {{{

# Use zsh completion system.
autoload -Uz compinit
compinit

. $HOME/.profiles/bin/cdd

chpwd() {
    _cdd_chpwd
}

# Colors completions.
zstyle ':completion:*' list-colors ''

# Colors processes for kill completion.
zstyle ':completion:*:*:kill:*:processes' command 'ps -axco pid,user,command'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

# Ignore case.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Formatting and messages.
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}%d%{\e[0m%}'
zstyle ':completion:*:messages' format $'%{\e[0;31m%}%d%{\e[0m%}'
zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches for: %d%{\e[0m%}'
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*' group-name ''

# Make the completion menu selectable.
zstyle ':completion:*:default' menu select=1

# Fuzzy match.
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'

# Hostname completion
local knownhosts
if [ -f $HOME/.ssh/known_hosts ]; then
	knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
	zstyle ':completion:*:(ssh|scp|sftp):*' hosts $knownhosts
fi

## }}}

## Zsh History {{{

# Save history on the file.
HISTFILE="${HOME}"/.zsh-history

# Max history in the memory.
HISTSIZE=100000

# Max history.
SAVEHIST=1000000

# Remove command lines from the history list when the first character on the line is a space.
setopt hist_ignore_space

# Remove the history (fc -l) command from the history list when invoked.
setopt hist_no_store

# Read new commands from the history and your typed commands to be appended to the history file.
setopt share_history

# Append the history list to the history file for mutiple Zsh sessions.
setopt append_history

# Save each command's beginning timestamp.
setopt extended_history

# Don't add duplicates.
setopt hist_ignore_dups

# Don't execute the line directly from the history.
setopt hist_verify

# Seach history.
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

## }}}

## Zsh Keybinds {{{
## based on http://github.com/kana/config/

# To delete characters beyond the starting point of the current insertion.
bindkey -M viins '\C-h' backward-delete-char
bindkey -M viins '\C-w' backward-kill-word
bindkey -M viins '\C-u' backward-kill-line

# Undo/redo more than once.
bindkey -M vicmd 'u' undo
bindkey -M vicmd '\C-r' redo

# History
# See also 'autoload history-search-end'.
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward
bindkey -M viins '^p' history-beginning-search-backward-end
bindkey -M viins '^n' history-beginning-search-forward-end

bindkey -M emacs '^p' history-beginning-search-backward-end
bindkey -M emacs '^n' history-beginning-search-forward-end

# Transpose
bindkey -M vicmd '\C-t' transpose-words
bindkey -M viins '\C-t' transpose-words

# }}}

# clear Terminal.app title
precmd() {
    echo -ne "\033]0;\007"
}

# }}}

## Scan Additonal Configurations {{{

setopt no_nomatch
init_additionl_configration "*.zsh"

# }}}

## Post Configurations {{{

# Cleanup PATH, MANPATH.
# clean_paths

# }}}

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# zaw
if [ -s "`which $HOME/.profiles/zsh/zaw/zaw.zsh`" ]; then
source $HOME/.profiles/zsh/zaw/zaw.zsh
source $HOME/.profiles/zsh/zaw-sources/git-recent-branches.zsh
bindkey '^x^b' zaw-git-recent-branches
fi

if [ -x "`which go`" ]; then
export GOROOT=`go env GOROOT`
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

# vim:ts=4:sw=4:noexpandtab:foldmethod=marker:nowrap:

if [ -x "`which direnv`" ]; then
eval "$(direnv hook zsh)"
[[ -s ~/.pythonz/etc/bashrc ]] && source ~/.pythonz/etc/bashrc
fi

ssh-add -A &> /dev/null

export PATH=~/dev/flutter/bin:$PATH
