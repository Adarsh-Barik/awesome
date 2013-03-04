--------------------CUSTOMIZED------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

--- BY Adarsh for volume_widget
--
cardid  = 0
channel = "Master"
function volume (mode, widget)
	if mode == "update" then
		local fd = io.popen("amixer -c " .. cardid .. " -- sget " .. channel)
		local status = fd:read("*all")
		fd:close()

		local volume = string.match(status, "(%d?%d?%d)%%")
		volume = string.format("% 3d", volume)

		status = string.match(status, "%[(o[^%]]*)%]")

		if string.find(status, "on", 1, true) then
			volume = volume .. "%"
		else
			volume = volume .. "M"
		end
		widget.text = volume
	elseif mode == "up" then
		io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%+"):read("*all")
		volume("update", widget)
	elseif mode == "down" then
		io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%-"):read("*all")
		volume("update", widget)
	else
		io.popen("amixer -c " .. cardid .. " sset " .. channel .. " toggle"):read("*all")
		volume("update", widget)
	end
end
----------------------------------------------------------------------------------------------------------------------------
--
--- By Adarsh for CPU Usage and Temperature

--function gradient(min, max, val)
--	if (val > max) then val = max end
--	if (val < min) then val = min end
--
--	local v = val - min
--	local d = (max - min) * 0.5
--	local red, green
--
--	if (v <= d) then
--		red = (255 * v) / d
--		green = 255
--	else
--		red = 255
--		green = 255 - (255 * (v-d)) / (max - min - d)
--	end
--
--	return string.format("#%02x%02x00", red, green)
--end
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--volume widget ---Added by Adarsh
tb_volume = widget({ type = "textbox", name = "tb_volume", align = "right" })
tb_volume:buttons({
	button({ }, 4, function () volume("up", tb_volume) end),
	button({ }, 5, function () volume("down", tb_volume) end),
	button({ }, 1, function () volume("mute", tb_volume) end)
})
volume("update", tb_volume)


-----------------------------------------------------------------------------------------------------------------------------
--------- LIBRARIES----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
--
-- For vicious
vicious = require("vicious") -- By Adarsh for vicious
require("revelation") --- By Adarsh for revealation
require("wicked") --- By Adarsh for wicked
-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Load Debian menu entries
require("debian.menu")



-----------------------------------------------------------------------------------------------------------------------------
---------------------------------- ERROR HANDLING----------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
--
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



-----------------------------------------------------------------------------------------------------------------------------
--------------------------------------THEME AND COLOURS----------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
---
-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"



-----------------------------------------------------------------------------------------------------------------------------
----------------------------------LAYOUTS AND TAGS---------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags ={
	names = {"main","firefox","music","home","media","latex","bg",8,9},
	layout= {layouts[2],layouts[3],layouts[2],layouts[3],layouts[3],layouts[2],layouts[2],layouts[1],layouts[1]}}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}



-----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------MENU-----------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
--
-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}



------------------------------------------------------------------------------------------------------------------------------
------------------------------------WIDGET AND WIBOX--------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
--
-- {{{ Wibox
-- Network Usage widget
-- Initialize widget 
netwidget = widget({type="textbox"})
-- Register widget
vicious.register(netwidget, vicious.widgets.net, '<span color="#CC9393">${eth0 down_kb}</span> <span color="#7F9F7F">${eth0 up_kb}</span>', 3)
-- separator 
separator = widget({type="textbox"})
separator.text="::"

--- CPU USAGE --- By Adarsh
cpuwidget = widget({
    type = 'textbox',
    name = 'cpuwidget'
})

wicked.register(cpuwidget, wicked.widgets.cpu,
    ' <span color="white">CPU</span> $1%')

--- MPD STATUS --- By Adarsh
--mpdwidget = widget({
--   type = 'textbox',
--    name = 'mpdwidget'
--})
--wicked.register(mpdwidget, wicked.widgets.mpd,
--    ' <span color="white">Now Playing:</span> $1')
-- Initialize widget
mpdwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then 
            return " - "
        else 
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 10)


--- CPU TEMPERATURE --- By Adarsh
-- {{{ CPU temperature
local thermalwidget  = widget({ type = "textbox" })
vicious.register(thermalwidget, vicious.widgets.thermal, " $1°C", 20, { "coretemp.0", "core"} )
-- }}}


-- {{{ CPU USAGE  --- By Adarsh for CPU Usage
--cputextwidget = widget({
--	type = 'textbox',
--	name = 'cputextwidget',
--	align = 'right'
--})

--wicked.register(cputextwidget, 'cpu', function(widget, args)
--	cpuinfo = title("CPU")
--	cpuinfo = color(cpuinfo..'['..args[2]..'% '..cputemp(0)..'°C]  ', gradient(0, 100, tonumber(args[2])))
--	cpuinfo = color(cpuinfo..'['..args[3]..'% '..cputemp(1)..'°C]  ', gradient(0, 100, tonumber(args[3])))
--	cpuinfo = color(cpuinfo..'['..args[4]..'% '..cputemp(2)..'°C]  ', gradient(0, 100, tonumber(args[4])))
--	cpuinfo = color(cpuinfo..'['..args[5]..'% '..cputemp(3)..'°C]  ', gradient(0, 100, tonumber(args[5])))
--	return cpuinfo
--end, 1, nil, 2)
-- }}}

--Memory Usage widget
--Initialize widget
--memwidget = wibox.widget.textbox()
--Register widget
--vicious.register(memwidget, vicious.widgets.mem, "$1% ($2MB/$3MB)", 13)
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

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
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
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
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
	    --volume_widget,
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
	separator,
	tb_volume, --- Added by Adarsh
	separator,
	netwidget,
	separator,
	cpuwidget, --- Added by Adarsh
	separator,
	thermalwidget, ---Added by Adarsh
	separator,
	mpdwidget,
	--cputextwidget,
	--	separator,
--	memwidget,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}





------------------------------------------------------------------------------------------------------------------------------
-----------------------------KEY BINDINGS------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
--
-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
     awful.key({modkey}, "e", revelation), --- Added by Adarsh for revealation

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

--		          awful.util.spawn()
--			     awful.key(
--				            awful.util.spawn()
--					       awful.key(
--						              awful.util.spawn()
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
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

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
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
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



--awful.key({ }, "XF86AudioRaiseVolume", function ())
--	awful.util.spawn("amixer set Master 9%+", false) end,
--awful.key({ }, "XF86AudioLowerVolume", function ())
--	awful.util.spawn("amixer set Master 9%-", false) end,
--wful.key({ }, "XF86AudioMute", function ()
--	awful.util.spawn("amixer sset Master toggle", false) end),
-- }}}

-- {{{ Rules
--
--
-- --------------------------------------------------------------------------------------------------------------------------
----------------------------------------RULES-------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
---
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
		     --maximized_vertical = false,
		     --maximized_horizontal = false,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
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
--
--
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------- CUSTOMIZED HOOKS-------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------
--- By Adarsh
awful.hooks.timer.register(10, function () volume("update", tb_volume) end)--By Adarsh
