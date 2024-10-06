ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

fpath+=~/.zfunc

zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zinit light Aloxaf/fzf-tab

# history settings
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt INC_APPEND_HISTORY # history file is updated immediately after a command is entered
setopt SHARE_HISTORY # allows multiple Zsh sessions to share the same command history 
setopt EXTENDED_HISTORY # records the time when each command was executed along with the command itself
setopt APPENDHISTORY # ensures that each command entered in the current session is appended to the history file immediately after execution

setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file


# fzf
source <(fzf --zsh)

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always --style=numbers --line-range=:500 {}'
  --height=~60%
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --bind 'ctrl-j:preview-down,ctrl-k:preview-up'
  --header 'Search and preview'
  "

# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --reverse
  --header 'Press CTRL-Y to copy command into clipboard'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'eza --icons --all -TL 3 {}'
  --header 'Press Enter to cd' 
  "

export FZF_COMPLETION_TRIGGER='...'

# setting default editor to vi mode
export ZVM_VI_EDITOR=nvim

# autocompletions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
#  NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'


# bat 
export BAT_THEME="Dracula"

#alias
alias icat="kitten icat"
alias vim="nvim"
alias cat="bat"
alias ls="eza --icons"

alias of="fd --type f --hidden --exclude .git | \
          fzf --tmux center,50%,40% --layout reverse | \
          xargs -r nvim "

alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# for multiple idf versions
get_idf() {
  IDF_VERSION="$1"
  IDF_PATH="$HOME/esp/$1/esp-idf"

  if [ -z "$1" ]; then
      echo "Usage: give one of the idf version"
      ls -D "$HOME/esp"
      return 1
  fi

  if [ -d $IDF_PATH ]; then
    echo "Setting version to: $IDF_VERSION"
    sleep 2
    source "$HOME/esp/$1/esp-idf/export.sh"

  else
    echo "$IDF_PATH does not exists"
    return 1
  
  fi
}

# Function to toggle activation/deactivation of a Python virtual environment
pshell() {
    local venv_dirs=("venv" ".venv" "env" ".env")

    if [ -n "$1" ]; then
        venv_dirs+=("$1")
    fi

    if [[ "$VIRTUAL_ENV" != "" ]]; then
        deactivate
        echo "Deactivate Python $VIRTUAL_ENV"
        return
    fi

    for dir in "${venv_dirs[@]}"; do
        if [ -d "$dir" ]; then
            source "$dir/bin/activate"

            echo "Activated Python on $dir"
            return
        fi
    done

    echo "No virtual environment found in the specified directories."
}

# nvm settings
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# uv completations
. "$HOME/.cargo/env"

#  miscellaneous
export PATH="$HOME/.local/bin:$PATH"

# starship theme
eval "$(starship init zsh)"
