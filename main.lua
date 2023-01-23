-- for rate limits: kill 1

require("discordia-interactions")
require("discordia-components")
require("discordia-slash")

local discordia = require('discordia')
local http = require("http")
local fs = require("fs");
local coro = require("coro-http");
local JSON = require("json")
local spawn = require('coro-spawn')
local split = require('coro-split')
local parse = require('url').parse
local client = discordia.Client()

client:useApplicationCommands()


require('./deps/discordia-replies/discordia-replies')()

local util = require("discordia-slash").util


local tools = util.tools()
math.randomseed(os.time())

local commands = {}
local faq = {
  ["how to get skills"] = {"you get skills by finding trainers which r real people but they not gonna do it easily", "you literly just talk to othsrs"} ;
  ["how do i progress"] = {"you find trainers or you train yourself and send stuff to #skill-confirmation", " um you just speak to trainers and stuff idk im not progressed"} ;
  ["when is pd"] = {"yo shut up", "ask for a pd again see what happens to you", "when yo papa come back"} ;
  ["when is a pd happening"] = {"shut up bro", "thats it i just cancelled all the pds"};
  ["can you host a pd"] = {"no go away", "no", "no bro", "yo fuk off"} ;
  ["host pd"] = {"no dude", "nah i think im good", "i already said no", "dawg when do you ever shut up about pds"} ;
  ["host a pd"] = {"oh my god this guy does not shut up about pds" ,"when i see u ingame its over bro", "NO means No" , "stop asking pd hosters to host a pd", " pds will happen when they need to happen not when you ask", "no bro", " yoo shut the fuk up", "man"},
  ["spear"] = {"chain pull is not happening", "do you ever think about touching grass bro", "spear this spear that bro shut up", "i will not hesitate to ban you.", "chain pull light piercer m1 m1 serpent strike m2"};
  ["fuck stuart"] = {"Look Outside of ur Wind ow.", "fuck you bitch", "you are my biggest opp", " 182.12.194.183"};
["can i have specs"] = {"!ban", "say that shit again and im getting you terminated", "!kick", "no you cant", " prices for specs: 100$ for admin 200$ for jester no scam"},
  ["<@508540365599539202>"] = {"you ping him again and we have problem", "can you stop pinging him", "im at ur door step ."},
  ["i hate stuart"] = {"oh yeah well I hate you too!!", "everything I do and this how u pay me back" , "fuck you small bitch"},
  ["sex"] = {"🤣🤣😂😂 get it?? he said sex!!" , "🤣🤣🤣🤣😂😂 sex!!", 'you are so unfunny "sex"'},
  ["i love stuart"] = {"https://media.discordapp.net/attachments/1052305529952817289/1066440373897019545/725792755502022777.png" , "https://media.discordapp.net/attachments/1052305529952817289/1066440373704085514/3194-steamhappy.png"};
  ['"you."'] = {"https://media.discordapp.net/attachments/1061049375914197102/1066769009128783933/Screenshot_1715-1.png", "https://media.discordapp.net/attachments/1061049375914197102/1066769008730312766/image-16.png", "https://media.discordapp.net/attachments/1064298390218883122/1066501536852738158/image.png", "https://media.discordapp.net/attachments/1064298390218883122/1065028006051074118/image.png", "https://media.discordapp.net/attachments/1064298390218883122/1065020821220888656/image.png", "https://media.discordapp.net/attachments/1064298390218883122/1064318479672545280/image.png", "https://media.discordapp.net/attachments/1064298390218883122/1064310232249020416/image-3.png", ""}
}

local motivationWords = {"hey stuart give me words of motivation", "hey stuart motivate me", "stuart give me motivation", " stuart give me words of motivation", "stuart encourage me"}

function encodeURI(str)
	return (str:gsub("([^A-Za-z0-9%_%.%-%~])", function(v)
			return string.upper(string.format("%%%02x", string.byte(v)))
	end))
end

for _, file in pairs(fs.readdirSync("./commands")) do
  local fileTable = require(string.gsub("./commands/"..file, ".lua", ""))

  commands[_] = {
    name = fileTable.name;
    description = fileTable.description;
    permissions = fileTable.permissions or nil;
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
              for _, vcmd in pairs(client:getGuildApplicationCommands(guildID)) do
  client:deleteGuildApplicationCommand(guildID, tostring(vcmd.id))

      end
          for _, command in pairs(commands) do         

        
            local cmdd, err = client:createGuildApplicationCommand(guildID,
        {
        name = command.name,
        description = command.description,
        options = command.options,

        type = discordia.enums.appCommandType.chatInput,
        })
        if err then print(err) end
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

function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

client:on("messageCreate", function(message)
    if message.member.bot then return end



    
    for _, word in pairs(motivationWords) do
       if string.lower(message.content) == word then
        local motivator = "um idk"
        pcall(function()
   local res, data = coro.request("GET", "https://www.affirmations.dev/")
			local result = JSON.parse(data)    
            motivator = result["affirmation"]
          end)

        message:newReply(string.lower(motivator))


         return
      end
    end
    
    if string.find(string.lower(message.content), "hey stuart") then
      	local response = message:newReply("hold on..")
	local answer = nil
	
	local usedURL = "https://api.wolframalpha.com/v2/query?appid="..os.getenv("wolfram-key").."&input="..encodeURI(string.lower(message.content):gsub("hey stuart ", "")).."&format=plaintext&output=JSON"
		
	coroutine.wrap(function()
		pcall(function()
			local res, data = coro.request("GET", usedURL)
			local result = JSON.parse(data)
              
      answer = result["queryresult"]["pods"][2]["subpods"][1].plaintext
            end)
		
		if answer == nil then
			local clueless = {"i dont know", "clueless", "bro idk", "i dont get your question"}
            response:setContent(clueless[math.random(1, #clueless)])
			return nil
		end

		response:setContent(string.lower(answer or "i dont know"))
  
	end)()
    end 


    
   for question, answer in pairs(faq) do
       if string.find(string.lower(message.content), question) then
        message:newReply(answer[math.random(1, #answer)])
        break
      end
    end
end)

--> Command Handler:

client:on("slashCommand", function(ia, cmd, args)
    print(" rifle")
    for _, command in pairs(commands) do
    if cmd.name == command.name then
        if command.permissions and not ia.member:hasPermission( client:getGuild("1052305529021665411"):getChannel("1058124374735073410"), command.permissions) then
          ia:reply("you do not have the right permissions for this command lil bro", true)
          return
        end

       command.callback(ia, cmd, args, client)
    end
    end
end)

client:run('Bot '.. os.getenv("token"))