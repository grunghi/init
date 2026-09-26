# init (archived)

Superseded. New-machine setup now lives in a private chezmoi-managed dotfiles
repo, which installs everything this script did (zsh, oh-my-zsh,
Powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting) and replaces its
fnm + Node + `@antfu/ni` step with [nub](https://nubjs.com).

`init.sh` is kept unchanged below for reference. It still works, but its
generated `.zshrc` is out of date.

<details>
<summary>Original usage</summary>

```bash
wget -qO- https://raw.githubusercontent.com/grunghi/init/main/init.sh | sudo bash
```

Installs zsh, curl, git and micro; Oh My Zsh with Powerlevel10k,
zsh-autosuggestions and zsh-syntax-highlighting; fnm with the latest Node LTS,
Corepack and `@antfu/ni`; writes a `.zshrc`; and sets zsh as the login shell.
Run as root.

</details>

## License

MIT
