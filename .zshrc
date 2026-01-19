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
        if [ ! -f "$HOME/.config/fastfetch/arch_logo.png" ]; then
             curl -sL "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Archlinux-icon-crystal-64.svg/1024px-Archlinux-icon-crystal-64.svg.png" -o "$HOME/.config/fastfetch/arch_logo.png"
        fi
        
        clear
        fastfetch
    fi
}

if [[ -o interactive ]]; then
    run_fastfetch_smart
fi