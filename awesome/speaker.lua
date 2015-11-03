-- commands for raising/lowering the volume
-- might be "amixer -q sset Master 2dB+" (if amixer present)
-- or "pactl set-sink-volume 0 -- -5%" (if using pulseaudio)
local snd_device = snd_device
local perc_change = volume_percentage_change or 2
local cmd_vol_toggle = "amixer " .. snd_device .. " -q sset Master toggle"
local cmd_vol_down   = "amixer " .. snd_device .. " -q sset Master " .. perc_change .. "%-"
local cmd_vol_up     = "amixer " .. snd_device .. " -q sset Master " .. perc_change .. "%+"
local cmd_vol_get    = "amixer " .. snd_device .. [[ sget Master |grep %|sed -r 's/.*\[(.*)%\].*/\1/' | head -n 1]]
local cmd_mute_get   = "amixer " .. snd_device .. [[ sget Master |grep %|sed -r 's/.*\[(o.*)\].*/\1/' | head -n 1]]

-- local cmd_vol_toggle = cmd_vol_toggle or "amixer -D pulse -q sset Master toggle"
-- local cmd_vol_down   = cmd_vol_down   or "amixer -D pulse -q sset Master 2%-"
-- local cmd_vol_up     = cmd_vol_up     or "amixer -D pulse -q sset Master 2%+"

local icondir = icondir -- icondir from rc.lua
local io = io
local math = math
local awful = awful
local wibox = wibox
local image = image
local beautiful = beautiful
local tonumber = tonumber
local naughty = naughty
local assert = assert
local timer = timer
local string = string

local cmd_vol_get = cmd_vol_get or [[pacmd dump | grep -P "^set-sink-volume " | perl -p -i -e 's/.+\s(.x.+)$/$1/']]

module("speaker")

local vol_muted = nil 
if string.find(awful.util.pread(cmd_mute_get), "off", 1, true) then
  vol_muted = true
else
  vol_muted = false 
end
-- naughty.notify({ text = is_muted, timeout = 2})
--if vol_muted then
--  naughty.notify({ text = "it is off", timeout = 2})
--else
--  naughty.notify({ text = "it is on", timeout = 2})
--end

---- volume ♫ 
local volicon = wibox.widget.imagebox()
volicon:set_image(icondir .. "spkr_01.png")

function get()
    local cur_vol = tonumber(awful.util.pread(cmd_vol_get))
    return cur_vol/100
end

local vol = get()*100

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
vol_prog:set_color({ type = "linear", from = { 0, 0 }, to = { 1,0 }, stops = { {0, "#434343"}, {1, "#A3A3A3"}}})
local vol_progm = wibox.layout.margin(vol_prog,0,3,6,6)
local vol_prog_t = awful.tooltip({ objects = {vol_progm}})
vol_progm:buttons(awful.util.table.join(
    awful.button({ }, 3, function () toggle() end),
    awful.button({ }, 4, function () up() end),
    awful.button({ }, 5, function () down() end)
 ))
if vol_muted then vol_prog:set_value(0.0)
else 
  vol_prog:set_value(get()) 
  vol_prog_t:set_text(math.floor(vol) .. "%")
end

function widgets()
    return vol_progm, volicon
end

function toggle()
    awful.util.spawn(cmd_vol_toggle)
    vol_muted = not vol_muted
    if vol_muted then 
      vol_prog:set_value(0.0)
      volicon:set_image(icondir .. "spkr_02.png")
    else 
      vol_prog:set_value(get()) 
      volicon:set_image(icondir .. "spkr_01.png")
    end
end

function update()
--    if vol_muted then volicon.image = image( icondir .. "spkr_03.png" ) 
--    else volicon.image = image( icondir .. "spkr_01.png" )
    vol_prog:set_value(vol/100)
    vol_prog_t:set_text(math.floor(vol) .. "%")
--    naughty.notify({ text = "update()", timeout = 2})
end

function up()
    if not vol_muted then 
      vol = get()*100
      awful.util.spawn(cmd_vol_up)
      vol = vol + perc_change
      if vol > 100 then vol = 100 end
      update()
    end
end

function down()
    if not vol_muted then 
      vol = get()*100
      awful.util.spawn(cmd_vol_down)
      vol = vol - perc_change
      if vol < 0 then vol = 0 end
      update()
    end
end
--
