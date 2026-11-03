# helix-config

My [Helix](https://helix-editor.com) configuration, tuned so that muscle memory
from **VS Code** keeps working. Written and tested against **Helix 25.07.1**.

## Related

| Where | What |
| --- | --- |
| **[vinhnx/helix-config](https://github.com/vinhnx/helix-config)** | this repo: the Helix config |
| **[vinhnx/vitesse-helix](https://github.com/vinhnx/vitesse-helix)** | the Vitesse theme this config uses |
| **[Gist](https://gist.github.com/vinhnx/8bb4ef22e5ccfee5f839dbf1a31939ae)** | single-file snapshot, now pointing here |

If you want the color scheme too, install it from
[vitesse-helix](https://github.com/vinhnx/vitesse-helix), a port of Anthony Fu's
Vitesse.

## Contents

| File | Destination |
| --- | --- |
| `config.toml` | `~/.config/helix/config.toml` |
| `rex-init.lua` | `~/.config/rex/init.lua` (**only if you use the [Rex](https://superlogical.com) terminal**) |

## Install

```sh
mkdir -p ~/.config/helix
curl -fsSL https://raw.githubusercontent.com/vinhnx/helix-config/main/config.toml \
  -o ~/.config/helix/config.toml
```

Then, inside Helix: `:config-reload`, or just restart it.

The config expects a theme named `vitesse-black`. Install it from
[vitesse-helix](https://github.com/vinhnx/vitesse-helix), or drop the
`theme = "vitesse-black"` line and use any bundled theme.

> **macOS note:** several bindings use `Cmd`, which only reaches Helix if your
> terminal forwards it. Every `Cmd` binding has a `Ctrl` twin that works
> everywhere, so the config is usable without any terminal setup. See
> [Terminal setup](#terminal-setup-macos).

## Keybindings

`Ctrl` and `Cmd` variants are both bound. `Cmd` is the macOS-native spelling;
`Ctrl` always works.

### Files & buffers

| Key | Action |
| --- | --- |
| `Ctrl/⌘ S` | save |
| `Ctrl/⌘ Shift S` | save all |
| `Ctrl/⌘ P` | file picker |
| `Ctrl B`, `Ctrl ,`, `⌘ ,` | buffer picker |
| `Ctrl Tab` / `Ctrl Shift Tab` | next / previous buffer |
| `Ctrl N` / `Ctrl Shift N` | next buffer / next buffer (command form) |
| `Ctrl Shift P`, `⌘ Shift P` | command palette |
| `Ctrl Shift F`, `⌘ Shift F` | global search in workspace |
| `Ctrl Shift E` | changed-files picker |
| `Ctrl Shift B` | file explorer (side panel) |
| `Ctrl/⌘ Q` | quit |

### Editing

| Key | Action |
| --- | --- |
| `Ctrl/⌘ C` | copy selection, or the whole line when nothing is selected |
| `Ctrl/⌘ X` | cut (same line fallback) |
| `Ctrl/⌘ V` | paste |
| `Ctrl/⌘ A` | select all |
| `Ctrl/⌘ Z` | undo |
| `Ctrl Y`, `Ctrl Shift Z`, `⌘ Shift Z` | redo |
| `Ctrl D` | add a cursor on the next line |
| `Ctrl /` | toggle line comment |
| `Backspace` | delete the current selection |
| `Ctrl Shift K` | delete selection without yanking |
| `Ctrl Shift L` | yank selection to clipboard |
| `Alt Shift I` / `Alt Shift O` | extend / shrink to line bounds |

### Navigation

| Key | Action |
| --- | --- |
| `Ctrl/⌘ ←` / `→` | previous / next word (normal, insert **and** select mode) |
| `Shift ←` / `→`, `⌘ Shift ←` / `→` | extend selection by word |
| `Home` / `End` | start / end of line |
| `Ctrl End` / `Ctrl Home` | end / start of file |
| `Ctrl G` | go to line |
| `Ctrl O` / `Ctrl I` | jump backward / forward (VS Code "Go Back/Forward") |
| `Alt ←` / `Alt →` | jump backward / forward (same, macOS-friendly) |
| `Ctrl Shift V` / `Ctrl Shift H` | vertical / horizontal split |
| `Ctrl W` | window submenu: `v` split, `s` split, `q` close, `o` only, `hjkl` focus, `c` write-quit |

### LSP & IDE

| Key | Action |
| --- | --- |
| `F2` | rename symbol |
| `F12` | go to definition |
| `Shift F12` | find references |
| `Alt F12` | go to implementation |
| `F8` / `Shift F8` | next / previous diagnostic |
| `Ctrl Shift M` | diagnostics picker |
| `Alt Shift M` | workspace diagnostics |
| `Ctrl .` | code action |
| `Ctrl K` | hover documentation |
| `Ctrl Space` | trigger completion |
| `Alt O` | document symbols |
| `Ctrl Shift O` | workspace symbols |
| `Ctrl Shift I`, `Alt Shift F` | format document |

### Debugging

Needs a debug adapter configured in `languages.toml`.

| Key | Action |
| --- | --- |
| `F5` | continue |
| `Shift F5` | restart |
| `F9` | toggle breakpoint |
| `F10` | step over |
| `F11` / `Ctrl F11` | step in / step out |

## Notable settings

- **Soft wrap on**, wrapping at the window edge (`wrap-at-text-width = false`).
  Setting it to `true` wraps at column 80 even on a wide screen.
- **Relative line numbers**, cursorline, indent guides, a `diff` gutter.
- **Diagnostics**: end-of-line for warnings, inline for errors on the cursor line.
- **Completion**: auto-trigger, `completion-replace = true`, signatures on.
- `default-yank-register = "+"`: yanks go to the system clipboard.
- `screen shell = ["zsh", "-c"]` (see below for Windows).

## Pitfalls this config fixes

Porting VS Code habits to Helix has some sharp edges. These are the ones worth
knowing, and each is handled above:

**`Ctrl-C` in insert mode.** By default Helix leaves insert mode untouched by
`Ctrl-C`, so it falls through to the normal-mode binding. Combined with a
"copy the line" binding, a stray `Ctrl-C` while typing silently copies and
deletes the whole line. Here it is bound to `normal_mode`, which is what
VS Code users actually expect.

**Backspace after yanking.** Helix's `yank` does not clear the selection; it
only leaves *select mode*. So the yanked block stays selected and `Backspace`
can delete exactly that block. With nothing selected it deletes a single
character, so it stays safe to hold down.

**No recursive macros.** A binding like `"Cmd-c" = "@x<Cmd-c>"` re-triggers
itself; Helix detects this and errors out. Use a command **sequence** instead:

```toml
"Cmd-c" = ["extend_line_below", "yank_to_clipboard"]
```

**`Ctrl-F` is not search.** It stays bound to page-down because rebinding it
breaks a core motion. Search is `/`, then `n` / `N`.

**No line swap.** `Alt-Up/Down` (VS Code) has no Helix equivalent: there is no
`swap_selection_up` command in 25.07. Cut and paste the line instead.

**No copy without a selection.** Helix is selection-first; the bindings above
select the line first to imitate VS Code.

## Terminal setup (macOS)

`Cmd` reaches Helix only if the terminal forwards it as a super modifier. In the
[Rex](https://superlogical.com) terminal, unbinding its native copy/paste is
enough; that is what [`rex-init.lua`](rex-init.lua) does:

```lua
rex.unbind("cmd+c")
rex.unbind("cmd+v")
rex.unbind("cmd+x")
```

Rex then sends `⌘ C` as a Kitty `CSI 99;9u` super-sequence, which Helix decodes
as `SUPER`. Reload with `rex config reload`.

For other terminals, skip this file: the `Ctrl` bindings are unaffected, and
some terminals (e.g. iTerm2 with "Report modifiers using CSI u") can be
configured to forward modifiers.

## Windows / Linux

`shell` defaults to `zsh` here. On Windows set:

```toml
[editor]
shell = ["cmd", "/C"]
```

The `Cmd` bindings are inert elsewhere and can be ignored.

## License

MIT. See [LICENSE](LICENSE).

## See also

- [vinhnx/vitesse-helix](https://github.com/vinhnx/vitesse-helix): the Vitesse theme
- [Gist snapshot](https://gist.github.com/vinhnx/8bb4ef22e5ccfee5f839dbf1a31939ae): both files in one place, no longer maintained
- [Helix documentation](https://docs.helix-editor.com/) · [Helix keymap reference](https://docs.helix-editor.com/keymap.html)
