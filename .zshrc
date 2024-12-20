# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="xiong-chiamiov-plus"

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
# pokemon-colorscripts --no-title -s -r
fastfetch

# fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Set-up icons for files/folders in terminal

alias uallmu='sudo pacman -Suy yay -Suy flatpak update snap refresh'
alias uallp='sudo pacman -Suy && yay -Suy && flatpak update && snap refresh'
alias uallmi='sudo pacman -Suy; yay -Suy; flatpak update; snap refresh'


alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=1 --icons'
alias lt10='eza -a --tree --level=10 --icons'
alias lt9='eza -a --tree --level=9 --icons'
alias lt='eza -a --tree --level=8 --icons'
alias lt7='eza -a --tree --level=7 --icons'
alias lt6='eza -a --tree --level=6 --icons'
alias lt5='eza -a --tree --level=5 --icons'
alias lt4='eza -a --tree --level=4 --icons'
alias lt3='eza -a --tree --level=3 --icons'
alias lt2='eza -a --tree --level=2 --icons'
alias lt1='eza -a --tree --level=1 --icons'
alias lt0='eza -a --tree --level=0 --icons'
alias cls='clear'

echo 'export GTK_IM_MODULE=xim' >> ~/.zshrc
echo 'export QT_IM_MODULE=xim' >> ~/.zshrc
echo 'export XMODIFIERS=@im=xim' >> ~/.zshrc

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
alias AUR='yay'
alias Aur='yay'
alias aur='yay'
alias auR='yay'
alias AuR='yay'
alias Aur='yay'

# Override 'cd' to log directories
cd() {
    builtin cd "$@" || return

    # Create .cd_history if it doesn't exist
    if [[ ! -f ~/.cd_history ]]; then
        touch ~/.cd_history
    fi

    # Log the current directory to .cd_history
    echo "$(pwd)" >> ~/.cd_history
}

cdl() {
    # Generate the top directories with usage counts
    local dir=$(sort ~/.cd_history | uniq -c | sort -nr | awk '{printf "%-6s %s\n", $1, $2}' | fzf --height 20 --reverse --prompt="Select directory: ")
    
    # Extract the directory from the selected line
    local selected_dir=$(echo "$dir" | awk '{print $2}')
    
    # Change to the selected directory if not empty
    if [[ -n "$selected_dir" ]]; then
        cd "$selected_dir"
    else
        echo "No directory selected."
    fi
}




export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export XMODIFIERS=@im=xim
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim

# Android SDK

export ANDROID_HOME=/home/zfx/Android/Sdk
unset ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=$PATH:~/gradle/bin

#Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk 
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$PATH:/home/zfx/.local/bin

