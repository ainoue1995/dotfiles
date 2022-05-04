########################################
# 環境変数
export LANG=ja_JP.UTF-8

########################################


# git-promptの読み込み
source ~/.zsh/completion/git-prompt.sh
zstyle ':completion:*:*:git:*' script ~/.zsh/completion/git-completion.bash

# プロンプトのオプション表示設定
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

# プロンプトの表示設定(好きなようにカスタマイズ可)
setopt PROMPT_SUBST
PS1='%F{green}%n@%m%f: %F{cyan}%~%f %F{red}$(__git_ps1 "(%s)")%f
\$ '

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# デフォルトでメニュー補完するが、rmの引数のときにはメニュー補完をしない
zstyle ':completion:*' menu true
zstyle ':completion:*:rm:*' menu false

# sudo の後ろでコマンド名を補完する
#zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
#  /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# 色を使用出来るようにする
autoload -Uz colors
colors

# emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# 1行表示
# PROMPT="aki%~ %# "
# 2行表示
# PROMPT="%F{213}%m%f %F{magenta}%W%f %F{39}%*%f @%K{cyan}%F{black}%~%f%k
# %# "

function left-prompt {
  name_t='126m%}'            # user name text clolr
  name_b='000m%}'            # user name background color
  path_t='255m%}'            # path text clolr
  path_b='031m%}'            # path background color
  arrow='228m%}'             # arrow color
  text_color='%{\e[38;5;'    # set text color
  back_color='%{\e[30;48;5;' # set background color
  reset='%{\e[0m%}'          # reset
  sharp="\uE0B0"             # triangle

  user="${back_color}${name_b}${text_color}${name_t}"
  dir="${back_color}${path_b}${text_color}${path_t}"
  echo "${user}%n%#@%m${back_color}${path_b}${text_color}${name_b}${sharp} ${dir}%~${reset}${text_color}${path_b}${sharp}${reset}\n${text_color}${arrow}> ${reset}"
}

PROMPT=$(left-prompt)

function precmd() {
  # Print a newline before the prompt, unless it's the
  # first prompt in the process.
  if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
    NEW_LINE_BEFORE_PROMPT=1
  elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
    echo ""
  fi
}

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
  LANG=en_US.UTF-8 vcs_info
  RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg

########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# no match foundを防ぐため
setopt +o nomatch

########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
# bindkey '^R' history-incremental-pattern-search-backward

########################################
# エイリアス

# lsのカラー
export CLICOLOR=1
export LSCOLORS=gxfxxxxxcxxxxxxxxxgxgx

alias ls='ls -G'
alias ll='ls -laG'
alias la='ls -lG'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

alias dc='docker-compose'
alias dcp='docker-compose ps'
alias dcud='docker-compose up -d'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcs='docker-compose stop'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

function _mov2mp4() {
  if [ $# != 2 ]; then
    echo '引数の数が違うよ'
    return
  fi
  if [[ ! $1 =~ .*\.mov$ ]]; then
    echo '第1引数はmovふぁいるにしてね'
    return
  fi
  if [[ ! $2 =~ .*\.mp4$ ]]; then
    echo '第2引数はmp4ふぁいるにしてね'
    return
  fi
  ffmpeg -i $1 -pix_fmt yuv444p $2
}

function _mov2gif() {
  if [ $# != 2 ]; then
    echo '引数の数が違うよ'
    return
  fi
  if [[ ! $1 =~ .*\.mov$ ]]; then
    echo '第1引数はmovふぁいるにしてね'
    return
  fi
  if [[ ! $2 =~ .*\.gif$ ]]; then
    echo '第2引数はgifふぁいるにしてね'
    return
  fi
  ffmpeg -i $1 -lavfi "fps=12,scale=900:-1:flags=lanczos" -y $2
}

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'
alias -g gst='git status'
alias -g dp='docker ps --format "table {{.ID}} {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias -g dpu='docker-compose up'
alias -g dp='docker-compose'
alias -g m24='_mov2mp4'
alias -g m2g='_mov2gif'
alias -g dc='docker-compose'

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1; then
  # Mac
  alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1; then
  # Linux
  alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1; then
  # Cygwin
  alias -g C='| putclip'
fi

########################################
# OS 別の設定
case ${OSTYPE} in
darwin*)
  #Mac用の設定
  export CLICOLOR=1
  alias ls='ls -G -F'
  ;;
linux*)
  #Linux用の設定
  alias ls='ls -F --color=auto'
  ;;
esac

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion() {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    if ! IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
      COMP_LINE="$COMP_LINE" \
      COMP_POINT="$COMP_POINT" \
      npm completion -- "${words[@]}" \
      2>/dev/null)); then
      local ret=$?
      IFS="$si"
      return $ret
    fi
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT - 1)) \
      COMP_LINE=$BUFFER \
      COMP_POINT=0 \
      npm completion -- "${words[@]}" \
      2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion() {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    if ! IFS=$'\n' reply=($(COMP_CWORD="$cword" \
      COMP_LINE="$line" \
      COMP_POINT="$point" \
      npm completion -- "${words[@]}" \
      2>/dev/null)); then

      local ret=$?
      IFS="$si"
      return $ret
    fi
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###

# peco settings
# 過去に実行したコマンドを選択。ctrl-uにバインド
function peco-select-history() {
  BUFFER=$(\history -nr 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^u' peco-select-history

# search a destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l |
    sed -e 's/^[[:digit:]]*[[:blank:]]*//' |
    peco --query "$LBUFFER"
}

# # Ctrl+x -> Ctrl+b
# # peco でGitブランチを表示して切替え
# bindkey '^b' anyframe-widget-checkout-git-branch
# zle -N anyframe-widget-checkout-git-branch

# ブランチを簡単切り替え。git checkout lbで実行できる
alias -g lb='`git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'

# dockerコンテナに入る。deで実行できる
alias de='docker exec -it $(docker ps | peco | cut -d " " -f 1) /bin/bash'

typeset -U path PATH
export N_PREFIX=$HOME/.n

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 補完
# 補完機能を有効にする

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  FPATH=~/.zsh/completion:$FPATH

  autoload -Uz compinit
  compinit
fi

path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /opt/homebrew/opt/curl/bin
  /opt/homebrew/opt/openjdk/bin
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin
  /usr/local/go/bin
  $HOME/.goenv
  $GOENV_ROOT/bin
  $N_PREFIX/bin
)

# go lang setting
eval "$(goenv init -)"