<h1 align="center">dotfiles</h1>
<p align="center">My dotfiles.</p>

# Notice
If a dotfile has difference between `local` and `global`, then:
- `.xxx` for local configs.
- `.xxx-global` for global configs.

`.gitattributes` is named `.gitattributes-example` to avoid it change info of this repo, rename it back to use.

For *Rust* global config, please rename `cargo-config.toml` to config.toml, and put this file into `~/.cargo` folder.

Otherwise, use it's original name.

# Ghostty

[Ghostty](https://github.com/ghostty-org/ghostty) is a terminal emulator written in Zig, it allows you to do some customize by config.

See my config: [My Ghostty Config](./ghostty/config)

Install Ghostty: [Install](https://ghostty.org/docs/install/binary)

![ghostty](./assets/ghostty.png)

## Use my config

> [!NOTE]
> For Linux, $XDG_CONFIG_HOME is default to $HOME/.config/ghostty/config

Copy the file or content to:

- macOS: `$HOME/Library/Application\ Support/com.mitchellh.ghostty/config`
- Linux: `$XDG_CONFIG_HOME/.config/ghostty/config`

# Oh-my-zsh

Visit my configuration: [.zshrc-oh-my-zsh](https://github.com/Vincent-the-gamer/dotfiles/blob/main/zsh/.zshrc-oh-my-zsh)

> [!NOTE]
> This part of doc is copied from [Oh-my-zsh official repo](https://github.com/ohmyzsh/ohmyzsh)

## Installation

### Prerequisites

- [Zsh](https://www.zsh.org) should be installed (v4.3.9 or more recent is fine but we prefer 5.0.8 and newer). If not pre-installed (run `zsh --version` to confirm), check the following wiki instructions here: [Installing ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- `curl` or `wget` should be installed
- `git` should be installed (recommended v2.4.11 or higher)

### Basic Installation

Oh My Zsh is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl`, `wget` or another similar tool.

| Method    | Command                                                                                           |
| :-------- | :------------------------------------------------------------------------------------------------ |
| **curl**  | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |
| **wget**  | `sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`   |
| **fetch** | `sh -c "$(fetch -o- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |

Alternatively, the installer is also mirrored outside GitHub. Using this URL instead may be required if you're in a country like China or India (for certain ISPs), that blocks `raw.githubusercontent.com`:

| Method    | Command                                                                                           |
| :-------- | :------------------------------------------------------------------------------------------------ |
| **curl**  | `sh -c "$(curl -fsSL https://gitee.com/pocmon/ohmyzsh/raw/master/tools/install.sh)"`                                                 |
| **wget**  | `sh -c "$(wget -O- https://gitee.com/pocmon/ohmyzsh/raw/master/tools/install.sh)"`                                                   |
| **fetch** | `sh -c "$(fetch -o- https://gitee.com/pocmon/ohmyzsh/raw/master/tools/install.sh)"`                                                 |

_Note that any previous `.zshrc` will be renamed to `.zshrc.pre-oh-my-zsh`. After installation, you can move the configuration you want to preserve into the new `.zshrc`._

## Uninstallation

If you want to uninstall `oh-my-zsh`, just run `uninstall_oh_my_zsh` from the command-line. It will remove itself and revert your previous `bash` or `zsh` configuration.

# License
[MIT License | Vincent-the-gamer | @2024-PRESENT](./LICENSE)
