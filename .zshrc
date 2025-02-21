
# Source shell scripts

# source /home/zfx/gnulinux-utils/mount-unmount-drives.sh and all other shell scripts in there
for file in ~/gnulinux-utils/*.sh; do source $file; done

# source all shell scripts in /home/zfx/gnulinux-zfx/
for file in ~/gnulinux-zfx/*.sh; do source $file; done


# ########################################################################### #
#                                Aestethics:                                  #
# ########################################################################### #

# Forces block cursor at all times
echo -e "\e[2 q" 

# If the FBTERM environment variable is set (indicating the use of a framebuffer terminal),
# set the terminal type to 'fbterm' for enhanced color support and graphical capabilities.
# Enabling true color, 256 color I think:
[ -n "$FBTERM" ] && export TERM=fbterm


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export TERM=xterm-256color

# ########################################################################### #

# Custom theme for zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="zfx"

# Plugins
plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# runs the oh-my-zsh.sh script from /home/user/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# Runs everytime a new terminal window is opened
fastfetch

# fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc



# #############################################################################
#                           File Operations                                   #
# #############################################################################

# Alias for mvfiles
alias move-files="mvfiles"
alias move_files="mvfiles"
alias mv-files="mvfiles"

# Move all files (not folders) in current directory to path  
mvfiles() {
  if [[ -z "$1" ]]; then
    echo "Usage: movefiles <destination_folder>"
    return 1
  fi
  find . -maxdepth 1 -type f -exec mv {} "$1" \;
}

# Alias for mvall
alias move-all="mvall"
alias mv-all="mvall"
alias move_all="mvall"

# Move all files and folders in current directory to path
mvall() {
  if [[ -z "$1" ]]; then
    echo "Usage: moveall <destination_folder>"
    return 1
  fi
  mv -- * "$1"
}

# #############################################################################
#                          File System Navigation                             #
# #############################################################################

# Formatting function as empty string is outputtet as blank line 
lsformat(){
echo ""
}

# Informational message at the end of lsf (List Files)
lsfecho() {
  echo -e "\n\033[1;37m  \033[38;5;250m Use \033[1;32mlsfa\033[38;5;250m to see hidden files.\033[0m\n"
}

# Informational message at the end of lsfh
lsfhidden(){
  echo -e "\n\033[1;37m  \033[38;5;250m Use \033[1;32mlsfh\033[38;5;250m to \033[1;4monly\033[0m hidden files.\033[0m\n"
}

# add_icons_to_files() {
#     eza_output=$(eza -1 --icons -a --only-files | sed -n '/^\./p')
#
#     while IFS= read -r file; do
#         # Use eza's output to add the correct icon to each file
#         # eza automatically displays icons based on file types, so we can capture the icon and filename
#         icon=$(echo "$file" | cut -d ' ' -f1)  # Capture the icon
#         filename=$(echo "$file" | cut -d ' ' -f2-)  # Capture the filename
#         echo "$icon $filename"  # Display the icon along with the filename
#     done <<< "$eza_output"
# }

# TODO: Write custom icon-set for each file type similar to eza 
add_icons_to_files() {
    eza -1 --icons -a --only-files | sed -n '/^\./p' | while IFS= read -r line; do
        echo "📄 $line"  # Add a custom emoji or text before each file
    done
}

alias lsfiles="list_specific_file_type_eza"
alias lsftype="list_specific_file_type_eza"
alias lsft="list_specific_file_type_eza"
alias lsfiletype="list_specific_file_type_eza"
alias filetype="list_specific_file_type_eza"
alias ft="list_specific_file_type_eza"
alias lst="list_specific_file_type_eza"
alias lstype="list_specific_file_type_eza"

# TODO: Add function that counts the total ammount of files of specific file
# type, and 2). Adds an appropriate icon with proper formattingo. And 3). A
# informational message  For more options do -f -a -b -c etc. 

# List specific file types. E.g., lsfiles .txt 
list_specific_file_type_eza() {
  if [[ -z "$1" ]]; then
    echo "Usage: listfiles <extension>"
    return 1
  fi

  # Remove leading dot if user includes it (normalize input)
  ext="${1#.}"

  # Check if any file has the given extension
  matches=(*."$ext"(.N)) # Zsh globbing to find matching files

  if [[ ${#matches[@]} -eq 0 ]]; then
    echo "No files found with .$ext extension."
    return 1
  fi

  # Use eza if installed, otherwise fallback to ls
  if command -v eza &>/dev/null; then
    eza --icons --group-directories-first *."$ext"
  else
    ls -lh *."$ext"
  fi
}

# List only files
alias sortbytype="list_files_sort_extension"
alias sftype="list_files_sort_extension"
alias lstype="list_files_sort_extension"

# List only files (not folders nor files in folders) in current directory
list_files_sort_extension() {
  # Use eza if installed
  if command -v eza &>/dev/null; then
    eza --icons --only-files --color=always --sort=ext
  else
    # Fallback to ls + sort
    ls -lh --color=always | sort -k9 -t.
  fi
}

# List files and folders and sort files by extensions
alias sortall="list_files_and_folders_sort_by_extensions"
list_files_and_folders_sort_by_extensions() {
  # Use eza if installed
  if command -v eza &>/dev/null; then
    eza --icons  --group-directories-first --color=always --sort=ext
  else
    # Fallback to ls + sort
    ls -lh --color=always | sort -k9 -t.
  fi
}

# lsfile() {
#   if [[ -z "$1" ]]; then
#     echo "Usage: listfiles <pattern>"
#     return 1
#   fi
#   printf "%s\n" *"$1"*
# }

# alias lsfall='list_all_files_in_current_directory'
# alias lsfilesall='list_all_files_in_current_directory'

# list_all_files_in_current_directory() {
#   if [[ -z "$1" ]]; then
#     echo "Usage: listfiles <pattern>"
#     return 1
#   fi
#   eza --ignore-glob="!*$1*" --icons --only-files
# }

# Alias turning vim to nvim
alias vim='nvim'

# Alias for old vim
alias oldvim='vim'


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


# Opens fzf in currrent dir in terminal
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

# .zsh history 
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Navigation functionality that overwrites normal functionality of the `cd`
# command. Clears screen inbetween each navigational step. Uses eza.

# TODO: Check if this actually is being used: Aliases for open_ls
alias lsnav='open_ls'
alias nav='open_ls'

# Navigation functionality that overwrites normal functionality of the `cd`
# command. Clears screen inbetween each navigational step. Uses eza.

 alias ls='clear; ls_dynamic'

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
        eza -a --icons  --group-directories-first "$DIR"
#clear; eza -a --icons -1 "$DIR"

    else
        # Run eza with icons and format the output with column
        eza -a --icons -1 --group-directories-first "$DIR" 
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


# ############################################################################ #
#                                  cdw begins
# ############################################################################ #
#   Set of scripts to keep track of top 25 most used file system paths        #
# ############################################################################ #


remove_duplicates_and_update_visits() {
    local cd_history_file=~/.cd_history
    local cd_visits_file=~/.cd_visits

    [[ -f "$cd_history_file" ]] || touch "$cd_history_file"

    update_cd_visits "$cd_history_file" "$cd_visits_file"

    # Remove duplicates while keeping latest entries
    tac "$cd_history_file" | awk '!seen[$0]++' | tac > "${cd_history_file}.tmp"
    mv "${cd_history_file}.tmp" "$cd_history_file"

    # Normalize paths
    replace_dot_slash_with_tilde "$cd_history_file"
}

replace_dot_slash_with_tilde() {
    local file="$1"
    sed -i 's|^\./|~|g' "$file"
}

update_cd_visits() {
    local cd_master_log="$1"
    local cd_visits_file="$2"

    # Ensure the master log exists
    [[ -f "$cd_master_log" ]] || touch "$cd_master_log"

    # Count occurrences and store the top 25
    awk '{ count[$0]++ } END { for (dir in count) print count[dir], dir }' "$cd_master_log" \
        | sort -nr \
        | head -n 25 \
        > "$cd_visits_file"
}

cd() {
    builtin cd "$1" || return
    local cd_history_file=~/.cd_history
    local cd_master_log=~/.cd_master_log
    local cd_visits_file=~/.cd_visits
    local current_dir=$(pwd)

    [[ -f "$cd_history_file" ]] || touch "$cd_history_file"
    [[ -f "$cd_master_log" ]] || touch "$cd_master_log"

    # Normalize home directory paths
    [[ "$current_dir" == "$HOME" ]] && current_dir="~"

    echo "$current_dir" >> "$cd_history_file"
    echo "$current_dir" >> "$cd_master_log"

    update_cd_visits "$cd_master_log" "$cd_visits_file"

    ls_dynamic "$current_dir"
}

ls_dynamic() {
    clear
    local DIR="${1:-$(pwd)}"

    [[ "$DIR" == "~" ]] && DIR="$HOME"

    item_count=$(find "$DIR" -maxdepth 1 -mindepth 1 | wc -l)
    echo "Item count: $item_count"

    if [ "$item_count" -gt 20 ]; then
        eza -a --icons --group-directories-first "$DIR"
    else
        eza -a --icons -1 --group-directories-first "$DIR"
    fi
}

cdw() {
    local cd_visits_file=~/.cd_visits
    [[ -f "$cd_visits_file" ]] || touch "$cd_visits_file"

    local dir=$(cut -d' ' -f2- "$cd_visits_file" | fzf --height 20 --reverse --prompt="Select directory: ")

    if [[ -n "$dir" ]]; then
        echo "cd $dir"
        eval cd "$dir"
    else
        echo "No directory selected."
    fi
}


# ############################################################################ #
# cdw ends - Set of scripts to keep track of top 25 most used file ...         #
# ############################################################################ #
#                         File System Navigation END.                          # 
# ############################################################################ #
#                        Language, Locale & Input BEGIN:                       #
# ############################################################################ #

# Set Norwegian Bokmål keyboard layout if not already set
# if [[ "$(setxkbmap -query | grep layout | awk '{print $2}')" != "no" ]]; then
#     setxkbmap no
# fi

# Set default Nynorsk language and encoding
export LANG="nn_NO.UTF-8"  

# Ensure Nynorsk UTF-8 character encoding is used
export LC_CTYPE="nn_NO.UTF-8"  

# Use Nynorsk  system messages
export LC_MESSAGES="nn_NO.UTF-8"  

# Use Norwegian format for date/time (dd.mm.yyyy)
export LC_TIME="nn_NO.UTF-8"  

# Set currency format to Norwegian (Kroner)
export LC_MONETARY="nn_NO.UTF-8"  

# Use Norwegian decimal separators (comma instead of dot)
export LC_NUMERIC="nn_NO.UTF-8"  

# Keep default sorting behavior (C uses traditional ASCII sorting)
export LC_COLLATE="C"  

# Set X Input Method (XIM) as the input method framework for X applications
export XMODIFIERS=@im=xim  

# Force GTK applications (like Gedit, Firefox) to use XIM for handling text input
export GTK_IM_MODULE=xim  

# Force Qt applications (like VLC, Dolphin) to use XIM for handling text input
export QT_IM_MODULE=xim 

# ########################################################################### #
#                              Vim-related:                                   #
# ########################################################################### #

# Enable Right Windows key + Vim-style navigation (Windows + h, j, k, l)
bindkey -M emacs "^[[27;5;h" backward-char      # Windows + h to move left
bindkey -M emacs "^[[27;5;l" forward-char       # Windows + l to move right
bindkey -M emacs "^[[27;5;j" down-line-or-history # Windows + j to move down
bindkey -M emacs "^[[27;5;k" up-line-or-history   # Windows + k to move up

# ########################################################################### #
#                              Developement related:                          #
# ########################################################################### #

# Android SDK

# Set Android SDK home directory
export ANDROID_HOME=/home/zfx/Android/Sdk

# Unset any existing Android SDK root variable to avoid conflicts
unset ANDROID_SDK_ROOT

# Add Android SDK tools and platform-tools directories to PATH for easy access to adb, fastboot, etc.
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Add Gradle binary directory to PATH for easy access to Gradle commands
export PATH=$PATH:~/gradle/bin

# Java

# Set Java home directory to Java 17 (OpenJDK)
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk 

# Add Java binary directory to PATH for access to java, javac, etc.
export PATH=$JAVA_HOME/bin:$PATH


# Binaries

# Add user's local binary directory to PATH for user-specific binaries and scripts
# export PATH=$PATH:/home/zfx/.local/bin

# export XDG_DATA_HOME=/var/lib/flatpak/exports/share

# export XDG_DATA_DIRS=/var/lib/flatpak/exports/share

# Add user's local binary directory to PATH for user-specific binaries and scripts
# export PATH="$HOME/.local/bin:$PATH"

# Ensure Flatpak export paths are included
# export XDG_DATA_HOME="$HOME/.local/share"
# export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"

export XMODIFIERS=@im=xim
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim

# ########################################################################### #
#            --- Media Playback Functions with fzf Selection ---
# ########################################################################### #

# Function to play video files using cvlc (VLC's command-line version)
vlc() {
  # If no argument is provided, launch fzf to select a video file.
  if [[ $# -eq 0 ]]; then
    # Find common video file types only in the current directory
    local file
    file=$(find . -maxdepth 1 -type f \( -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.avi' -o -iname '*.mov' \) 2>/dev/null | fzf --prompt="Select a video file: ")
    # If a file was selected, play it.
    if [[ -n "$file" ]]; then
      cvlc --play-and-exit "$file"
    fi
  else
    # Otherwise, play the specified file(s) directly.
    cvlc --play-and-exit "$@"
  fi
}



# play() {
#   # If no argument is provided, launch fzf to select an audio file.
#   if [[ $# -eq 0 ]]; then
#     # Find common audio file types (including .wma and .flac) only in the current directory
#     local file
#     file=$(find . -maxdepth 1 -type f \( -iname '*.wma' -o -iname '*.mp3' -o -iname '*.wav' -o -iname '*.ogg' -o -iname '*.flac' \) -print0 2>/dev/null | fzf --prompt="Select an audio file: " --read0 --preview="ffprobe -i {} -hide_banner")
#
#     # If a file was selected, play it.
#     if [[ -n "$file" ]]; then
#       _play_with_controls "$file"
#     fi
#   else
#     # Otherwise, play the specified file(s) directly.
#     _play_with_controls "$@"
#   fi
# }
#
# _play_with_controls() {
#   local file="$1"
#   local ffplay_pid
#
#   # Start ffplay in the background
#   ffplay -nodisp -autoexit -- "$file" &
#   ffplay_pid=$!
#
#   echo "Playing: $file"
#   echo -e "Controls: \n[P] Pause/Play | [←] Rewind 5s | [→] Fast Forward 5s | [Q] Quit"
#
#   # Capture key presses for controls
#   while kill -0 "$ffplay_pid" 2>/dev/null; do
#     # Read a single character without requiring Enter
#     if read -rsn1 key; then
#       case "$key" in
#         p)
#           # Send space key to ffplay to toggle pause
#           kill -SIGUSR1 "$ffplay_pid"
#           echo "Paused/Resumed"
#           ;;
#         $'\x1b') # Handle arrow keys (escape sequence)
#           # Read the next two characters to determine the arrow key
#           if read -rsn2 -t 0.1 key; then
#             if [[ "$key" == "[D" ]]; then
#               # Left arrow: Rewind 5 seconds
#               kill -SIGUSR2 "$ffplay_pid"
#               echo "Rewinding 5s..."
#             elif [[ "$key" == "[C" ]]; then
#               # Right arrow: Fast forward 5 seconds
#               kill -SIGUSR2 "$ffplay_pid"
#               echo "Fast forwarding 5s..."
#             fi
#           fi
#           ;;
#         q)
#           # Quit ffplay
#           echo "Quitting..."
#           kill "$ffplay_pid"
#           break
#           ;;
#       esac
#     fi
#   done
# }

play() {
  # If no argument is provided, launch fzf to select an audio file.
  if [[ $# -eq 0 ]]; then
    # Find common audio file types (including .wma and .flac) only in the current directory
    local file
    file=$(find . -maxdepth 1 -type f \( -iname '*.wma' -o -iname '*.mp3' -o -iname '*.wav' -o -iname '*.ogg' -o -iname '*.flac' \) -print0 2>/dev/null | fzf --prompt="Select an audio file: " --read0 --preview="ffprobe -i {} -hide_banner")

    # If a file was selected, play it.
    if [[ -n "$file" ]]; then
      ffplay -nodisp -autoexit -- "$file"
    fi
  else
    # Otherwise, play the specified file(s) directly.
    ffplay -nodisp -autoexit -- "$@"
  fi
}


# ########################################################################### #
#                    --- Media Playback Functions END ---
# ########################################################################### #


