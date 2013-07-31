# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Don't wait for job termination notification
# set -o notify

# Don't use ^D to exit
set -o ignoreeof

# Use case-insensitive filename globbing
shopt -s nocaseglob

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

shopt -s cmdhist
shopt -s hostcomplete
shopt -s no_empty_cmd_completion

# History Options
# ###############

# Don't put duplicate lines in the history.
export HISTCONTROL="ignoreboth:erasedups"
export HISTSIZE=10000

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ll[ \t]*:la[ \t]*:ls[ \t]*:l[ \t]*:hi[ \t]?:hig[ \t]?:psg[ \t]?'

# Whenever displaying the prompt, write the previous line to disk
export PROMPT_COMMAND="history -a"

# Set default editor
export EDITOR='subl -w'

# Path
# #######

# source the users .path if it exists
if [ -e "${HOME}/.path" ] ; then
  source "${HOME}/.path"
fi

# Aliases
# #######

# source the users .alias if it exists
if [ -e "${HOME}/.alias" ] ; then
  source "${HOME}/.alias"
fi

# Functions
# #########

# source the users .func if it exists
if [ -e "${HOME}/.func" ] ; then
  source "${HOME}/.func"
fi

# brew install bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ] ; then
  . $(brew --prefix)/etc/bash_completion
fi

# source git branch prompt script
if [ -f "${HOME}/.git-prompt.sh" ] ; then
  source "${HOME}/.git-prompt.sh"
fi

# Prompt
# #########
prompt_command () {
    local rts=$?
    local w=$(echo "${PWD/#$HOME/~}" | sed 's/.*\/\(.*\/.*\/.*\)$/\1/') # pwd max depth 3
# pwd max length L, prefix shortened pwd with m
    local L=60 m='<'
    [ ${#w} -gt $L ] && { local n=$((${#w} - $L + ${#m}))
    local w="\[\033[0;32m\]${m}\[\033[0;37m\]${w:$n}\[\033[0m\]" ; } \
    ||   local w="\[\033[0;37m\]${w}\[\033[0m\]"
# different colors for different return status
    [ $rts -eq 0 ] && \
    local p="\[\033[1;30m\]>\[\033[0;32m\]>\[\033[1;32m\]>\[\033[m\]" || \
    local p="\[\033[1;30m\]>\[\033[0;31m\]>\[\033[1;31m\]>\[\033[m\]"
    PROMPT_COMMAND="__git_ps1 '\h: ${w}' '${p} '"
}
prompt_command

