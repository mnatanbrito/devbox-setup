local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Appearance
config.font_size = 18
config.color_scheme = "rose-pine-dawn"

-- General configs
config.hide_mouse_cursor_when_typing = true
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

return config
