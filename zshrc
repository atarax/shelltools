# Path to your oh-my-zsh installation.S
export ZSH=${HOME}/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"
# ZSH_THEME="bureau"
#ZSH_THEME="tk-custom"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

export PATH="${HOME}/sonar/bin:$PATH"

source $ZSH/oh-my-zsh.sh

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

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

########################
# ZShell configuration #
########################

zstyle ':completion:*' special-dirs true

##########
# Docker #
##########

alias dssh="cd ~/plista/platforms-control && make shell"
alias dimessh="~/plista/platforms-control/tasks/ssh_dime1"
alias dc="docker-compose"

##################
# Plista-Release #
##################

doReleaseCommitWithAutoMessage() {
  git commit -am "$(dpkg-parsechangelog --show-field Source) ($(dpkg-parsechangelog --show-field Version))"
}

minorRelease() {
  echo "Please enter reason for release:"
  read message
  dch -D stable -u low -i --no-auto-nmu $message
  doReleaseCommitWithAutoMessage
  git push
}

genericRelease() {
  fromBranch=$1
  toBranch=$2
  echo "checking out $toBranch..."
  git checkout $toBranch
  echo "pulling changes..."
  git pull origin $toBranch -X theirs
  echo "checking out $fromBranch..."
  git checkout $fromBranch
  echo "pulling changes..."
  git pull origin $fromBranch -X theirs
  echo "merging $toBranch into $fromBranch to avoid merge-conflicts..."
  git merge $toBranch
  echo "checking out $toBranch again..."
  git checkout $toBranch
  echo "merging $fromBranch..."
  git merge $fromBanch
  
  if [ "$toBranch" = "master" ]
  then
    echo "append to changelog..."
    dch -D stable -u low --no-auto-nmu -v $(head debian/changelog -n 1 |  grep "(\d+)\.(\d+)" -Po | cut -d . -f 1).$(($(head debian/changelog -n 1 |  grep "\.(\d+)\." -Po | cut -d . -f 2)+1)).0 General Release
    echo "making the release-commit..."
    doReleaseCommitWithAutoMessage
  fi

  echo "pushing to repo..."
  git push
  echo "pushing $fromBranch to transfer the changes from master (cherrys and changelogs...)"
  git checkout $fromBranch
  git push
  git checkout $toBranch
  echo "done :) your version is:"
  echo $(head debian/changelog -n 1)
}

export EDITOR="vim"
export DEBFULLNAME="Tobias Kaesser"
export DEBEMAIL="tk@plista.com"
alias prmaj="genericRelease master"
alias prmin="minorRelease"
alias prbeta="genericRelease next beta-production"
alias prcheckMaj="git checkout next && git pull && git diff origin/master"
alias prcheckBeta="git checkout next && git pull && git diff origin/beta-production"


#########
# Hosts #
#########

alias pssh=sshToPlistaHost

sshToPlistaHost() {
 ssh plista$1.plista.com
}

##########
# Docker #
##########

alias dbr=dockerBuildRun

dockerBuildRun() {
  docker build . -t $1
  docker run -t $1 $2
}

#####
# z #
#####

if [ -e /usr/local/bin/z.sh ]
then
  source /usr/local/bin/z.sh
fi

alias ts="typespeed"

###############
# pretty json #
###############

alias json='python -m json.tool'

######################
# ec2-gitlab-runnter #
######################

EC2_HOST='10.11.31.223'
alias sse="ssh -i ${HOME}/tk/.ssh/ec2-gitlab.key ec2-user@$EC2_HOST"

#######
# k8l #
#######

function switchK8LNamespace() {
  kubectl config set-context $(kubectl config current-context) --namespace=$1  
}

if command -v kubectl
then 
 
  alias kl="kubectl"
  alias kle="kubectl exec -it"

  alias klgp="kubectl get pods"
  alias klgpan="kubectl get pods --all-namespaces"

  alias klgs="kubectl get service"
  alias klgsan="kubectl get service --all-namespaces"
  alias kles="kubectl edit service"
  alias klds="kubectl describe service"
  alias kldels="kubectl delete service"

  alias klgd="kubectl get deployment"
  alias klgdan="kubectl get deployment --all-namespaces"
  alias kled="kubectl edit deployment"
  alias kldd="kubectl describe deployment"
  alias kldeld="kubectl delete deployment"

  alias klgi="kubectl get ingress"
  alias klgian="kubectl get ingress --all-namespaces"
  alias klei="kubectl edit ingress"
  alias kldi="kubectl describe ingress"
  alias kldeli="kubectl delete ingress"

  alias kla="kubectl apply"
  alias klaf="kubectl apply -f"
  alias kldelf="kubectl delete -f"
  alias kld="kubectl describe"
  alias kldel="kubectl delete"
  alias klg="kubectl get"

  alias kldp="kubectl describe pod"

  alias klgr="kubectl get routerule"
  alias klgran="kubectl get routerule --all-namespaces"
  alias kler="kubectl edit routerule"
  alias kldr="kubectl delete routerule"

  alias kll="kubectl logs"

# get current namespace
  alias klgn="kubectl config view --minify | grep namespace"

  alias klla="kubectl get deployment,svc,pods,pvc"

  source <(kubectl completion zsh);
fi

alias kln=switchK8LNamespace

#########
#  Helm #
#########

if command -v helm
then
  source <(helm completion zsh)
fi

######
# Go #
######

if command -v go;
then
  export GOPATH=$HOME
  export PATH=$PATH:/usr/local/go/bin/
  export PATH=$PATH:$(go env GOPATH)/bin
fi
