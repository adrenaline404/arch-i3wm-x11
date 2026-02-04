source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt SHARE_HISTORY

eval "$(starship init zsh)"

alias ll='ls -l'
alias la='ls -a'
alias l='ls -CF'
alias update='yay -Syu'
alias install='yay -S'
alias remove='yay -Rns'
alias c='clear'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias config='cd ~/.config/i3'
alias project='cd ~/arch-i3wm-x11'

if [[ -o interactive ]]; then
    fastfetch --config ~/.config/fastfetch.jsonc
fi