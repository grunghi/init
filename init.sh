#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*] $1${NC}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[!] $1${NC}"
}

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root"
    exit 1
fi

# Get the username of the actual user (not root)
ACTUAL_USER=$(logname)
USER_HOME="/home/$ACTUAL_USER"

# Install required packages
print_status "Installing required packages..."
if command -v apt-get >/dev/null; then
    apt-get update
    apt-get install -y zsh curl git
elif command -v dnf >/dev/null; then
    dnf install -y zsh curl git
elif command -v yum >/dev/null; then
    yum install -y zsh curl git
else
    print_error "Unsupported package manager"
    exit 1
fi

# Install Oh My Zsh
print_status "Installing Oh My Zsh..."
su - $ACTUAL_USER -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

# Install Powerlevel10k theme
print_status "Installing Powerlevel10k theme..."
su - $ACTUAL_USER -c "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${USER_HOME}/.oh-my-zsh/custom/themes/powerlevel10k"

# Install fnm
print_status "Installing fnm..."
su - $ACTUAL_USER -c "curl -fsSL https://fnm.vercel.app/install | bash"

# Create custom .zshrc
print_status "Creating custom .zshrc..."
cat > "${USER_HOME}/.zshrc" << 'EOL'
# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    docker
    docker-compose
    kubectl
    history
    sudo
    z
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias d="nr dev"
alias r="nr"
alias b="nr build --force"
alias mg="nr migrate"
alias mgc="nr migrate:create"
alias sd="nr seed"

# Custom functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOL

# Set correct ownership
chown $ACTUAL_USER:$ACTUAL_USER "${USER_HOME}/.zshrc"

# Create a temporary script to initialize fnm and install Node.js
cat > "${USER_HOME}/init_node.sh" << 'EOL'
#!/bin/zsh
source ~/.zshrc
fnm install --lts
fnm use lts-latest
corepack enable
npm install -g @antfu/ni
EOL

# Make the init script executable and set ownership
chmod +x "${USER_HOME}/init_node.sh"
chown $ACTUAL_USER:$ACTUAL_USER "${USER_HOME}/init_node.sh"

# Change default shell to zsh for the user
print_status "Changing default shell to zsh..."
chsh -s $(which zsh) $ACTUAL_USER

# Run the initialization script as the actual user
print_status "Installing Node.js and related tools..."
su - $ACTUAL_USER -c "${USER_HOME}/init_node.sh"

# Clean up the temporary script
rm "${USER_HOME}/init_node.sh"

# Final instructions
print_status "Installation complete!"
print_status "Please log out and log back in to start using zsh"
print_status "After logging back in:"
print_status "1. Run 'p10k configure' to set up the Powerlevel10k theme"
print_status "2. Verify Node.js installation with 'node --version'"
print_status "3. Verify ni installation with 'ni --version'"