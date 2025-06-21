### macOS zsh终端 环境变量 ###

# Homebrew环境变量
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
eval $(/opt/homebrew/bin/brew shellenv)

## Python环境变量可以在安装时自动写入 ##
# Python 3.12环境变量
# Setting PATH for Python 3.12
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
export PATH

# Poetry环境变量
export PATH="/Users/{username}/.local/bin:$PATH"

# Rustup工具链换源(用于安装/更新Rust)
# 中国科学技术大学源
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# Flutter环境变量
export PATH=$HOME/flutter/bin:$PATH

# Flutter换源
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
