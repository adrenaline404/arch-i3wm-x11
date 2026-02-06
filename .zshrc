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

export GTK_MODULES=canberra-gtk-module

if [[ -o interactive ]]; then
    CURRENT_THEME_PATH=$(readlink -f ~/.config/i3/themes/current)
    
    FF_COLOR="blue"
    
    if [[ "$CURRENT_THEME_PATH" == *"void-red"* ]]; then
        FF_COLOR="red"
    elif [[ "$CURRENT_THEME_PATH" == *"void-blue"* ]]; then
        FF_COLOR="blue"
    fi

    RANDOM_PRESET=$(printf "%02d" $(( ( RANDOM % 8 ) + 1 )))
    CONFIG_FILE="$HOME/.config/fastfetch/presets/${RANDOM_PRESET}.jsonc"

    if [ -f "$CONFIG_FILE" ]; then
        
        sed "s/\"keyColor\": \".*\"/\"keyColor\": \"$FF_COLOR\"/g" "$CONFIG_FILE" > /tmp/fastfetch_run.jsonc
        
        fastfetch --config /tmp/fastfetch_run.jsonc --logo-color-1 "$FF_COLOR"
    else
        fastfetch
    fi
fi