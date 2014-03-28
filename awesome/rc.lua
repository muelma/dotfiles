-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Widgets
vicious = require("vicious")
-- Debian menu entries
-- require("debian.menu")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

-- gather some information
env_home = os.getenv("HOME")
env_session = os.getenv("DESKTOP_SESSION") or ""
confdir = env_home .. "/.config/awesome/"
icondir = confdir .. "icons/"

beautiful_theme= confdir .. "themes/default/theme.lua"
--beautiful_theme="/usr/share/awesome/themes/default/theme.lua"

-- commands for raising/lowering the volume
-- might be "amixer -q sset Master 2dB+" (if amixer present)
-- or "pactl set-sink-volume 0 -- -5%" (if using pulseaudio)

if os.execute("which pulseaudio") == 0 then
    snd_device = "-D pulse"
else
    snd_device = "-c 0"
end

-- increase or decrease volume by this number of %
volume_percentage_change = 2 

-- command for activating screensaver/lock screen
cmd_screensaver = "xflock4"
-- commands for restart, logout, shutdown
cmd_ask_shutdown = "xfce4-session-logout --halt"
cmd_ask_logout   = "xfce4-session-logout"
cmd_ask_hibernate = "sudo pm-hibernate"

if string.find(env_session, "gnome") then
    cmd_quit_noask = function() awful.util.spawn("gnome-session-quit --logout --no-prompt") end
elseif string.find(env_session, "xfce") then
    cmd_quit_noask = function() awful.util.spawn("xfce4-session-logout --logout") end
else
    cmd_quit_noask   = awesome.quit
end

-- make naughty icons 64pts small (eg. for quodlibet)
naughty.config.default_preset.icon_size = 64

-- Themes define colours, icons, and wallpapers
beautiful.init(beautiful_theme)
-- beautiful.init("/home/mmueller/.config/awesome/sky/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = ""
-- sets the order of terminals to be tested
terminals = { "xterm","urxvt", "gnome-terminal --hide-menubar", "x-terminal-emulator" } 
-- look whether terminal exists and take the first in the list that does exist
for i, term in ipairs(terminals) do
    terminal = term
    if os.execute("which " .. terminal .. " >/dev/null ") == 0 then
       break 
    end
end

-- x-terminal-emulator for alternatives set by host system (amend later)
--terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
-- clear lock
-- add Mod4= Caps_Lock
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.max,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}
-- local conffile = awesome.conffile or aweful.util.getdir("config") .. "/rc.lua"

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
}
mysessionmenu = {
   { "logout menu", cmd_ask_logout},
   { "force logout", cmd_quit_noask},
   { "shutdown", cmd_ask_shutdown},
   { "- hibernate -", cmd_quit_hibernate}
}


mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "session", mysessionmenu },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Spacers
rbracket = widget({type = "textbox" })
rbracket.text = "]"
lbracket = widget({type = "textbox" })
lbracket.text = "["
space = widget({ type = "textbox" })
space.text = " "

-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

diskwidget = widget({ type = 'textbox' })
diskwidget.text = "du"
disk = require("diskusage")
disk.addToWidget(diskwidget, 75, 90, true)
-- the first argument is the widget to trigger the diskusage
-- the second/third is the percentage at which a line gets orange/red
-- true = show only local filesystems

-- Battery ⚡
--
-- name of the battery
battery = "BAT0"
-- test whether battery is present
baticon = widget({ type = "imagebox"})
baticon.image = image( icondir .. "bat_full_02.png" )

batwidget = awful.widget.progressbar()
batwidget:set_width(25)
batwidget:set_height(6)
batwidget:set_vertical(false)
batwidget:set_background_color("#434343")
batwidget:set_border_color(nil)
batwidget:set_gradient_colors({ beautiful.fg_normal, beautiful.fg_normal, beautiful.fg_normal, beautiful.bar })
awful.widget.layout.margins[batwidget.widget] = { top = 6 }
batwidget_t = awful.tooltip({ objects = {batwidget.widget}})
vicious.register(batwidget, vicious.widgets.bat,
                function (widget, args)
                    battery_state = "full"
                    if args[1] == "-" then
                        battery_state = "discharging ... " .. args[3]
                    elseif args[1] == "+" then
                        battery_state = "charging ... " .. args[3]
                    end
                    batwidget_t:set_text(battery_state)
                    return args[2]
                end, 
                61, battery)

-- Weather widget
weatherwidget = widget({ type = "textbox" })
weather_t = awful.tooltip({ objects = { weatherwidget },})

vicious.register(weatherwidget, vicious.widgets.weather,
                function (widget, args)
                    weather_t:set_text("City: " .. args["{city}"] .."\nWind: " .. args["{windkmh}"] .. "km/h " .. args["{wind}"] .. "\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%")
                    return args["{tempc}"] .. "°C"
                end, 1800, "EDDP")
                --'1800': check every 30 minutes.
                --'EDDP': airport Halle-Leipzig
 
