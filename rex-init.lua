-- ~/.config/rex/init.lua
--
-- Let Helix see Cmd+C / Cmd+V.
--
-- A mouse drag in Rex goes to Helix (Helix has `mouse = true`, so it turns on
-- mouse tracking), which means Rex has no native selection to copy. The key
-- must therefore reach Helix, which copies via pbcopy/pbpaste.
--
-- Verified: Rex forwards Cmd+C to the child as Kitty `CSI 99;9u` (super+c).
-- After this, reload with `rex config reload`.
--
-- Note: this trades away Rex's own scrollback copy/paste. Use Helix's `y`/`p`
-- for editor text, and re-bind a different key here if you want Rex's
-- scrollback copy back (e.g. rex.bind("cmd+shift+c", <rex copy action>)).

rex.unbind("cmd+c")
rex.unbind("cmd+v")
rex.unbind("cmd+x")
