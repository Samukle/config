-- Import the wezterm module
local wezterm = require("wezterm")
-- Creates a config object which we will be adding our config to
local config = wezterm.config_builder()
local appearance = require("appearance")

local COLOR_TRANSPARENT = "rgba(0% 0% 0% 0%)"

local IMAGE_BG = {
	[0]=(wezterm.config_dir .. "/assets/clr.jpeg"),
	[1]=(wezterm.config_dir .. "/assets/bg.jpg"),
}
local FLAT_COLOR = {
	source = {File = IMAGE_BG[0]},
	repeat_x = "NoRepeat",
	repeat_y = "NoRepeat",
	opacity = 1.0
}
local IMAGE = {
	source = { File = IMAGE_BG[1] },
	opacity = 0.136,
	hsb = {
		saturation = 1.25,
		hue = 2.0,
	}
} 


config.background = {
	-- rendered first, deep
	FLAT_COLOR,	
	IMAGE,
	-- rendered last
}
--[[
config.window_background_image = "~/.config/wezterm/bg.jpg"
config.window_background_image_hsb = {
	brightness = 0.1
}
--]]
config.color_scheme = "Atlas (base16)"

config.default_prog = { "pwsh.exe", "-NoLogo" }

--config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_frame = {
	font = wezterm.font_with_fallback {
		{ family = "Monofur Nerd Font", weight = "Bold" },
		{ family = "Cascadia Next JP", weight = "Bold" }
	},
	font_size = 13,
	inactive_titlebar_bg = COLOR_TRANSPARENT,
	active_titlebar_bg = COLOR_TRANSPARENT,
	button_fg = COLOR_TRANSPARENT,
	button_bg = COLOR_TRANSPARENT,
}
config.font = wezterm.font_with_fallback {
	{ family = "Monofur Nerd Font", weight = "Regular" },
	{ family = "Cascadia Next JP", weight = "Light" },
} -- ああ
config.font_size = 13
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = "2cell",
	right = "2cell",
	top = "1cell",
	bottom = "0.5cell",
}

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

local BLANK = wezterm.nerdfonts.cod_blank

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "none"
	local background = "rgba(0% 11% 22% 20%)"
	local foreground = "rgba(50% 11% 0% 50%)"

	if tab.is_active then
		background = "rgba(50% 11% 0% 50%)"
		foreground = "#F8A81A"
	elseif hover then
		background = "rgba(11% 0% 22% 50%)"
		foreground = "#00ffdf"
	end

	local edge_foreground = background

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = BLANK },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = BLANK },
		{ Text = title },
		{ Text = BLANK },
	}
end)

-- Returns our config to be evaluated. We must always do this at the bottom of this file
return config
