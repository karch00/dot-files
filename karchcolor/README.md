# themer - My Color Set

## Vim

Copy or symlink `Vim/ThemerMyColorSet.vim` to `~/.vim/colors/`.

Then set the colorscheme in `.vimrc`:

```
" The background option must be set before running this command.
colorscheme ThemerMyColorSet
```

## Visual Studio

1. Select Tools > Import and Export Settings...
2. Choose the "Import selected environment settings" option
3. Choose whether or not to save a backup of current settings
4. Click "Browse..." and choose the generated theme file ('Visual Studio/themer-my-color-set-dark.vssettings')
5. Click "Finish"

## Kitty

In the kitty configuration file (usually `~/.config/kitty/kitty.conf`), `include` the generated theme file:

* `Kitty/themer-my-color-set-dark.conf`

## Brave

1. Launch Brave and go to `brave://extensions`.
2. Check the "Developer mode" checkbox at the top.
3. Click the "Load unpacked extension..." button and choose the desired theme directory (`Brave/Themer My Color Set Dark`).

(To reset or remove the theme, visit `brave://settings` and click "Reset to Default" in the "Appearance" section.)

## CSS

Import the generated theme file into your stylesheet via `@import()`, or into your HTML markup via `<link>`.

`hex.css` provides the theme colors in hex format; `rgb.css` and `hsl.css` in RGB and HSL formats respectively along with individual channel values for further manipulation if desired.

Generated files:

* `CSS/Themer My Color Set - hex.css`
* `CSS/Themer My Color Set - rgb.css`
* `CSS/Themer My Color Set - hsl.css`