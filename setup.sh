#!/bin/zsh


#######################
# Colors 
#######################
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'


#######################
# Pre-requisites
#######################

function ensure_homebrew() {
    if command -v brew &> /dev/null; then
        echo -e "${GREEN}Brew is already installed${NOCOLOR} ✅"
    else
	echo "Downloading the brew package manager"
	
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	
	# Check if installation was successful
        if command -v brew &> /dev/null; then
            echo "Homebrew installed successfully!"
        else
            echo "Failed to install Homebrew. Please install manually."
            exit 1
        fi
    fi
}

# making sure brew is available
ensure_homebrew

# Loading brew into the shell
eval "$(/opt/homebrew/bin/brew shellenv)"


#######################
# User files 
#######################

echo "${BLUE}Copying default files to user folder${NOCOLOR}"

cp .zprofile $HOME/.zprofile
cp .zshrc $HOME/.zshrc
cp Brewfile $HOME/Brewfile

function ensure_config_dir() {
    if [ -d "$HOME/.config" ]; then
        echo "${GREEN}Config directory already created ${NOCOLOR}✅"
    else
	echo "${DARKGRAY}Creating config directory${NOCOLOR} 📁"
        mkdir -m "$HOME/.config"
        echo "${GREEN}Config directory created ${NOCOLOR}✅"
    fi
}

# creates ~/.config if it does not exist
ensure_config_dir
cp -r .config/* ~/.config/

#######################
# Zsh + Plugins
#######################

function ensure_ohmyzsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh is already installed"
    else
        echo "Installing Oh My Zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	if [ -d "$HOME/.oh-my-zsh" ]; then
	    echo "Oh My Zsh installed successfully!"
	else
	    echo "Failed installing Oh My Zsh! =("
	    exit 1
	fi
    fi
}

ensure_ohmyzsh

function ensure_ohmyzsh_plugin() {
    if [ -d "$HOME/.oh-my-zsh/custom/plugins/$1" ]; then
        echo "${GREEN}Plugin $1 already installed${NOCOLOR} ✅"
    else
	echo "${BLUE}Installing $1 plugin${NOCOLOR} ⌛"
        git clone https://github.com/zsh-users/$1 ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$1
        if [ -d "$HOME/.oh-my-zsh/custom/plugins/$1" ]; then
	    echo "${GREEN}Plugin $1 installed${NOCOLOR} ✅"
	else
	    echo "${RED}Error installing $1 plugin${NOCOLOR}🚫"
	    exit 1
	fi
    fi  
}

echo "Installing Zsh plugins"

ensure_ohmyzsh_plugin "zsh-autosuggestions"
ensure_ohmyzsh_plugin "zsh-syntax-highlighting"

#######################
# Default brew packages
#######################


# Install packages in brew file
brew bundle install --verbose --force 


#######################
# Github configuration
#######################


function ensure_gh_auth() {
    if gh auth status &> /dev/null; then
        echo "${GREEN}Github CLI is authorized${NOCOLOR} ✅"
    else
	echo "${BLUE} Authorizing Github CLI${NOCOLOR} 🥷"
        gh auth login --git-protocol ssh
    fi
}

ensure_gh_auth

# configure git user info
git config --global user.name "mnatanbrito"
git config --global user.email "mnatan.brito@gmail.com"
