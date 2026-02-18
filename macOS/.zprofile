### macOS zsh终端 环境变量 ###

# Homebrew 环境变量
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
eval $(/opt/homebrew/bin/brew shellenv)

# Python 3.14 环境变量
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.14/bin:${PATH}"
export PATH

# .local环境变量
export PATH="/Users/aya/.local/bin:$PATH"

# Rustup工具链换源(用于安装/更新Rust)
export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup

# Android环境变量
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export NDK_HOME=$ANDROID_HOME/ndk/29.0.13113456

# ffmpeg环境变量
export PATH="$HOME/ffmpeg:$PATH"
