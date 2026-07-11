local wezterm = require("wezterm")
local config = wezterm.config_builder()
local os = require("os")
local brightness = 0.05
math.randomseed(os.time())

local wallpaper_dir = os.getenv("USERPROFILE") .. "\\Wallpapers\\"

local image_list = {
  "",
  "miku-1.jpg",
  "denji-1.jpg",
  "minimal-1.jpg",
  "minimal-2.jpg",
  "nixos-1.png",
  "steinsgate-1.png",
  "steinsgate-2.jpg",
  "AnhKiatV2.png",
  "tree.png",
  "moon.png",
  "shinobu.jpg",
  "shinji.jpg",
}

local image_index = 1
local function current_image_path()
  return wallpaper_dir .. image_list[image_index]
end

config.window_background_image_hsb = {
  brightness = brightness,
  hue = 1.0,
  saturation = 0.8,
}

config.window_background_opacity = 1
config.window_background_image = current_image_path()

-- window setting
config.macos_window_background_blur = 85
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("CaskaydiaCove Nerd Font", { weight = "Regular", stretch = "Expanded" })
config.font_size = 13

config.window_decorations = "RESIZE"
config.enable_tab_bar = false

-- keys
config.keys = {
  {
    key = "0",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ResetFontSize,
  },
  {
    key = "L",
    mods = "CTRL|SHIFT",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  {
    key = ">",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(window)
      brightness = math.min(brightness + 0.01, 1.0)
      window:set_config_overrides({
        window_background_image_hsb = {
          brightness = brightness,
          hue = 1.0,
          saturation = 0.8,
        },
        window_background_image = current_image_path(),
      })
    end),
  },
  {
    key = "<",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(window)
      brightness = math.max(brightness - 0.01, 0.01)
      window:set_config_overrides({
        window_background_image_hsb = {
          brightness = brightness,
          hue = 1.0,
          saturation = 0.8,
        },
        window_background_image = current_image_path(),
      })
    end),
  },
  {
    key = "B",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(window)
      if #image_list > 0 then
        image_index = image_index % #image_list + 1
        window:set_config_overrides({
          window_background_image = current_image_path(),
        })
      end
    end),
  },
}

-- others
config.default_cursor_style = "BlinkingUnderline"
config.cursor_thickness = 2
config.max_fps = 120

-- WSL
config.default_domain = 'WSL:archlinux'

return config