-- volume ♫ 
s = require("speaker")
spr, sic = speaker.widgets()

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", height="18", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        space,
        rbracket, diskwidget, lbracket,
        space,
        rbracket, weatherwidget, lbracket,
        space,
        rbracket, space, spr, sic, lbracket,
        space,
        rbracket, space, batwidget.widget, baticon, lbracket,
        space,
        s == screen.count() and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey, "Shift"   }, "n", 
        function()
            local tag = awful.tag.selected()
                for i=1, #tag:clients() do
                    tag:clients()[i].minimized=false
                    tag:clients()[i]:redraw()
            end
        end),
    awful.key({"Mod1", "Control"}, "l",
       function () awful.util.spawn( cmd_screensaver ) end),
    awful.key({}, "#123", 
        function () speaker.up() end),
    awful.key({}, "#122", 
        function () speaker.down() end),
    awful.key({}, "#121", 
        function () speaker.toggle() end),
    awful.key({ modkey,           }, "F1",
        function () awful.util.spawn("firefox", false) end),
    awful.key({ modkey,           }, "F12",
        function () awful.util.spawn("env PULSE_LATENCY_MSEC=60 skype", false) end),
--    awful.key({ modkey, }, "F10", 
--        function () awful.util.spawn("dbus-send --session --type=method_call --print-reply --dest=org.gnome.SessionManager /org/gnome/SessionManager org.gnome.SessionManager.Logout uint32:1") end),
    awful.key({ modkey,           }, "F2",
        function () awful.util.spawn("quodlibet", false) end),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", cmd_quit_noask),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     -- maximization does not lead to spaces at the border:
                     size_hints_honor = false }},
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Opera" },
      properties = {
          tag = tags[screen.count()][1],
          switchtotag = true,
          fullscreen = false,
          maximized_vertical = true,
          maximized_horizontal = true,
          floating = true }},
    { rule = { name = "OpenGl" }, properties = { floating = true }},
    { rule = { class = "Firefox" },
      properties = {
          tag = tags[screen.count()][1],
          switchtotag = true,
          fullscreen = false,
          maximized_vertical = true,
          maximized_horizontal = true,
          floating = true,
          size_hints_honor = false }},
    { rule = { class = "Scribus" },
      properties = {
          floating = true}},
    { rule = { class = "quodlibet" },
      properties = {
          tag = tags[screen.count()][2],
          switchtotag = true,
          fullscreen = false,
          maximized_vertical = true,
          maximized_horizontal = true,
          floating = true,
          size_hints_honor = false }},
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--require("lfs")
---- sudo apt-get install liblua5.1-filesystem0
---- {{{ Run programm once
--local function processwalker()
--   local function yieldprocess()
--      for dir in lfs.dir("/proc") do
--        -- All directories in /proc containing a number, represent a process
--        if tonumber(dir) ~= nil then
--          local f, err = io.open("/proc/"..dir.."/cmdline")
--          if f then
--            local cmdline = f:read("*all")
--            f:close()
--            if cmdline ~= "" then
--              coroutine.yield(cmdline)
--            end
--          end
--        end
--      end
--    end
--    return coroutine.wrap(yieldprocess)
--end
--
--local function run_once(process, cmd)
--   assert(type(process) == "string")
--   local regex_killer = {
--      ["+"]  = "%+", ["-"] = "%-",
--      ["*"]  = "%*", ["?"]  = "%?" }
--
--   for p in processwalker() do
--      if p:find(process:gsub("[-+?*]", regex_killer)) then
--     return
--      end
--   end
--   return awful.util.spawn(cmd or process)
--end
---- }}}
--local r = require("runonce")
---- make session-dependant decisions
--if string.find(env_session, "gnome") then
---- env_session contains gnome somewhere --> assuming that awesome was started via gnome-session
--    r.run("firefox")
--else
---- assuming that awesome was started outside a gnome-session
--    -- r.run("ibamtray",nil,"/usr/bin/ibamtray")
--    -- r.run("wicd-client","--tray","/usr/bin/wicd-client")
--    r.run("gnome-settings-daemon")
--    r.run("nm-applet")
----    r.run("gnome-power-manager", nil, "/usr/bin/gnome-power-manager")
----    r.run("gnome-volume-manager", nil, "/usr/bin/gnome-volume-manager")
--    r.run("eval `gnome-keyring-daemon`")
--end
--naughty.notify({ text=cmd_vol_toggle })
--naughty.notify({ text=cmd_vol_up })

-- system tray colors for dark backgrounds
--
xprop = assert(io.popen("xprop -root _NET_SUPPORTING_WM_CHECK"))
wids = xprop:read("*a")
xprop:close()
-- check whether reading succeeded
if wids ~= "" then
    wid = wids:match("^_NET_SUPPORTING_WM_CHECK.WINDOW.: window id # (0x[%S]+)%c+")
    if wid then
       wid = tonumber(wid) + 1
       os.execute("xprop -id " .. wid .. " -format _NET_SYSTEM_TRAY_COLORS 32c " ..
              "-set _NET_SYSTEM_TRAY_COLORS " ..
              "65535,65535,65535,65535,8670,8670,65535,32385,0,8670,65535,8670")
    end
end
