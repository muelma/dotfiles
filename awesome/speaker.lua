-- commands for raising/lowering the volume
-- might be "amixer -q sset Master 2dB+" (if amixer present)
-- or "pactl set-sink-volume 0 -- -5%" (if using pulseaudio)

local cmd_vol_toggle = cmd_vol_toggle or "amixer -D pulse -q sset Master toggle"
local cmd_vol_down   = cmd_vol_down   or "amixer -D pulse -q sset Master 2%-"
local cmd_vol_up     = cmd_vol_up     or "amixer -D pulse -q sset Master 2%+"
local icondir = icondir -- icondir from rc.lua
local widget = widget
local io = io
local math = math
local awful = awful
local image = image
local beautiful = beautiful
local tonumber = tonumber
local naughty = naughty
local assert = assert

local cmd_vol_get = cmd_vol_get or [[pacmd dump | grep -P "^set-sink-volume " | perl -p -i -e 's/.+\s(.x.+)$/$1/']]

module("speaker")
local vol_muted = false 
---- volume ♫ 
local volicon = widget({ type = "imagebox" })
volicon.image = image( icondir .. "spkr_01.png" )

function get()
    local f = assert(io.popen(cmd_vol_get, 'r')) -- runs command
    local cur_vol = tonumber(f:read("*a")) or -1 -- read output of command
    f:close()
    if cur_vol == -1 then
        naughty.notify({ preset = naughty.config.presets.critical, title="Speaker Widget Error", text = "Error retrieving current volume, check cmd_vol_get in rc.lua!"})
        return 1
    end
    return cur_vol/100.0
end

function is_mute(percentage)
    if vol_muted then return "off", 0
    else return string.format("%3d",percentage) .. "%", percentage end 
end

local vol_prog = awful.widget.progressbar()
vol_prog:set_width(25)
vol_prog:set_height(6)
vol_prog:set_vertical(false)
vol_prog:set_background_color("#434343")
vol_prog:set_border_color(nil)
vol_prog:set_gradient_colors({ beautiful.fg_normal, beautiful.fg_normal, beautiful.fg_normal, beautiful.bar })
awful.widget.layout.margins[vol_prog.widget] = { top = 6 }
vol_prog:set_value(get())
local vol_prog_t = awful.tooltip({ objects = {vol_prog.widget}})
vol_prog.widget:buttons(awful.util.table.join(
    awful.button({ }, 3, function () toggle() end),
    awful.button({ }, 4, function () up() end),
    awful.button({ }, 5, function () down() end)
 ))

function widgets()
    return vol_prog.widget, volicon
end

function toggle()
    awful.util.spawn(cmd_vol_toggle)
    vol_muted = not vol_muted
    if vol_muted then vol_prog:set_value(0.0)
    else vol_prog:set_value(get()) end
end

function update()
--    if vol_muted then volicon.image = image( icondir .. "spkr_03.png" ) 
----    else volicon.image = image( icondir .. "spkr_01.png" )
    local perc = get()
    vol_prog:set_value(perc)
    vol_prog_t:set_text(math.floor(perc*100) .. "%")
end

function up()
    awful.util.spawn(cmd_vol_up)
    update()
end

function down()
    awful.util.spawn(cmd_vol_down)
    update()
end
--
