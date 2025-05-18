#######################
# Pre-requisites
#######################

echo "Downloading brew package manager"
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#######################
# Default brew packages
#######################

echo "Copying default files to user folder"
cp .zprofile ~/.zprofile
cp .zshrc ~/.zshrc
cp Brewfile ~/Brewfile

# creates ~/.config if it does not exist
mkdir -p ~/.config
cp -r .config/* ~/.config/

# Loading brew into the shell
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install packages in brew file
brew bundle install --verbose --force 

echo "Installing Oh My Zsh"
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing Zsh plugins"
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# configure github cli
# gh auth login --git-protocol ssh

# configure git user info
git config --global user.name "mnatanbrito"
git config --global user.email "mnatan.brito@gmail.com"

# install app store software
# mas install 905953485
# mas install 1486322860

# install mise globally
mise install && mise activate
