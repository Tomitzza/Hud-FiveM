
resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
description "hud"

dependency "vrp"
ui_page "nui/index.html"
files {
	'nui/index.html',
	'nui/style.css',
  'nui/scripts.js',
  'nui/img/logobun.png',
  'nui/img/safezone.png'
}

client_scripts{ 
  "lib/Tunnel.lua",
  "lib/Proxy.lua",
  "client.lua",
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  "server.lua"
}
