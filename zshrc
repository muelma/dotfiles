######################################################################
#       muelma's zshrc file, based on:
#           jdong's zshrc file v0.2.1 , based on:
#             mako's zshrc file, v0.1
#
# 
######################################################################

# next lets set some enviromental/shell pref stuff up
# setopt NOHUP
#setopt NOTIFY
#setopt NO_FLOW_CONTROL
setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY HIST_IGNORE_ALL_DUPS EXTENDED_HISTORY
# setopt AUTO_LIST      # these two should be turned off
# setopt AUTO_REMOVE_SLASH
# setopt AUTO_RESUME        # tries to resume command of same name
unsetopt BG_NICE        # do NOT nice bg commands
unsetopt correct_all    # hate autocorrection
setopt CORRECT          # command CORRECTION
# setopt HASH_CMDS      # turns on hashing
#
setopt MENUCOMPLETE
setopt ALL_EXPORT

# Set/unset  shell options
setopt   notify globdots pushdtohome cdablevars autolist
setopt   autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent 
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile &>/dev/null

#LS_COLORS='ow=103;30;01'
eval "$(dircolors ~/.dircolors)"
#eval "$(setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl)"

REPORTTIME=5

PATH="/usr/local/bin:/usr/local/sbin/:/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
TZ="Europe/Berlin"
HISTFILE=$HOME/.zhistory
HISTSIZE=10000
SAVEHIST=10000
HOSTNAME=`hostname`
PAGER='less'
EDITOR='nvim'
BROWSER='google-chrome'
    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
   colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
   eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
   eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
   (( count = $count + 1 ))
    done
    PR_NO_COLOR="%{$terminfo[sgr0]%}"
PS1="[$PR_BLUE%n$PR_WHITE@$PR_GREEN%U%m%u$PR_NO_COLOR:$PR_RED%2c$PR_NO_COLOR]%(!.#.$) "
#RPS1="$PR_LIGHT_YELLOW(%D{%m-%d %H:%M})$PR_NO_COLOR"
function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/ n }/(main|viins)/ i }%(?..[$PR_RED%?$PR_NO_COLOR] )"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

#LANGUAGE=
LC_ALL='en_US.UTF-8'
LANG='en_US.UTF-8'
LC_CTYPE='en_US.UTF-8'

if [ $SSH_TTY ]; then MUTT_EDITOR=nvim else
  MUTT_EDITOR=emacsclient.emacs-snapshot
fi

unsetopt ALL_EXPORT
# # --------------------------------------------------------------------
# # aliases
# # --------------------------------------------------------------------
alias vim='nvim'
alias fixtikz='convert -quality 99 -density 600' # input output.jpg
alias matlab='/net/grawp/opt/MATLAB/R2013a/bin/matlab'
alias man='LC_ALL=C LANG=C man'
alias ls='ls --color=auto '
alias ll='ls -al'
alias lf='find . ! -name . -prune -type f' # list files only
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lal='ls -al'
alias x+="chmod +x"
alias x-="chmod -x"
alias zernike='ssh zernike.physik.uni-leipzig.de'
alias shodan='ssh shodan.physik.uni-leipzig.de'
alias dobby='ssh dobby.physik.uni-leipzig.de'
alias emmy='ssh emmy.physik.uni-leipzig.de'
alias hofmannsthal='ssh hofmannsthal.physik.uni-leipzig.de'
alias fermi='ssh fermi.physik.uni-leipzig.de'
alias kreacher='ssh kreacher.physik.uni-leipzig.de'
alias dualmonitor='xrandr --output VGA1 --auto --left-of LVDS1 &&  xrandr --output LVDS1 --auto'
alias unimount='sshfs mueller@grawp.physik.uni-leipzig.de:/home/mueller $HOME/uni-mount/'
alias caps2super='setxkbmap -option caps:super'
alias readywork='dualmonitor && unimount && ssh-add && workrave &'
alias rtask="ssh mueller@hofmannsthal.physik.uni-leipzig.de \~/custom_usr/bin/task rc._forcecolor:on"
alias beamerout='xrandr --output VGA1 --mode 1024x768 --output LVDS1 --mode 1024x768 --rate 60'
alias beamer_out_auto='xrandr --output VGA1 --auto'
alias please='sudo `history | tail -n 1 | sed -e "s/[0-9 ][0-9 ]*//" -e "s/\n//"`'
alias sudo="sudo " # this way sudo uses alias expansion
alias gitdiff="git diff --color"
alias dotgit="git --git-dir $HOME/dotfiles/.git --work-tree $HOME/dotfiles"
alias g11="g++ -std=c++11"
alias clang11="clang++ -std=c++11"
#alias ipython="/home/mueller/miniconda2/bin/ipython --pylab"
alias pdflatex='pdflatex --interaction=nonstopmode '
alias skype='env PULSE_LATENCY_MSEC=30 skype'
alias scriptdir='cd ~/simulations_src/scripts/temp_save_goni_fixed_scripts/'
alias evince='evince 2>/dev/null'
alias cmake-release='cmake -DCMAKE_BUILD_TYPE=release'
alias mergepdfs='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged.pdf'

export PATH=$PATH:~/scripts
export PYTHONPATH=~/simulations_src/scripts/
export PYTHONSTARTUP=~/.pythonstartup
export GNUTERM=x11

bindkey -v
bindkey "[7~" beginning-of-line
bindkey "[8~" end-of-line
bindkey "" backward-delete-char
bindkey '[3~' delete-char
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
#bindkey '^I' complete-word # complete on tab, leave expansion to _expand

autoload -U compinit
compinit

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
# on processes completion complete all user processes
# zstyle ':completion:*:processes' command 'ps -au$USER'

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#zstyle ':completion:*:processes' command 'ps ax -o pid,s,nice,stime,args | sed "/ps/d"'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command' 
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
#
#NEW completion:
# 1. All /etc/hosts hostnames are in autocomplete
# 2. If you have a comment in /etc/hosts like #%foobar.domain,
#    then foobar.domain will show up in autocomplete!
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}') 
# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
        named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs avahi-autoipd\
        avahi backup messagebus beagleindex debian-tor dhcp dnsmasq fetchmail\
        firebird gnats haldaemon hplip irc klog list man cupsys postfix\
        proxy syslog www-data mldonkey sys snort
# SSH Completion
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
__git_files () { 
    _wanted files expl 'local files' _files     
}
## Function for always using one (and only one) vim server, even when not
## using gvim.
## If you really want a new vim session, simply do not pass any
## argument to this function.
#function vim {
#  vim_orig=$(which 2>/dev/null vim)
#  if [ -z $vim_orig ]; then
#    echo "$SHELL: vim: command not found"
#    return 127;
#  fi
#  $vim_orig --serverlist | grep -q VIM
#  # If there is already a vimserver, use it
#  # unless no args were given
#  if [ $? -eq 0 ]; then
#    if [ $# -eq 0 ]; then
#      $vim_orig
#    else
#      $vim_orig --remote "$@"
#    fi
#  else
#    $vim_orig --servername vim "$@"
#  fi
#}

#if [ -x /usr/games/fortune ] ; then
#  /usr/games/fortune
#fi

# added by Miniconda2 3.19.0 installer
# export PATH="/home/mueller/miniconda2/bin:$PATH"
