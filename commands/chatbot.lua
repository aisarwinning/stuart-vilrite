
require("discordia-interactions")
require("discordia-components")
require("discordia-slash")

require('../deps/discordia-replies/discordia-replies')()

local discordia = require('discordia')
local JSON = require("json")
local coro = require('coro-http')

function escape(str)
    return (string.gsub(str, "[^%w]", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end


return {
  usePrefix = false;
  
  command = {"stuart", "hey"};
  permissions = {};

  callback = function(client, message, args, commandString)

    if commandString == "hey" and args[2] ~= "stuart" then return "not a valid precix" end
    
local response = message:newReply("hold on..")
	local answer = nil
	
	local usedURL = "https://api.wolframalpha.com/v2/query?appid="..os.getenv("wolfram-key").."&input="..escape(string.lower(message.content):gsub("hey stuart ", "")).."&format=plaintext&output=JSON"
		
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
end}