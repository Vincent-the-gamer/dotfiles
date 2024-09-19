### macOS zsh终端 环境变量 ###

# Homebrew环境变量
export HOMEBREW_PIP_INDEX_URL=http://mirrors.aliyun.com/pypi/simple #ckbrew
export HOMEBREW_API_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles/api  #ckbrew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles #ckbrew
eval $(/opt/homebrew/bin/brew shellenv) #ckbrew

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
RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup