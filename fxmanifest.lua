client_script "@mapmanager/koobs.lua"
server_script "@mapmanager/koobs_sv.lua"
fx_version 'adamant'
game 'gta5'
description 'Status'
version '1.1'

ui_page "ui/ui.html"
files {
	"ui/ui.html",
	"ui/fonts/Roboto-Regular.ttf",
	"ui/js/app.js",
	"ui/css/style.css",
		-- Job Images
	'ui/img/logo/jobs/*.png',		
	'ui/img/logo/gangs/*.png',	
	'ui/img/logo/*.png',
}
client_scripts {
	'client.lua'
}
server_scripts {
    'server.lua'
}


