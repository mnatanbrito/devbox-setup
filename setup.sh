#######################
# Pre-requisites
#######################

echo "Downloading brew package manager"
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#######################
# Default brew packages
#######################

echo "Copying default files to user folder"
cp Brewfile ~/Brewfile
cp .zprofile ~/.zprofile
cp .zshrc ~/.zshrc

# creates ~/.config if it does not exist
mkdir -p ~/.config
cp -r .config/* ~/.config/

# Loading brew into the shell
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install packages in brew file
brew bundle install 

echo "Installing Oh My Zsh"
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# configure github cli
# gh auth login --git-protocol ssh

# configure git user info
git config --global user.name "mnatanbrito"
git config --global user.email "mnatan.brito@gmail.com"
