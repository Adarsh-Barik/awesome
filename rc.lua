-- Config file for awesome <=3.4
-- Author - Adarsh
-- Use at your own risk
--

-- Widget for cricinfo that fetches live score
--- cricinfo score widget ---Added by Adarsh
--[[function get_score()]]
    --local fd = io.popen("/home/reddragon/.config/awesome/score.py")
    --local str = fd:read("*all")
    --return str 
--end


-- Libraries
--
vicious = require("vicious") 
require("revelation") 
require("wicked") 
-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Library for scratchpad --
local scratch = require("scratch")
-- Load Debian menu entries
require("debian.menu")

--- Added by Adarsh for logout menu 
require("logout.menu")

-- Startup Programs
--- For transparency
awful.util.spawn_with_shell("xcompmgr -cF &")
-- For dropbox
--awful.util.spawn_with_shell("~/.dropbox-dist/dropboxd")
awful.util.spawn_with_shell("tilda")
--- For Random wallpapers
awful.util.spawn_with_shell("sh ~/.config/awesome/wall.sh")
--- For Conky
awful.util.spawn_with_shell("conky -c ~/.conky/.conkyrc.awesome")

-- Error Handling
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



--- Theme and colors
-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/default/theme.lua")
--beautiful.init("/home/reddragon/.config/awesome/themes/colored/theme.lua")

-- Adding volume widget

-- Load the widget.
local APW = require("apw/widget")
--right_layout:add(APW)

--
--

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
--terminal = "xterm"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"



-- Layout and tags

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

tags ={
	names = {"main","web","code","file","pdf"},
	layout= {layouts[2],layouts[3],layouts[2],layouts[3],layouts[2]},
	icons = {"/home/reddragon/.config/awesome/themes/colored/widgets/cyan/arch.png","/home/reddragon/.config/awesome/themes/colored/widgets/cyan/mail.png","/home/reddragon/.config/awesome/themes/colored/widgets/cyan/info_01.png","/home/reddragon/.config/awesome/themes/colored/widgets/cyan/diskette.png","/home/reddragon/.config/awesome/themes/colored/widgets/cyan/cpu.png"}
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
    awful.tag.seticon(tags.icons[1],tags[s][1])
    awful.tag.seticon(tags.icons[2],tags[s][2])
    awful.tag.seticon(tags.icons[3],tags[s][3])
    awful.tag.seticon(tags.icons[4],tags[s][4])
    awful.tag.seticon(tags.icons[5],tags[s][5])
end
-- }}}


-- {{{ Tag Wallpapers
--for s = 1, screen.count() do
--    for t = 1, 5 do
--        tags[s][t]:add_signal("property::selected", function (tag)
--            if not tag.selected then return end
--            --wallpaper_cmd = "awsetbg /home/user/Pictures/wallpaper" .. t .. ".png"
--           -- wallpaper_cmd = "feh --bg-scale /home/adarsh/Downloads/wallpaper/" .. t ..
--            wallpaper_cmd = "sh /home/reddragon/.config/awesome/wall_tag.sh"
--            awful.util.spawn(wallpaper_cmd)
--        end)
--    end
--end
--                                                             -- }}}


-- Menu
-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    --{ "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal },
				    {"Firefox", "firefox"},
					{"Chrome", "google-chrome"},
				    {"Home","nautilus"},
				    --{"Log out", "/home/reddragon/.config/awesome/shutdown_dialog.sh"},
				    {"Logout", logout.menu.Logout_menu.Logout},
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}



-- Widget and wibox
--
-- {{{ Wibox
-- Network Usage widget
-- Initialize widget 
netwidget = widget({type="textbox"})
netwidget.width, netwidget.align=40,"right"
-- Register widget
--vicious.register(netwidget, vicious.widgets.net, '<span color="#CC9393">${eth0 down_kb}</span> <span color="#7F9F7F">${eth0 up_kb}</span>', 3)
vicious.register(netwidget, vicious.widgets.net, '<span color="#CC9393">${wlan0 down_kb}</span> <span color="#7F9F7F">${wlan0 up_kb}</span>', 3)
-- separator 
separator = widget({type="textbox"})
separator.text="|"

--- CPU USAGE --- By Adarsh
cpuwidget = widget({
    type = 'textbox',
    name = 'cpuwidget'
})

wicked.register(cpuwidget, wicked.widgets.cpu,
    ' <span color="blue" stretch="semiexpanded"> $1%</span>',nil,nil,2)

--- MPD STATUS --- By Adarsh
-- Initialize widget
mpdwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then 
            return " - "
        else 
            return args["{Artist}"]..' - '.. args["{Title}"]
	    --return '<span color="blue">args["{Artist}"]..' - '.. args["{Title}"]</span>'
        end
    end, 10)

--- CPU TEMPERATURE --- By Adarsh
-- {{{ CPU temperature
local thermalwidget  = widget({ type = "textbox" })
vicious.register(thermalwidget, vicious.widgets.thermal,'<span color="red">$1°C</span>', 20, { "coretemp.0", "core"} )
-- }}}

-- BATTERY CHARGE --- By Adarsh
battwidget = widget({ type = "textbox" })
vicious.register(battwidget, vicious.widgets.bat, '<span color="green"> $1$2</span>', 61, 'BAT0')



--- SCORE WIDGET --- By Adarsh
--score = widget({type="textbox"})
--score.text=get_score()
--mytimer = timer({timeout = 30})
--mytimer:add_signal("timeout", function() 
    --score.text=get_score() end)
--mytimer:start()
--

-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })


