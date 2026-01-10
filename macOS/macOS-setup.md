# macOS Setup

> [!IMPORTANT]
> on `macOS`, user folder is /Users/{username}
> on `Linux`, user folder is /home/{username}

## Homebrew

Although Homebrew is compatible with `Linux`, it has no reason to use it since `Linux` has apt, pacman, etc.

### Install Homebrew:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# For Chinese Users
/bin/bash -c "$(curl -fsSL https://static.vince-g.xyz/brew/install-homebrew.sh)"
```

### For Chinese Users

#### Change `brew` sources

```shell
git -C "$(brew --repo)" remote set-url origin https://mirrors.ustc.edu.cn/brew.git
git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
```

#### Change `bintray` sources

```shell
# bash/zsh
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles

# fish: add this to config.fish
set -gx HOMEBREW_BOTTLE_DOMAIN https://mirrors.ustc.edu.cn/homebrew-bottles
```

## Git

Install Git from Homebrew can keep your git up-to-date.

```shell
brew install git
```

## Telnet

```shell
brew install telnet
```
