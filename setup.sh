#!/bin/zsh

# Source helper functions
source "$(dirname "$0")/helpers.sh"
source "$(dirname "$0")/colors.sh"


#######################
# Pre-requisites
#######################

function ensure_permission() {
    echo "${BLUE}Ensuring execution permission on $1${NOCOLOR} ✅"
    chmod +x "$1"
}

function ensure_xcode_tools() {
    if xcode-select -p &>/dev/null; then
        echo "${GREEN}Xcode command line tools already installed${NOCOLOR} ✅"
    else
        echo "${BLUE}Installing commandline tools...${NOCOLOR} ⌛"
        xcode-select --install
    fi
}

function ensure_homebrew() {
    if command -v brew &>/dev/null; then
        echo -e "${GREEN}Brew is already installed${NOCOLOR} ✅"
    else
        echo "Downloading the brew package manager"

        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Check if installation was successful
        if command -v brew &>/dev/null; then
            echo "Homebrew installed successfully!"
        else
            echo "Failed to install Homebrew. Please install manually."
            exit 1
        fi
    fi
}

ensure_permission "setup.sh"

ensure_xcode_tools

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

#######################
# Zsh   Plugins
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

echo "${BLUE}Installing Zsh plugins${NOCOLOR}"

ensure_ohmyzsh_plugin "zsh-autosuggestions"
ensure_ohmyzsh_plugin "zsh-syntax-highlighting"

#######################
# Default brew packages
#######################

# Install formulas
echo "${BLUE}Installing brew packages${NOCOLOR}⏳"
brew bundle --file=Brewfile --force
echo "${GREEN}Installed brew packages successfully${NOCOLOR} ✅"

if [[ -z "$CI" ]]; then
    echo "${BLUE}Installing brew casks${NOCOLOR}⏳"
    # Install casks
    brew bundle --file=Caskfile --force
    echo "${GREEN}Installed brew casks sucessfully${NOCOLOR} ✅"
else
    echo "${YELLOW}Skipping cask installation in CI environment${NOCOLOR}"
fi

#######################
# Github configuration
#######################

function ensure_gh_auth() {
    if [[ -n "$CI" ]]; then
        echo "${YELLOW}Skipping gh auth in CI environment${NOCOLOR}"
        return 0
    fi
    if gh auth status &>/dev/null; then
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

#######################
# Lazy Vim
#######################

function ensure_lazy_vim() {
    if [ -d "$HOME/.config/nvim" ]; then
        echo "${GREEN}Lazy vim is already installed${NOCOLOR} ✅"
    else
        echo "${BLUE}Installing LazyVim${NOCOLOR} ⏳"

        git clone https://github.com/LazyVim/starter $HOME/.config/nvim
        rm -rf $HOME/.config/nvim/.git

        echo "${GREEN}LazyVim installed successfully${NOCOLOR} ✅"
    fi
}

ensure_lazy_vim

function copy_user_files_with_merge() {
    local source_dir="user_files"
    local target_dir="$HOME"

    # Files that need smart merging
    local claude_json=".claude.json"
    local claude_settings=".claude/settings.json"

    # Merge Claude configuration files
    echo "${BLUE}Merging Claude configuration files${NOCOLOR}"
    deep_merge_json "$source_dir/$claude_json" "$target_dir/$claude_json"
    deep_merge_json "$source_dir/$claude_settings" "$target_dir/$claude_settings"

    # Copy remaining files with rsync, excluding the JSON files we already merged
    echo "${BLUE}Copying remaining user files${NOCOLOR}"
    rsync -av --exclude="$claude_json" --exclude="$claude_settings" "$source_dir/" "$target_dir/"

    echo "${GREEN}User files copied with smart merge${NOCOLOR} ✅"
}

# copy user files
echo "${BLUE}Copying user files${NOCOLOR}"

copy_user_files_with_merge

#######################
# macOS Configuration
#######################

