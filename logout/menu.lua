--- Generated by Adarsh
-- for logout menu
module("logout.menu")

Logout_menu = {}

Logout_menu["Logout"] = {
	{"Shutdown","/usr/lib/indicator-session/gtk-logout-helper -s"},
	{"Restart","/usr/lib/indicator-session/gtk-logout-helper -r" },
	{"Logout", "/usr/lib/indicator-session/gtk-logout-helper -l"},
	{"Lock", "xlock"},
}
