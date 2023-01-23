-- for rate limits: kill 1

require("discordia-interactions")
require("discordia-components")
require("discordia-slash")
require('./src/server')

require('./deps/discordia-replies/discordia-replies')()


local discordia = require('discordia')
local client = discordia.Client()

local uv = require('uv');
local fs = require("fs");

local split_sar = require("split-sar")

local dataTable = require("./src/info")

math.randomseed(os.time())

client:on('ready', function()
	print('Logged in as '.. client.user.username)
end)

client:on("messageCreate", function(message)
    if message.author.bot then return end
    
    for _, file in pairs(fs.readdirSync("./commands")) do
        local fileInfo = require(string.gsub("./commands/"..file, ".lua", ""))

        if fileInfo.command then
           for _, alias in pairs(fileInfo.command) do

          if fileInfo.usePrefix == true then
            if string.sub(message.content, 0, 1) ~= "$" then return end
          end

          local commandString = string.lower(split_sar(message.content)[1])

             if commandString == (fileInfo.usePrefix == true and ("$"..alias or alias)) then

            if fileInfo.permissions then
              for _, permission in pairs(fileInfo.permissions) do
                if not message.member:hasPermission(client:getGuild("1052305529021665411"):getChannel("1058124374735073410"), discordia.enums.permission[permission])
then
                return
              end
            end
          end
            
            pcall(fileInfo.callback(client, message, split_sar(message.content, " "), commandString))
             end           
          end
        end
    end
end)

 
--[[local timer
local currentQuestion = nil
local latestQuestion = nil
client:on("messageCreate", function(message)
math.randomseed(os.time())

    if message.member.bot then return end
       if message.content == "$quiz" then
        -- get a random question
      if currentQuestion ~= nil then return message:newReply("no theres one already playing") end
        repeat currentQuestion = quiz[math.random(#quiz)] until (currentQuestion.answer or nil) ~= latestQuestion
        message:reply(currentQuestion.question)
        -- start a timer for the question
        timer = uv.new_timer()
uv.timer_start(timer, 5500, 0, function()
       if currentQuestion == nil then return end
          coroutine.wrap(message.reply)(message, "time is up the answer was **" ..currentQuestion.answer.."**")
                currentQuestion = nil

            uv.timer_stop(timer)
    end) 
    elseif currentQuestion ~= nil and string.match(string.lower(message.content), currentQuestion.answer) and currentQuestion ~= nil then
      latestQuestion = currentQuestion
              currentQuestion = nil
       message:reply(message.author.name .. " wins!!")

        uv.timer_stop(timer)
    end
    
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

        return
      end
    end

    if math.random(1, 30) == 20 then
       local oddStuff = {"shut up man", " i just busted", "god bro shut UP!!", "yo", "i love you :steamlove:", "happy Birthday .", " 182.17.212.188", "37.5630° N, 122.3255° W", "...", "i just pooped myself :(", "im outside .", "behind you .", "you.", "smash or pass aris (female)"}

      message:newReply(oddStuff[math.random(1, #oddStuff)])
end
end)--]]

client:run('Bot '.. os.getenv("token"))