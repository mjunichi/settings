## pathを設定
path=(~/bin(N-/) /usr/local/bin(N-/) ${path})

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export GITHUB_ACCESS_TOKEN=a8d521ea78b1128edf1f72fc9ea72d9cf1f088b5

eval "$(pyenv init -)"
eval "$(rbenv init -)"

###############
# zsh Setting
###############

# プロンプト定義内で変数置換やコマンド置換を扱う
setopt prompt_subst

# directory
## ディレクトリ名だけで cd
setopt auto_cd
## cd 時に自動で push
setopt auto_pushd
## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

# history
## 履歴の保存先
HISTFILE=$HOME/.zsh-history
## メモリに展開する履歴の数
HISTSIZE=100000
## 保存する履歴の数
SAVEHIST=1000000
## コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
setopt hist_ignore_space
## history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store
## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify
## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history
## 余分な空白は詰めて記録
setopt hist_reduce_blanks
## 古いコマンドと同じものは無視
setopt hist_save_no_dups
## ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups
## 補完時にヒストリを自動的に展開
setopt hist_expand
## シェルを横断して.zshhistoryに記録
setopt inc_append_history
## ヒストリを共有
setopt share_history

# complement
autoload -U compinit && compinit
## TAB で順に補完候補を切り替える
setopt auto_menu
## 補完候補を一覧表示
setopt auto_list
## 補完候補を詰めて表示
setopt list_packed
## 補完候補一覧でファイルの種別をマーク表示
setopt list_types
## Shift-Tabで補完候補を逆順する
bindkey "^[[Z" reverse-menu-complete

# vcs_info
autoload -Uz vcs_info
## branchの表示
zstyle ':vcs_info:*' formats '(%b)'
precmd() { vcs_info }

# color
## プロンプトの色の設定
autoload -U colors; colors
PROMPT='
%{${fg[green]}%}%n@%m%{${reset_color}%}: %{${fg[yellow]}%}%~%{${reset_color}%} %{${fg[red]}%}${vcs_info_msg_0_}%{${reset_color}%}
$ '
## 補完候補の色づけ
export LSCOLORS=gxfxcxdxbxegedabagacag
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
## 補完候補のハイライト
zstyle ':completion:*:default' menu select=2

# zplug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "zsh-users/zsh-completions"
fpath=(/usr/local/opt/zplug/repos/zsh-users/zsh-completions $fpath)
zplug "plugins/git", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
## 未インストール項目をインストールする
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
       echo; zplug install
  fi
fi
## コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load --verbose

# global alias
alias -g L='| less'
alias -g G='| grep'

# alias
alias ls='ls -FG'
alias ll='ls -l'
alias grep='grep --color'
alias diff='colordiff -u'

# zsh-bd
. $HOME/.zsh/plugins/bd/bd.zsh


function peco-z-search
{
  which peco z > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install peco and z"
    return 1
  fi
  local res=$(z | sort -rn | cut -c 12- | peco)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N peco-z-search
bindkey '^f' peco-z-search

source ~/.zsh.d/z.sh
