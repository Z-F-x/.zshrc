# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="zfx"

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

fastfetch

# fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc


alias uallmu='sudo pacman -Suy yay -Suy flatpak update snap refresh'
alias uallp='sudo pacman -Suy && yay -Suy && flatpak update && snap refresh'
alias uallmi='sudo pacman -Suy; yay -Suy; sudo flatpak update; sudo snap refresh'


# alias ls='clear; eza -a --icons -1'
alias ls='ls_dynamic'
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
alias CLS='clear'
alias clø='clear'
alias clå='clear'
alias clæ='clear'
alias cøl='clear'
alias cål='clear'
alias cæl='clear'
alias cdl='cdw'







ls_dynamic() {
    # Set the directory you want to check (use the current directory by default)
    DIR="${1:-.}"
    
    # Count the total number of files and directories (including hidden ones)
    item_count=$(find "$DIR" -maxdepth 1 -mindepth 1 | wc -l)

    # Debugging output: show the item count
    echo "Item count: $item_count"

    # Check if the item count is more than 20
    if [ "$item_count" -gt 20 ]; then
        # Just run eza without column formatting
        eza -a --icons "$DIR"
#clear; eza -a --icons -1 "$DIR"

    else
        # Run eza with icons and format the output with column
        eza -a --icons -1 "$DIR" 
    fi
}



# Function to handle selecting and opening files or directories
open_ls() {
    # Use eza (or ls) for listing files and folders
    local selected=$(eza -1 --icons "$DIR" | fzf --height=40% --border --prompt="Select a file or folder: ")

    # Strip enclosing single quotes if present
    selected=$(echo "$selected" | sed "s/^'//;s/'$//")

    # Check if selection is valid
    if [ -n "$selected" ]; then
        if [ -d "$selected" ]; then
            # Navigate into the directory
            cd "$selected" || echo "Failed to navigate to '$selected'"
            echo "You are now in: $(pwd)"
            eza -1 --icons  # Optionally list the contents of the new directory
        elif [ -f "$selected" ]; then
            # Open the file in nvim
            nvim "$selected"
        else
            echo "Error: '$selected' is neither a file nor a folder."
        fi
    else
        echo "No selection made."
    fi
}



alias lsnav='open_ls'
alias vim='nvim'
alias oldvim='vim'
alias nav='open_ls'


#open_lss() {
# Use eza (or ls) with icons for listing files and folders
#    local selected=$(eza -1 --icons | fzf --height=40% --border --prompt="Select a file or folder: ")

# Strip only the leading spaces and icons, but preserve the file/folder name as is
#    selected=$(echo "$selected" | sed -E 's/^[^ ]+ +//')

# Check if selection is valid
#    if [ -n "$selected" ]; then
#        if [ -d "$selected" ]; then
            # Navigate into the directory
#            cd "$selected" || echo "Failed to navigate to '$selected'"
#           echo "You are now in: $(pwd)"
#           eza -1 --icons  # Optionally list the contents
#        elif [ -f "$selected" ]; then
            # Open the file in nvim
#            nvim "$selected"
#        else
#            echo "Error: '$selected' is neither a file nor a folder."
#        fi
#    else
#        echo "No selection made."
#    fi
# }
# alias lsnavv='open_lss'


select_open() {
    local file=$(ls -1 | fzf)
    [ -n "$file" ] && xdg-open "$file" >/dev/null 2>&1
}
export NNN_OPENER="xdg-open"

# echo 'export GTK_IM_MODULE=xim' >> ~/.zshrc
# echo 'export QT_IM_MODULE=xim' >> ~/.zshrc
# echo 'export XMODIFIERS=@im=xim' >> ~/.zshrc



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


remove_duplicates_and_update_visits() {
    local cd_history_file=~/.cd_history
    local cd_visits_file=~/.cd_visits

    # Check if .cd_history exists
    [[ -f "$cd_history_file" ]] || touch "$cd_history_file"
    # Update .cd_visits
    update_cd_visits "$cd_history_file" "$cd_visits_file"

    # Remove duplicates from .cd_history while preserving the latest entry order
    tac "$cd_history_file" | awk '!seen[$0]++' | tac > "${cd_history_file}.tmp"
    mv "${cd_history_file}.tmp" "$cd_history_file"

    # Replace ./ with ~ in .cd_history
    replace_dot_slash_with_tilde "$cd_history_file"

}

replace_dot_slash_with_tilde() {
    local cd_history_file="$1"
    
    # Replace occurrences of './' with '~' in the file
    sed -i 's|^\./|~|g' "$cd_history_file"
}

