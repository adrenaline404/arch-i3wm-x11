export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nano"
export TERMINAL="kitty"
export BROWSER="firefox"

export MPLBACKEND=Agg 

export GTK_MODULES=canberra-gtk-module

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

autoload -Uz compinit
zstyle ':completion:*' menu select

zmodload zsh/complist

compinit
_comp_options+=(globdots)

alias ll='ls -l'
alias la='ls -a'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

alias update='yay -Syu'
alias install='yay -S'
alias remove='yay -Rns'
alias cleanup='yay -Yc'

alias c='clear'
alias q='exit'
alias grep='grep --color=auto'

alias config='cd ~/.config/i3'
alias conf-nvim='cd ~/.config/nvim'
alias project='cd ~/arch-i3wm-x11'

if command -v bat > /dev/null; then
    alias cat='bat'
fi

if command -v eza > /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -al --icons --group-directories-first'
fi

if [[ -o interactive ]]; then
    
    if [ -d ~/.config/i3/themes/current ]; then
        CURRENT_THEME_PATH=$(readlink -f ~/.config/i3/themes/current)
    else
        CURRENT_THEME_PATH="pro-dark"
    fi
    
    if [[ "$CURRENT_THEME_PATH" == *"pro-dark"* ]]; then
        FF_COLOR="magenta"
    elif [[ "$CURRENT_THEME_PATH" == *"pywal-custom"* ]]; then
        FF_COLOR="blue"
    else
        FF_COLOR="magenta" 
    fi

    RANDOM_NUM=$(( ( RANDOM % 3 ) + 1 ))
    RANDOM_PRESET=$(printf "%02d" $RANDOM_NUM)
    CONFIG_FILE="$HOME/.config/fastfetch/presets/${RANDOM_PRESET}.jsonc"

    if [ -f "$CONFIG_FILE" ]; then
        sed "s/\"keyColor\": \".*\"/\"keyColor\": \"$FF_COLOR\"/g" "$CONFIG_FILE" > /tmp/fastfetch_run.jsonc
        
        fastfetch --config /tmp/fastfetch_run.jsonc
    else
        fastfetch
    fi
fi

if command -v starship > /dev/null; then
    eval "$(starship init zsh)"
fi

if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi