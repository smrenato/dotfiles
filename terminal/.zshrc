### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# =================== user definiitons ===================
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


# Plugin history-search-multi-word loaded with investigating.
zinit light Aloxaf/fzf-tab
zinit load zdharma-continuum/history-search-multi-word
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions


zinit snippet https://gist.githubusercontent.com/hightemp/5071909/raw/
zinit snippet OMZP::git
# zinit snippet OMZP::tmux
# zinit snippet OMZP::docker
zinit snippet OMZP::command-not-found


# history settings
# HISTORY
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

# Setup theme 
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

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

#  miscellaneous
export PATH="/home/smrenato/.local/bin:$PATH"

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
alias get_idf='. $HOME/esp/v5.3/esp-idf/export.sh'


# nvm settings
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# uv
. "$HOME/.cargo/env"