# TODO:
# Probmel ser ut til å være at det blir ikke skrevet fullstendig path til .cd_visits 
# Må gå gjennom det og finne ut hvor det går galt, må skrive riktig path slik som .cd_history
# Må også legge til increment på hvert hit / hver gang bruker søker en filbane.

 update_cd_visits() {
    local cd_history_file="$1"
    local cd_visits_file="$2"

    # Create a temporary file to store new visit counts
    tmp_file=$(mktemp)

    # Count visits to each directory and write to the temporary file
    awk '
    {
        count[$0]++;
    }
    END {
        for (dir in count) {
            print dir " " count[dir];
        }
    }' "$cd_history_file" | sort -k2,2nr -k1,1 > "$tmp_file"

    # If the visits file already exists, update it with new counts
    if [[ -f "$cd_visits_file" ]]; then
        # Merge the existing visits file with the new counts and sort them
        awk '
        BEGIN {
            while ((getline < "'"$cd_visits_file"'") > 0) {
                # Read existing data into the count array
                count[$1] = $2;
            }
        }
        {
            # Add the new counts from the temporary file
            count[$1] += $2;
        }
        END {
            for (dir in count) {
                print dir " " count[dir];
            }
        }' "$tmp_file" | sort -k2,2nr -k1,1 > "$cd_visits_file"
    else
        # If no visits file exists, simply create it with the new counts
        mv "$tmp_file" "$cd_visits_file"
    fi
}


cd() {
  # Change to the directory using the built-in cd command
  builtin cd "$1" || return

  # Create .cd_history if it doesn't exist
  local cd_history_file=~/.cd_history
  [[ -f "$cd_history_file" ]] || touch "$cd_history_file"

  # Get the current directory path after the change
  local current_dir=$(pwd)

  # Resolve ~ to the full home directory path
  local home_dir="$HOME"

  # If the current directory is the home directory, log as ~
  if [[ "$current_dir" == "$home_dir" ]]; then
      current_dir="~"  # Log as ~ if we're in the home directory
  # If the current directory is inside the home directory, log it as an absolute path
  elif [[ "$current_dir" == "$home_dir"* ]]; then
      current_dir="$current_dir"  # Keep it as absolute path
  # If the user types `cd ~`, log it as `~`
  elif [[ "$current_dir" == "~" ]]; then
      current_dir="~"  # Log as ~ if explicitly in the home directory
  fi

  # Log the current absolute directory to .cd_history
  echo "$current_dir" >> "$cd_history_file"     

  # Remove duplicates and update .cd_visits
  remove_duplicates_and_update_visits

  # Now call ls_dynamic for the newly navigated directory
  ls_dynamic "$current_dir"
}

ls_dynamic() {
  # Set the directory you want to check (use the current directory passed as argument)
  local DIR="${1:-$(pwd)}"

  # If the directory is "~", resolve it to the actual home directory
  if [[ "$DIR" == "~" ]]; then
    DIR="$HOME"
  fi

  # Use `find` on the directory path, correctly handling spaces in paths
  item_count=$(find "$DIR" -maxdepth 1 -mindepth 1 | wc -l)

  # Debugging output: show the item count
  echo "Item count: $item_count"

  # Check if the item count is more than 20
  if [ "$item_count" -gt 20 ]; then
      # Just run eza without column formatting
      eza -a --icons "$DIR"
  else
      # Run eza with icons and format the output with column
      eza -a --icons -1 "$DIR"
  fi
}


cdw() {
    local cd_history_file=~/.cd_history

    # Check if .cd_visits exists
    [[ -f "$cd_history_file" ]] || touch "$cd_history_file"

    # Use fzf to list directories, ensuring quoted paths with spaces are handled
   # local dir=$(cat "$cd_history_file" | fzf --height 20 --reverse --prompt="Select directory: ")
    local dir=$(cat "$cd_history_file" | head -n 25 | fzf --height 20 --reverse --prompt="Select directory: ")
    # Check if the selected directory is not empty
    if [[ -n "$dir" ]]; then
        # Display the cd command in the terminal
        echo "cd $dir"

        # Change to the selected directory
        eval "cd $dir"
    else
        echo "No directory selected."
    fi

        remove_duplicates_and_update_visits
}



export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export XMODIFIERS=@im=xim
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim

# Enable Right Windows key + Vim-style navigation (Windows + h, j, k, l)
bindkey -M emacs "^[[27;5;h" backward-char      # Windows + h to move left
bindkey -M emacs "^[[27;5;l" forward-char       # Windows + l to move right
bindkey -M emacs "^[[27;5;j" down-line-or-history # Windows + j to move down
bindkey -M emacs "^[[27;5;k" up-line-or-history   # Windows + k to move up

# Android SDK

export ANDROID_HOME=/home/zfx/Android/Sdk
unset ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=$PATH:~/gradle/bin

#Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk 
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$PATH:/home/zfx/.local/bin

echo -e "\e[2 q"  # Forces a block cursor at all times

