# Neon text glow for kitty

[English](README.md) | 简体中文

一套 kitty 自定义 shader:给终端文字加「荧光 / bloom」效果。

要求 **kitty >= 0.49**(`custom_shaders` 这个选项从 0.49 开始才有)。

```
shaders/
├── README.md              # 英文版
├── README.zh_CN.md        # 本文件
├── neon-text.pipeline     # 管线:5 个 pass,以及所有可调参数
├── neon-blur.slang        # 单方向高斯模糊 + 辉光提取(被复用 4 次)
└── neon-composite.slang   # 合成:原图 + 辉光
```

`kitty.conf` 里唯一需要的一行:

```conf
custom_shaders neon-text cursor-trail-motion-blur
```

`custom_shaders` 是空格分隔的列表,按顺序串联;后面那个是 kitty 自带的
光标拖影,不需要可以删掉。

---

## 一、换电脑需要自己编译吗?

**不需要。** 你只要拷贝 `.slang` / `.pipeline` 这两个源文件和一行配置,
kitty 会在**启动时**自己调用 `slangc`(Slang 编译器)把它们编译成 GLSL /
SPIR-V,结果缓存在本机:

| 系统 | 缓存目录 |
|---|---|
| macOS | `~/Library/Caches/kitty/shaders/` |
| Linux / WSL | `${XDG_CACHE_HOME:-~/.cache}/kitty/shaders/` |

缓存按「源文件内容哈希 + slangc 版本」失效,所以:

- 改 `.slang` / `.pipeline` 会自动重编译,不用手动清缓存;
- **不要把缓存目录拷到别的机器**(里面是给本机 GPU/驱动用的产物),
  只拷源文件即可;
- 效果出问题时可以整个删掉缓存目录,下次启动会重建。

唯一需要你额外动手的情况:**这台机器上的 kitty 找不到 `slangc`**。
kitty 查找编译器的顺序是(0.49 的实现):

1. 安装目录里自带的 `slangc`;
2. 源码开发树下的 `bin/slangc`;
3. 环境变量 `SLANGC`(可以是带参数的命令行),否则就是 PATH 里的 `slangc`。

官方安装包通常自带(见下),发行版打包或自己编译的则取决于打包者。
一条命令就能确认:

```sh
kitty +runpy "import shutil, kitty.shaders.slang as s; c = s.slangc(); print(c, '->', shutil.which(c[0]))"
```

输出里能看到解析到的路径就说明没问题;`None` 就是没找到。

---

## 二、各平台方案

### macOS

- 官方 `.dmg` / 安装脚本(装到 `/Applications/kitty.app`)**自带编译器**,
  路径就是 `/Applications/kitty.app/Contents/MacOS/slangc`,开箱即用。
- 如果 `which kitty` 找不到,注意不要把 kitty 二进制从 `.app` 里拷出来,
  而是建软链接——脱离 `.app` 就找不到同目录的 `slangc` 了:

  ```sh
  ln -sf /Applications/kitty.app/Contents/MacOS/kitty  ~/bin/kitty
  ln -sf /Applications/kitty.app/Contents/MacOS/kitten ~/bin/kitten
  ```

- 配置目录:`~/.config/kitty/`。把本文件所在目录放到
  `~/.config/kitty/shaders/`,在同一层的 `kitty.conf` 加那一行即可。

### Linux

- 官方安装脚本(装到 `~/.local/kitty.app`)的包里**通常会**带上,路径形如
  `~/.local/kitty.app/bin/slangc`;发行版包(`apt` / `pacman` / `dnf` 等)
  则完全看打包者,不保证。以上面那条检查命令的结果为准。若返回 `None`,二选一:
  1. 装发行版的 `shader-slang` 包(有的话);
  2. 从 <https://github.com/shader-slang/slang/releases> 下载预编译包,
     解压后指定环境变量(写进 shell rc 或 kitty 的 `env`):

     ```sh
     export SLANGC="$HOME/opt/slang/bin/slangc"
     ```

  `SLANGC` 也接受带参数的命令,例如 `SLANGC="slangc --some-flag"`。
- 配置目录:`${XDG_CONFIG_HOME:-~/.config}/kitty/`。

### Windows

