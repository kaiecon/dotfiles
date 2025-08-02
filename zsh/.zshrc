# # 環境変数は.profileに移動済み
# インタラクティブシェル専用の設定のみを残す
export SYSTEM_EDITOR=vim
export DISABLE_AUTOUPDATER=1

[ -z "$ld_library_path" ] && typeset -xT LD_LIBRARY_PATH ld_library_path
[ -z "$cplus_include_path" ] && typeset -xT CPLUS_INCLUDE_PATH cplus_include_path
typeset -U path ld_library_path cplus_include_path

path=(
  ${HOME}/.local/bin(N-/)
  ${HOME}/.yarn/bin(N-/)
  ${HOME}/go/bin(N-/)
  ${HOME}/.cargo/bin(N-/)
  ${ANDROID_HOME}/cmdline-tools/latest/bin(N-/)
  ${ANDROID_HOME}/platform-tools(N-/)
  ${ANDROID_HOME}/emulator(N-/)
  $path
)
# path+=(~/.jdks/openjdk-17.0.2/bin)

# 色を使用出来るようにする
autoload -Uz colors
colors

# Ctrl-x-e to edit command line
autoload -Uz edit-command-line

# emacs 風キーバインドにする
bindkey -e

# deleteでチルダが出る現象の対策
bindkey '[3~' delete-char

# ヒストリの設定
HISTFILE=$XDG_DATA_HOME/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
#for zsh-completios
fpath=(/usr/local/share/zsh-completions $fpath)
fpath+=(~/.config/zsh/completion)
autoload -Uz compinit
compinit -u

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

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

# '#' 以降をコメントとして扱う
setopt interactive_comments

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

# コマンドのスペルミス訂正
setopt correct

# 移動したディレクトリを記録して "cd -[Tab]" で履歴一覧
# setopt auto_pushd

########################################
# キーバインド

# fzf(sk) history
function fzf-select-history() {
    BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER" --reverse)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

########################################
# エイリアス

alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

alias vi='vim'
alias nv='nvim'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif command -v xclip >/dev/null 2>&1 ; then
    # Linux (xclip)
    alias -g C='| xclip -selection clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi

########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        # PATHは.profileで管理
        alias ls='ls -G -F'
        ;;
      linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        # zplug
        eval `dircolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark`
        umask 022
        unsetopt BG_NICE
        ;;
esac

#######################################
#zplug
source ~/.zplug/init.zsh

if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

zplug "zplug/zplug"
zplug "zsh-users/zsh-autosuggestions"
zplug "seebi/dircolors-solarized"
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "b4b4r07/enhancd", use:init.sh

# 未インストール項目をインストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load --verbose

#######################################
autoload -Uz zmv

# for k8s
[[ /usr/bin/kubectl ]] && source <(kubectl completion zsh)
[[ /usr/bin/kubeadm ]] && source <(kubeadm completion zsh)
[[ /usr/bin/helm  ]] && source <(helm completion zsh)
[[ /usr/bin/minikube ]] && source <(minikube completion zsh)

### awscli
source /usr/bin/aws_zsh_completer.sh

# PATH設定は.profileに移動済み

# nvm
source /usr/share/nvm/init-nvm.sh
