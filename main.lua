require("discordia-interactions")
require("discordia-components")
require("discordia-slash")

local discordia = require('discordia')
local http = require("http")
local fs = require("fs")

require('./commands/ping')

local client = discordia.Client({cacheAllMembers = false})


client:useApplicationCommands()
local intrType = discordia.enums.interactionType

local util = require('discordia-slash').util

local tools = util.tools()
math.randomseed(os.time())

local commands = {}

for _, file in pairs(fs.readdirSync("./commands")) do
  local fileTable = require(string.gsub("./commands/"..file, ".lua", ""))

  commands[_] = {
    name = fileTable.name;
    description = fileTable.description;
    permissions = fileTable.permissions or 0;
    callback = fileTable.callback;
    options = fileTable.options;
  }
end

local server = http.createServer(function(req, res)
    local body = "hey bot is up\n"
    res:setHeader("Content-Type", "text/plain")
    res:setHeader("Content-Length", #body)
    
    res:finish(body)
end):listen(8080, "0.0.0.0")

client:on('ready', function()
	print('Logged in as '.. client.user.username)
  for guildID in pairs(client.guilds) do
for _, command in pairs(commands) do         print(client:createGuildApplicationCommand(guildID,
        {
        name = command.name,
        description = command.description,
        options = command.options,

        type = discordia.enums.appCommandType.chatInput,
        }))
         end 
      end
end)

--[[local ping_button = discordia.Button {
  id = "ping",
  label = "Ping!",
  style = "danger",
}

interaction:update {
      embed = {
        title = "Wow! You have actually used the component!",
        color = 0x00ff00,
      }
}

interaction:reply("Hello There! This is ephemeral reply", true)

]]



client:on("slashCommand", function(ia, cmd, args)
    for _, command in pairs(commands) do
    if cmd.name == command.name then
       command.callback(ia, cmd, args)
    end
    end
end)

--> Command Handler:

client:run('Bot '.. os.getenv("token"))