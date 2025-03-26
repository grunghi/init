# Initialization Script

This script sets up a command line environment with Zsh, Oh My Zsh, Powerlevel10k theme, fnm (Fast Node Manager), and Node.js. It also installs some useful plugins and tools.

## Prerequisites

- The script must be run as root.
- The system should have one of the following package managers: `apt-get`, `dnf`, or `yum`.

## Usage

   ```bash
   sudo wget -qO- https://raw.githubusercontent.com/grunghi/init/main/init.sh | bash
   ```

## What the Script Does

1. **Checks for Root Privileges**: Ensures the script is run as root.
2. **Installs Required Packages**: Installs `zsh`, `curl`, and `git` using the available package manager.
3. **Installs Oh My Zsh**: Sets up Oh My Zsh for the current user.
4. **Installs Powerlevel10k Theme**: Clones the Powerlevel10k theme into the Oh My Zsh custom themes directory.
5. **Installs fnm**: Installs Fast Node Manager.
6. **Creates Custom `.zshrc`**: Generates a custom `.zshrc` file with predefined settings and aliases.
7. **Changes Default Shell to Zsh**: Changes the default shell to Zsh for the actual user.
8. **Installs Node.js**: Installs the latest LTS version of Node.js using fnm.
9. **Enables Corepack**: Enables Corepack for managing Node.js package managers.
10. **Installs @antfu/ni**: Installs the `@antfu/ni` package globally.

## Post-Installation Instructions

After the script completes, follow these steps:

1. Log out and log back in to start using Zsh.
2. Run `p10k configure` to set up the Powerlevel10k theme.
3. Verify the Node.js installation with `node --version`.
4. Verify the `ni` installation with `ni --version`.

## Custom Aliases and Functions

The script sets up the following aliases and functions in the `.zshrc` file:

- **Aliases**:

  - `d`: `nr dev`
  - `r`: `nr`
  - `b`: `nr build --force`
  - `mg`: `nr migrate`
  - `mgc`: `nr migrate:create`
  - `sd`: `nr seed`

- **Functions**:
  - `mkcd()`: Creates a directory and changes into it.

## License

This project is licensed under the MIT License.
