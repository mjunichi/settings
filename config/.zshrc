## pathを設定
path=(~/bin(N-/) /usr/local/bin(N-/) ${path})

export PATH="$HOME/.pyenv/shims:$PATH"

# eval "$(starship init zsh)"

function google() {
	local str opt
	if [ $# != 0 ]; then
		for i in $*; do
			str="$str+$i"
		done
		str=`echo $str | sed 's/^\+//'`
		opt='search?num=50&hl=ja&lr=lang_ja'
		opt="${opt}&q=${str}"
	fi
	w3m http://www.google.co.jp/$opt
}

function imginfo() {
    imgcat $1 && sips --getProperty pixelHeight --getProperty pixelWidth $1;
}

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

# ここはプロンプトの設定なので今回の設定とは関係ありません
if [ $UID -eq 0 ];then
# ルートユーザーの場合
PROMPT="%F{red}%n:%f%F{green}%d%f [%m] %%
"
else
# ルートユーザー以外の場合
PROMPT="%F{cyan}%n:%f%F{green}%d%f [%m] %%
"
fi

# zplug
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# 非同期処理できるようになる
zplug "mafredri/zsh-async"
# テーマ(ここは好みで。調べた感じpureが人気)
zplug "sindresorhus/pure"
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# コマンド入力途中で上下キー押したときの過去履歴がいい感じに出るようになる
zplug "zsh-users/zsh-history-substring-search"
# 過去に入力したコマンドの履歴が灰色のサジェストで出る
zplug "zsh-users/zsh-autosuggestions"
# 補完強化
zplug "zsh-users/zsh-completions"
# 256色表示にする
zplug "chrissicool/zsh-256color"
# コマンドライン上の文字リテラルの絵文字を emoji 化する
zplug "mrowa44/emojify", as:command

zplug "b4b4r07/enhancd", use:"init.sh"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
zplug load


# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# global alias
alias -g L='| less'
alias -g G='| grep'

# alias
alias ls='ls -FG'
alias ll='ls -l'
alias la='ls -al'
alias grep='grep --color'
alias diff='colordiff -u'
alias ql='qlmanage -p "$@" >& /dev/null'
