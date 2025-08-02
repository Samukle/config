-- Import the wezterm module
local wezterm = require("wezterm")
-- Creates a config object which we will be adding our config to
local config = wezterm.config_builder()
local appearance = require("appearance")

local COLOR_TRANSPARENT = "rgba(0% 0% 0% 0%)"

config.window_background_image = "C:/Users/Samuel/Pictures/Mountain Pictures/purple.jpg"
config.window_background_image_hsb = {
	brightness = 0.1
}
if appearance.is_dark() then
	config.color_scheme = "Rosé Pine (Gogh)"
else
	config.color_scheme = "Rosé Pine Dawn (Gogh)"
end

config.default_prog = { "pwsh.exe", "-NoLogo" }

--config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_frame = {
	font = wezterm.font({ family = "3270 Nerd Font", weight = "Bold" }),
	font_size = 12,
	inactive_titlebar_bg = COLOR_TRANSPARENT,
	active_titlebar_bg = COLOR_TRANSPARENT,
	button_fg = COLOR_TRANSPARENT,
	button_bg = COLOR_TRANSPARENT,
}
config.font = wezterm.font({ family = "Monofur Nerd Font", weight = "Regular" })
config.font_size = 13
config.hide_tab_bar_if_only_one_tab = true

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
