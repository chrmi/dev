alias python='python3'
alias py='python3'

alias gp='grep -rn --color=auto'
alias gpi='grep -rni --color=auto'

alias tarfolder='tar -zcvf'
alias untarfolder='tar -zxvf'

alias dockerrm='docker rm $(docker ps -aq)'
alias dockerrmi='docker rmi $(docker images -q)'

export GOPATH=$HOME/go
export PATH=$HOME/bin:$HOME/.cargo/bin:$GOPATH/bin:$PATH
