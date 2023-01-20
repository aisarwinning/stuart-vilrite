local discordia = require('discordia')
local http = require("http")
local client = discordia.Client({cacheAllMembers = false})

math.randomseed(os.time())

http.createServer(function(req, res)
	local body = "Hello World!\n"
	res:setHeader("Content-Type", "text/plain")
	res:setHeader("Content-Length", #body)
	res:finish(body)
end):listen(8080, "0.0.0.0")

client:on('ready', function()
	print('Logged in as '.. client.user.username)
end)

local stop = 0
      
local commandsTable = {
   ["stuart"] = {callback = function(message)     stop = stop + 1
		if stop <= 2 then
      message.channel:send("hi")
      elseif stop == 3 then
      message.channel:send("hello")

      stop = math.random(1, 5)
      elseif stop == 4 then
        message.channel:send("hop off kid")
      elseif stop == 5 then
        message.channel:send("oh mg vox brl kid sgol")
      elseif stop == 6 then
        message.channel:send("im going to ban you.")
      stop = 0
       end 
    end};
  ["you're on fire"] = {callback = function(message) message.channel:send("https://media.discordapp.net/attachments/764362465130709002/1061028155168673842/image.png")
    end;};
  ["ain't that right stuart"] = {callback = function(message)
      message.channel:send("yessir");
    end;}
}

client:on('messageCreate', function(message)
    if message.author.bot then return end
    for _, command in pairs(commandsTable) do
      
	if string.lower(message.content) == _ then
        command.callback(message)  
	     end
    end
end)

client:run('Bot '.. os.getenv("token"))