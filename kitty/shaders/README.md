# Neon text glow for kitty

English | [简体中文](README.zh_CN.md)

A kitty custom shader that gives terminal text a fluorescent / bloom effect.

Requires **kitty >= 0.49** (the `custom_shaders` option was added in 0.49).

```
shaders/
├── README.md              # this file (English)
├── README.zh_CN.md        # Chinese translation
├── neon-text.pipeline     # pipeline: 5 passes, plus all the tunable parameters
├── neon-blur.slang        # single-axis Gaussian blur + emission extraction (reused 4 times)
└── neon-composite.slang   # composite: original frame + glow
```

The only line you need in `kitty.conf`:

```conf
custom_shaders neon-text cursor-trail-motion-blur
```

`custom_shaders` is a space-separated list, chained in order; the second entry is
kitty's built-in cursor trail blur, remove it if you don't want it.

---

## 1. Do I have to compile anything on a new machine?

**No.** You only copy the two source files (`.slang` / `.pipeline`) and the one
config line. kitty calls `slangc` (the Slang compiler) itself at **startup** to
compile them into GLSL / SPIR-V, and caches the result locally:

| OS | Cache directory |
|---|---|
| macOS | `~/Library/Caches/kitty/shaders/` |
| Linux / WSL | `${XDG_CACHE_HOME:-~/.cache}/kitty/shaders/` |

The cache is invalidated by "hash of the source file contents + `slangc`
version", so:

- editing `.slang` / `.pipeline` triggers an automatic recompile, no manual
  cache clearing needed;
- **don't copy the cache directory to another machine** (it contains artifacts
  built for this machine's GPU/driver) — copy only the sources;
- if the effect misbehaves, just delete the whole cache directory and it will be
  rebuilt on the next start.

The only case that needs extra work: **kitty on this machine can't find
`slangc`**. The lookup order (as implemented in 0.49) is:

1. the `slangc` bundled in the installation directory;
2. `bin/slangc` in a source development tree;
3. the `SLANGC` environment variable (may be a command line with arguments),
   otherwise `slangc` on `PATH`.

Official installers usually bundle it (see below); distro packages or a
self-compiled kitty depend on the packager. One command tells you:

```sh
kitty +runpy "import shutil, kitty.shaders.slang as s; c = s.slangc(); print(c, '->', shutil.which(c[0]))"
```

If you see a resolved path in the output, you're good; `None` means it wasn't
found.

---

## 2. Per-platform notes

### macOS

- The official `.dmg` / install script (installs to `/Applications/kitty.app`)
  **bundles the compiler** at `/Applications/kitty.app/Contents/MacOS/slangc`,
  so it works out of the box.
- If `which kitty` finds nothing, don't copy the kitty binary out of the `.app` —
  symlink it instead. Once detached from the `.app` it can no longer find the
  `slangc` next to it:

  ```sh
  ln -sf /Applications/kitty.app/Contents/MacOS/kitty  ~/bin/kitty
  ln -sf /Applications/kitty.app/Contents/MacOS/kitten ~/bin/kitten
  ```

- Config directory: `~/.config/kitty/`. Put the directory containing this file
  at `~/.config/kitty/shaders/` and add that line to `kitty.conf` in the same
  directory.

### Linux

- The official install script (installs to `~/.local/kitty.app`) **usually**
  ships it, at something like `~/.local/kitty.app/bin/slangc`. Distro packages
  (`apt` / `pacman` / `dnf`, etc.) depend entirely on the packager and are not
  guaranteed. Trust the check command above. If it returns `None`, pick one:
  1. install your distro's `shader-slang` package (if it exists);
  2. download a prebuilt package from
     <https://github.com/shader-slang/slang/releases>, unpack it, and point the
     environment variable at it (in your shell rc or kitty's `env`):

     ```sh
     export SLANGC="$HOME/opt/slang/bin/slangc"
     ```

  `SLANGC` also accepts a command with arguments, e.g.
  `SLANGC="slangc --some-flag"`.
- Config directory: `${XDG_CONFIG_HOME:-~/.config}/kitty/`.

### Windows

- **kitty has no native Windows build** (officially only macOS and Linux
  installers are provided).
- Workable option: WSL2 + WSLg, install the Linux kitty inside WSL and follow the
  Linux instructions, keeping the config in **WSL's own**
  `~/.config/kitty/` (not on `/mnt/c` — cross-filesystem permissions and line
  endings cause trouble).
- If you're on a native Windows terminal (Windows Terminal / WezTerm / Alacritty,
  etc.), their shader / custom rendering schemes are entirely incompatible with
  kitty, and the files in this directory won't work as-is.

