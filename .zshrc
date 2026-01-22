setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export PATH="$HOME/.local/bin:$PATH"

# Starship prompt (after brew shellenv)
eval "$(starship init zsh)"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# fzf - fuzzy finder
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

# fzf key bindings and completion
zinit ice wait lucid
zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh
zinit ice wait lucid
zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh

# zsh-syntax-highlighting
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

# zsh-autosuggestions
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

alias ll='ls -ltrFa --color=auto'

# SSH Agent (8h expiration)
SSH_ENV="${HOME}/.ssh/ssh.env"
DEFAULT_KEY="${HOME}/.ssh/id_rsa"
function start_agent {
  echo "Initialising new SSH agent..."
  ssh-agent -t 28800 > "${SSH_ENV}"
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
}

if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null
  ps -ef | grep "${SSH_AGENT_PID}" | grep ssh-agent > /dev/null || start_agent
else
  start_agent
fi
ssh-add -l > /dev/null || ssh-add "$DEFAULT_KEY"

# WSL2 integration
function open() {
  if [ $# -eq 0 ]; then
    explorer.exe .
  else
    if [ -e "$1" ]; then
      cmd.exe /c start "$(wslpath -w "$1")" 2> /dev/null
    else
      echo "open: $1 : No such file or directory"
    fi
  fi
}

# Git branch checkout with fzf
fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

fbrm() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Aliases
alias pbcopy='clip.exe'
alias lld='lsd -ltrFa'
alias vi='nvim'
alias view='nvim -R'

# Environment
EDITOR="nvim"
export AWS_PAGER=""