--- Launcher for widgets by Adarsh 
mpc_pause_launcher = awful.widget.launcher({name="mpc_pause_launcher", image="/home/reddragon/.config/awesome/themes/colored/widgets/yellow/pause.png", command="ncmpcpp pause"})
mpc_play_launcher = awful.widget.launcher({name="mpc_play_launcher", image="/home/reddragon/.config/awesome/themes/colored/widgets/green/play.png", command="ncmpcpp play"})
mpc_stop_launcher = awful.widget.launcher({name="mpc_stop_launcher", image="/home/reddragon/.config/awesome/themes/colored/widgets/red/stop.png", command="ncmpcpp stop"})
mpc_prev_launcher = awful.widget.launcher({name="mpc_prev_launcher", image="/home/reddragon/.config/awesome/themes/colored/widgets/blue/prev.png", command="ncmpcpp prev"})
mpc_next_launcher = awful.widget.launcher({name="mpc_next_launcher", image="/home/reddragon/.config/awesome/themes/colored/widgets/blue/next.png", command="ncmpcpp next"})

--- Tooltip for mpc launchers by Adarsh
mpc_tooltip = awful.tooltip({
objects = {mpc_play_launcher},
	timer_function = function()
	local fs = io.popen("ncmpcpp --now-playing")
	local strs = fs:read("*all")
	local str = string.gsub(strs,"&","and")
	--local str = string.format("%q",strs)
	return str
end,
})
mpc_tooltip:add_to_object(mpc_next_launcher)
mpc_tooltip:add_to_object(mpc_stop_launcher)
mpc_tooltip:add_to_object(mpc_prev_launcher)
mpc_tooltip:add_to_object(mpc_pause_launcher)

--- Icons for widgets by Adarsh
dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net_down)
upicon.image = image(beautiful.widget_net_up)
bat = widget({ type = "imagebox" })
temp = widget({ type = "imagebox" })
bat.image = image(beautiful.widget_bat)
temp.image = image(beautiful.widget_temp)
cpu_icon = widget({ type = "imagebox" })
vol = widget({ type = "imagebox" })
cpu_icon.image = image(beautiful.widget_CPU)
vol.image = image(beautiful.widget_vol)

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
            --APW,
	    --volume_widget,
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
	separator,
	-- tb_volume, --- Added by Adarsh
	-- APW,
	-- separator,
	dnicon,
	netwidget,
	upicon,
	separator,
	cpuwidget, --- Added by Adarsh
	cpu_icon,
	separator,
	thermalwidget, ---Added by Adarsh
	temp,
	separator,
	battwidget,
	bat,
	separator,
	mpc_next_launcher,
	mpc_stop_launcher,
	mpc_play_launcher,
	mpc_pause_launcher,
	mpc_prev_launcher,
	--mpdwidget,--- Added by Adarsh
	separator,
    APW,
    --score, ---Added by Adarsh
	--	separator,
--	memwidget,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

----------------------- CONKY ------------------------------------------------------------------------------------------------
--mystatusbar = awful.wibox({position="bottom",screen=1, ontop = false, width = 1, height = 16})



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
    awful.key({ }, "XF86AudioRaiseVolume",  APW.Up),
    awful.key({ }, "XF86AudioLowerVolume",  APW.Down),
    awful.key({ }, "XF86AudioMute",         APW.ToggleMute),
    awful.key({ modkey, "Shift"}, "l", function () awful.util.spawn("xscreensaver-command -lock") end),
    awful.key({ modkey }, "w", function () awful.util.spawn("/opt/kingsoft/wps-office/office6/wps") end),--- for word
    awful.key({ modkey }, "s", function () awful.util.spawn("/opt/kingsoft/wps-office/office6/et") end),--- for excel
--  For scratchpad clients --
--  By Adarsh --
    --awful.key({ modkey }, "s", function () scratch.pad.toggle() end),
    --awful.key({ modkey }, "d", function ("xterm") scratch.pad.set("xterm", 0.60, 0.60, false) end),
    awful.key({ modkey }, "F1", function () scratch.drop("xterm ranger", "center") end),
    awful.key({ modkey }, "F2", function () scratch.drop("xterm ncmpcpp", "bottom", "center", 1,0.5) end),
    awful.key({ modkey }, "F12", function () scratch.drop("gvim /home/reddragon/Temporary/how_to_code", "center", "right",0.2,0.8) end),


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


--- Global Keys by Adarsh
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
		   			 maximized_vertical = false,--- Added by Adarsh
		   			 maximized_horizontal = false,--- Added by Adarsh
					 size_hints_honor = false,
                     buttons = clientbuttons } },
   -- { rule = { class = "MPlayer" },
     -- properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Gimp" },
      properties = { floating = true } },
      --- Added by Adarsh
    {rule = {class = "Tilda"},
     properties = { maximized_vertical = true, maximized_horizontal = true}},
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Firefox" },
       properties = { tag = tags[1][2] } },
    {rule = {class = "Sxiv"}, properties={floating = true}},
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
