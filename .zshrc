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

# Update path
export PATH="$HOME/bin:$PATH"
