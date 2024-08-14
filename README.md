<h1 align="center">dotfiles</h1>
<p align="center">My dotfiles.</p>

# Notice
If a dotfile has difference between `local` and `global`, then:
- `.xxx` for local configs.
- `.xxx-global` for global configs.

`.gitattributes` is named `.gitattributes-example` to avoid it change info of this repo, rename it back to use.

Otherwise, use it's original name.

# Oh-my-zsh

Visit my configuration: [https://github.com/Vincent-the-gamer/dotfiles/blob/main/zsh/.zshrc-oh-my-zsh](.zshrc-oh-my-zsh)

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
| **fetch** | `sh -c "$(fetch -o - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |

Alternatively, the installer is also mirrored outside GitHub. Using this URL instead may be required if you're in a country like China or India (for certain ISPs), that blocks `raw.githubusercontent.com`:

| Method    | Command                                                                                           |
| :-------- | :------------------------------------------------------------------------------------------------ |
| **curl**  | `sh -c "$(curl -fsSL https://install.ohmyz.sh/)"`                                                 |
| **wget**  | `sh -c "$(wget -O- https://install.ohmyz.sh/)"`                                                   |
| **fetch** | `sh -c "$(fetch -o - https://install.ohmyz.sh/)"`                                                 |

_Note that any previous `.zshrc` will be renamed to `.zshrc.pre-oh-my-zsh`. After installation, you can move the configuration you want to preserve into the new `.zshrc`._

## Uninstallation

If you want to uninstall `oh-my-zsh`, just run `uninstall_oh_my_zsh` from the command-line. It will remove itself and revert your previous `bash` or `zsh` configuration.

# License
[MIT License | Vincent-the-gamer | @2024-PRESENT](./LICENSE)
