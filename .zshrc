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

# Navigation functionality that overwrites normal functionality of the `cd`
# command. Clears screen inbetween each navigational step. Uses eza.

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

# Aliases for open_ls
alias lsnav='open_ls'
alias nav='open_ls'

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
# ############################################################################ #
#                         File System Navigation Ends                          # 
# ############################################################################ #
#                                  cdw begins
# ############################################################################ #
#   Set of scripts to keep track of top 25 most used file system paths        #
# ############################################################################ #

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
  clear
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
      eza -a --icons  --group-directories-first "$DIR"
  else
      # Run eza with icons and format the output with column
      eza -a --icons -1  --group-directories-first "$DIR"
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

# ############################################################################ #
# cdw ends - Set of scripts to keep track of top 25 most used file ...         #
# ############################################################################ #
#                        Language, Locale & Input begins:                      #
# ############################################################################ #

# Set Norwegian Bokmål keyboard layout if not already set
# if [[ "$(setxkbmap -query | grep layout | awk '{print $2}')" != "no" ]]; then
#     setxkbmap no
# fi

# Set default language and encoding
export LANG="en_US.UTF-8"  

# Ensure UTF-8 character encoding is used
export LC_CTYPE="en_US.UTF-8"  

# Use American Englishfor system messages
export LC_MESSAGES="en_US.UTF-8"  

# Use Norwegian format for date/time (dd.mm.yyyy)
export LC_TIME="nb_NO.UTF-8"  

# Set currency format to Norwegian (Kroner)
export LC_MONETARY="nb_NO.UTF-8"  

# Use Norwegian decimal separators (comma instead of dot)
export LC_NUMERIC="nb_NO.UTF-8"  

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

# Add user's local binary directory to PATH for user-specific binaries and scripts
export PATH=$PATH:/home/zfx/.local/bin

# ########################################################################### #
