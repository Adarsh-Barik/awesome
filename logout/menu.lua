--- Generated by Adarsh
-- for logout menu
module("logout.menu")

Logout_menu = {}

Logout_menu["Logout"] = {
	{"Shutdown","/usr/lib/indicator-session/gtk-logout-helper -s"},
	{"Restart","/usr/lib/indicator-session/gtk-logout-helper -r" },
--	{"Suspend", terminal .. " -e dbus-send --system  --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend"},
	{"Logout", "/usr/lib/indicator-session/gtk-logout-helper -l"},
	{"Lock", "xlock"},
}
