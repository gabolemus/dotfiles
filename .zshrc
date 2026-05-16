# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

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
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#

HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
bindkey -e

# Aliases
alias ls='ls --color=auto'
alias vim='nvim'
alias sysupdate='sudo pacman -Syu --noconfirm && yay -Sua --noconfirm'
alias rstm='vim -c ":q"'
alias rustrepl='evcxr'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python - --bytes'

# Shell variables
export EDITOR="nvim"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# General settings
set -o noclobber # Prevent overwriting files with `>`

# Setopts
setopt SHARE_HISTORY

# Key bindings
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^H" backward-delete-word # Ctrl+Backspace
bindkey "^[^H" backward-delete-word # Ctrl+Alt+Backspace
bindkey "^[[3;5~" delete-word
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

r-delregion() {
  if ((REGION_ACTIVE)) then
     zle kill-region
  else
    local widget_name=$1
    shift
    zle $widget_name -- $@
  fi
}

r-deselect() {
  ((REGION_ACTIVE = 0))
  local widget_name=$1
  shift
  zle $widget_name -- $@
}

r-select() {
  ((REGION_ACTIVE)) || zle set-mark-command
  local widget_name=$1
  shift
  zle $widget_name -- $@
}

for key     kcap   seq        mode   widget (
  sleft   kLFT    $'\e[1;2D' select   backward-char
  sright  kRIT    $'\e[1;2C' select   forward-char
  sup     kri     $'\e[1;2A' select   up-line-or-history
  sdown   kind    $'\e[1;2B' select   down-line-or-history

  send    kEND    $'\E[1;2F' select   end-of-line
  send2   x       $'\E[4;2~' select   end-of-line

  shome   kHOM    $'\E[1;2H' select   beginning-of-line
  shome2  x       $'\E[1;2~' select   beginning-of-line

  left    kcub1   $'\EOD'    deselect backward-char
  right   kcuf1   $'\EOC'    deselect forward-char

  end     kend    $'\EOF'    deselect end-of-line
  end2    x       $'\E4~'    deselect end-of-line

  home    khome   $'\EOH'    deselect beginning-of-line
  home2   x       $'\E1~'    deselect beginning-of-line

  csleft  x       $'\E[1;6D' select   backward-word
  csright x       $'\E[1;6C' select   forward-word
  csend   x       $'\E[1;6F' select   end-of-line
  cshome  x       $'\E[1;6H' select   beginning-of-line

  cleft   x       $'\E[1;5D' deselect backward-word
  cright  x       $'\E[1;5C' deselect forward-word

  del     kdch1   $'\E[3~'  delregion delete-char
  bs      x       $'^?'     delregion backward-delete-char
) {
  eval "key-$key() {
    r-$mode $widget \$@
  }"

  zle -N key-$key
  bindkey ${terminfo[$kcap]-$seq} key-$key
}

# Prevent removing a space when typing suffix characters
ZLE_REMOVE_SUFFIX_CHARS=""

# Case insensitive completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Syntax highlighting styles
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# Zsh plugins
PLUGIN_DIR="/usr/share/zsh/plugins"

# Check that the plugin directory exists and that at least one plugin is available
if [[ -d "$PLUGIN_DIR" && -n $(find "$PLUGIN_DIR" -type f -name "*.zsh" -print -quit) ]]; then
  # Source each plugin
  for plugin in "$PLUGIN_DIR"/*/*.zsh; do
    source "$plugin"
  done
fi

# Override Zsh syntax highlighting styles
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,bold,underline'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,bold,underline'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#767676,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#767676,bold'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#767676,bold'
# Strings
# Todo: change the color of the strings
# ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=blue,bold'
# ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#3b78ff' # Bright blue
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#3b78ff' # Bright blue
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#3b78ff' # Bright blue
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#3b78ff' # Bright blue
# ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#3b78ff' # Bright blue
ZSH_HIGHLIGHT_STYLES[alias]='fg=#16c60c' # Bright green
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#f9f1a5'
ZSH_HIGHLIGHT_STYLES[command]='fg=#f9f1a5'

# Only initialize Oh My Posh if not running from a TTY session
if [[ "$(tty)" != "/dev/tty"* ]]; then
  # Initialize Oh My Posh
  if type oh-my-posh > /dev/null; then
    eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/gabo-blue-owl.omp.json)"
  else
    export PROMPT="[%n@%m: %~] $(if [[ $EUID -eq 0 ]]; then echo "#"; else echo "$"; fi) "
  fi

  # Check if inside a TMUX session
  if [ -z "$TMUX" ]; then
    # Check if any TMUX session exists
    if tmux ls &>/dev/null; then
      tmux attach-session
    else
      tmux new-session
    fi
  fi
else
    export PROMPT="[%n@%m: %~] $(if [[ $EUID -eq 0 ]]; then echo "#"; else echo "$"; fi) "
fi

# Add NVM to PATH if it exists
if [ -f /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
else
  echo "NVM configuration not found at /usr/share/nvm/"
fi

# Source local Cargo
. "$HOME/.cargo/env"

# Change cursor shape to a beam/pipe (vertical bar)
cursor_beam() {
  # ESC [ 6 q = beam
  #print -ne '\e[6 q'
  print -n '\e[5 q'
}
cursor_beam

precmd() {
  print -n '\e[5 q'
}

export LC_COLLATE=C

# Update path
export PATH="$HOME/bin:/usr/share/dotnet:$PATH"

# Enable tab-completion for .NET
eval "$(dotnet completions script zsh)"
