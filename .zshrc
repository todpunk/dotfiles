# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	zsh-autosuggestions
)


source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


### Specific Env Vars

export TERM=xterm-256color
export GPG_TTY=$(tty)

### Aliases
alias ls='ls -a --color'
alias ll='ls -l'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias realsync='$(/usr/bin/env sync)'
alias sync='echo "You can not sync with WSL2, but you can style do realsync if you need to sync"'

### Keybinds, for envs that need them added back
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line

### Path bullshit

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/completion.zsh.inc"; fi

# Setup Oracle Cloud CLI if you have it
[[ -e "${HOME}/lib/oracle-cli/lib/python3.8/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "${HOME}/lib/oracle-cli/lib/python3.8/site-packages/oci_cli/bin/oci_autocomplete.sh"

if [[ -f "${HOME}/.localvars" ]]; then
    source "${HOME}/.localvars"
fi

if [[ -f "${HOME}/.sharedrc" ]]; then
    source "${HOME}/.sharedrc"
fi

if [ -f "$HOME/.cargo/env" ] ; then
    source "$HOME/.cargo/env"
fi

if [ -f "$HOME/.rover/env" ] ; then
    source "/home/todhansmann/.rover/env"
fi

# Finally setup new commands
fuck () {
    TF_PYTHONIOENCODING=$PYTHONIOENCODING;
    export TF_SHELL=zsh;
    export TF_ALIAS=fuck;
    TF_SHELL_ALIASES=$(alias);
    export TF_SHELL_ALIASES;
    TF_HISTORY="$(fc -ln -10)";
    export TF_HISTORY;
    export PYTHONIOENCODING=utf-8;
    TF_CMD=$(
        thefuck THEFUCK_ARGUMENT_PLACEHOLDER $@
    ) && eval $TF_CMD;
    unset TF_HISTORY;
    export PYTHONIOENCODING=$TF_PYTHONIOENCODING;
    test -n "$TF_CMD" && print -s $TF_CMD
}

devmux () {
    echo "new devmux"
    tmux new-session -t 'dev' \; \
        new-window \; \
        split-window -v -p 18 \; \
    ; 
}

# Yoinked from https://askubuntu.com/questions/411503/is-there-a-dynamic-multiple-monitor-friendly-desktop-environment-available-for-u
win_save() {
    if [ -f $HOME/.my_windows_config.txt ]; then
        mv $HOME/.my_windows_config.txt $HOME/.my_windows_config.txt.prev
    fi
    wmctrl -p -G -l | awk '($2 != -1)&&($3 != 0)&&($NF != "Desktop")' | awk '{print $1}' | while read mywinid
    do
    xwininfo -id "$mywinid" >> $HOME/.my_windows_config.txt
    done
}

win_restore() {
    file=$HOME/.my_windows_config.txt
    declare -a mywinid
    declare -a x
    declare -a y
    declare -a width
    declare -a height

    nl=$(cat "$file" | grep xwininfo |wc -l)

    for i in $(seq 1 $nl)
    do
        mywinid[i]=$(cat "$file" | grep "xwininfo" | awk -v p="$i" '{if(NR==p) print $4}')
        x[i]=$(cat "$file" | grep "Absolute upper-left X" | awk -v p="$i" '{if(NR==p) print $NF}')
        y[i]=$(cat "$file" | grep "Absolute upper-left Y" | awk -v p="$i" '{if(NR==p) print $NF}')
        width[i]=$(cat "$file" | grep "Width" | awk -v p="$i" '{if(NR==p) print $NF}')
        height[i]=$(cat "$file" | grep "Height" | awk -v p="$i" '{if(NR==p) print $NF}')
    done
 
    for it in $(seq 1 $nl)
    do
        wmctrl -i -r "${mywinid[$it]}" -e 0,"${x[$it]}","${y[$it]}","${width[it]}","${height[it]}"
    done
}

# This is required before we start messing with go since go is in the envman paths
# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# configure rust environment
#
# - autocomplete
# - rust-analyzer
# - cargo audit
# - cargo-nextest
# - cargo fmt
# - cargo clippy
# - cargo edit
#
if [ ! -f "$HOME/.config/rustlang/autocomplete/rustup" ]; then
  mkdir -p ~/.config/rustlang/autocomplete
  rustup completions bash rustup >> ~/.config/rustlang/autocomplete/rustup
fi
source "$HOME/.config/rustlang/autocomplete/rustup"
if ! command -v rust-analyzer &> /dev/null
then
  curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
  chmod +x ~/.local/bin/rust-analyzer
fi
if ! cargo audit --version &> /dev/null; then
  cargo install cargo-audit --features=fix
fi
if ! cargo nextest --version &> /dev/null; then
  cargo install cargo-nextest
fi
if ! cargo fmt --version &> /dev/null; then
  rustup component add rustfmt
fi
if ! cargo clippy --version &> /dev/null; then
  rustup component add clippy
fi
if ! ls ~/.cargo/bin | grep 'cargo-upgrade' &> /dev/null; then
  cargo install cargo-edit
fi