---

## 3. Porting checklist

1. Confirm `kitty --version` >= 0.49;
2. copy the whole `shaders/` directory into the kitty config directory on the
   target machine;
3. add to `kitty.conf`:
   ```conf
   custom_shaders neon-text cursor-trail-motion-blur
   ```
   (use just `custom_shaders neon-text` if you don't want the cursor trail);
4. fully quit and reopen kitty (after shader edits, `ctrl+shift+f5` to reload the
   config often works too, but for first-time enabling a restart is recommended);
5. if nothing changes, run the `kitty +runpy ...` command from section 1 to check
   whether `slangc` was found.

---

## 4. Tuning

All parameters live in `neon-text.pipeline`; edit and reload the config, no need
to touch the `.slang` files.

| Parameter | Default | Effect |
|---|---|---|
| `GLOW_INTENSITY` | `0.8` | Overall glow strength: `0.3` subtle, `0.8` obvious, `2.0` blown out |
| `TEXT_BOOST` | `0.1` | Extra brightness on the text itself, `0` disables it |
| `STRIDE` (two sets) | `1.5` / `4.0` | Blur radius, **in device pixels** |
| `GLOW_ROLLOFF` | `1.0` | Soft limiter, keeps dense text from washing out the screen |
| `GLOW_THRESHOLD` | `0.12` | How bright a pixel must be before it glows (in the `.slang` files) |
| `EXCLUDE_CHROME` | `false` | Set to `true` so window chrome such as the tab bar doesn't glow |

Three presets (documented in the header comment of the pipeline):

```conf
# subtle   0.4 / STRIDE 1.5, 3.0
# neon     0.8 / STRIDE 1.5, 4.0   <- default
# extreme  1.5 / STRIDE 2.0, 7.0
```

`GLOW_THRESHOLD` appears in both `neon-blur.slang` and `neon-composite.slang`;
change both together, otherwise the "glowing" and "boosted" ranges won't match.

### How it works, briefly

1. The first pass extracts the parts of the frame that are "brighter than the
   background" (preserving hue);
2. horizontal + vertical blur, twice each (one tight, one wide; separable
   Gaussian, 7 taps);
3. the last pass adds the blurred result back onto the original frame with a
   hue-preserving soft limiter.

Intermediate results live in the named textures `a` / `b`, written with alpha=1
so premultiplication doesn't scale them. Every group of the effect is marked
`animation_step 0`, so it only redraws when the screen content changes instead of
repainting on a timer for no reason.

---

## 5. Known limitations

- **Dark themes only.** The glow is computed from "pixel - background colour", so
  on a light theme almost every pixel is "brighter" than the background and the
  whole screen turns white. To really use it on a light theme you'd need a local
  contrast (high-pass) version instead.
- It can't tell "text" from "a large coloured graphic", so a solid ASCII logo
  like fastfetch's will definitely have a visible halo. To tame it, lower
  `STRIDE` / `GLOW_INTENSITY`, or raise `GLOW_THRESHOLD` so only bright tokens
  glow.
- With `background_opacity < 1` the glow fades along with the alpha (this is
  intentional — a solid halo would look wrong over a transparent background).
- On a retina screen 1 logical point = 2 device pixels, so `STRIDE` looks half as
  large on macOS; for the same visual result on both platforms, multiply the
  values by 2 on retina.
- Four 7-tap sampling passes over the whole screen have a real GPU cost while
  scrolling; if it feels slow, drop the third/fourth group (the wide blur) and
  keep only the tight ring.
