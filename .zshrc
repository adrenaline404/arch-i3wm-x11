export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  archlinux
)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias c='clear'
alias update='yay -Syu'

eval "$(starship init zsh)"

run_fastfetch_smart() {
    local width=$(tput cols)
    
    if [ "$width" -ge 60 ]; then
        local logo_file="$HOME/.config/fastfetch/arch_small.txt"
        
        clear
        fastfetch
    fi
}

if [[ -o interactive ]]; then
    run_fastfetch_smart
fi