- **kitty 没有原生 Windows 版本**(官方只提供 macOS 和 Linux 安装包)。
- 可行方案:WSL2 + WSLg,在 WSL 里装 Linux 版 kitty,按 Linux 的方式处理,
  配置文件放在 **WSL 内部**的 `~/.config/kitty/`(不要在 `/mnt/c` 上,
  跨文件系统的权限和换行符会带来麻烦)。
- 如果你用的是 Windows 原生终端(Windows Terminal / WezTerm / Alacritty 等),
  它们的 shader/自定义渲染方案与 kitty 完全不兼容,本目录的文件不能直接用。

---

## 三、移植清单

1. 确认 `kitty --version` >= 0.49;
2. 把整个 `shaders/` 目录拷到目标机器的 kitty 配置目录下;
3. 在 `kitty.conf` 里加:
   ```conf
   custom_shaders neon-text cursor-trail-motion-blur
   ```
   (没有启用光标拖影的话只写 `custom_shaders neon-text`);
4. 完全退出 kitty 再打开(改完 shader 后 `ctrl+shift+f5` 重载配置通常也能生效,
   但首次启用建议重启);
5. 如果画面没有变化,先跑第一节那条 `kitty +runpy ...` 确认 `slangc` 是否找到。

---

## 四、调参

所有参数都在 `neon-text.pipeline` 里,改完重载配置即可,不需要碰 `.slang`。

| 参数 | 默认 | 作用 |
|---|---|---|
| `GLOW_INTENSITY` | `0.8` | 辉光总强度:`0.3` 含蓄、`0.8` 明显、`2.0` 很炸 |
| `TEXT_BOOST` | `0.1` | 文字本体额外提亮,`0` 关闭 |
| `STRIDE`(两组) | `1.5` / `4.0` | 模糊半径,**单位是设备像素** |
| `GLOW_ROLLOFF` | `1.0` | 软限幅,防止密集文字把整屏抬亮 |
| `GLOW_THRESHOLD` | `0.12` | 多亮才开始发光(在 `.slang` 里) |
| `EXCLUDE_CHROME` | `false` | 设 `true` 时 tab bar 等窗口装饰不发光 |

三档预设(写在 pipeline 头部注释里):

```conf
# subtle   0.4 / STRIDE 1.5, 3.0
# neon     0.8 / STRIDE 1.5, 4.0   ← 默认
# extreme  1.5 / STRIDE 2.0, 7.0
```

`GLOW_THRESHOLD` 同时出现在 `neon-blur.slang` 和 `neon-composite.slang`,
改的时候两边要一起改,否则「发光」和「提亮」的范围会不一致。

### 原理速记

1. 第一个 pass 把画面里「比背景亮的部分」抽出来(保留色相);
2. 横向 + 纵向各模糊两次(紧一圈、宽一圈,可分离高斯,7 taps);
3. 最后一个 pass 把模糊结果加回原图,并做一次保色相的软限幅。

中间结果放在命名纹理 `a` / `b` 里,写回时是 alpha=1,避免被预乘缩放。
整个效果的 group 都标了 `animation_step 0`,只在画面内容变化时重绘,
不做无谓的定时重绘。

---

## 五、已知限制

- **只适合深色主题**。辉光是用「像素 - 背景色」判定的,浅色主题下几乎每个像素
  都比背景「亮」,会导致整屏发白。真要在浅色主题上用,需要改成局部对比度
  (高通)版本。
- 无法区分「文字」和「一大块彩色图形」,所以 fastfetch 那种整块 ASCII logo
  一定会有明显光晕;想收敛就降 `STRIDE` / `GLOW_INTENSITY`,或提高
  `GLOW_THRESHOLD` 只让高亮 token 发光。
- `background_opacity < 1` 时辉光会按 alpha 一起变淡(这是有意为之,
  背景透明时不该出现实心光晕)。
- Retina 屏 1 个逻辑点 = 2 个设备像素,所以 `STRIDE` 在 macOS 上看起来
  只有一半大;两平台想视觉一致,Retina 上的值要乘 2。
- 全屏 4 次 7 taps 采样,滚动时有一定 GPU 开销;觉得卡就砍掉第三个/第四个
  group(宽的模糊),只用紧的一圈。
