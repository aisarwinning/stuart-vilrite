
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
  usePrefix = true;
  
  command = {"motivate", "motivation", " affirm"};
  permissions = {};

  callback = function(client, message, args, commandString)

    local motivator = "um idk"
        pcall(function()
   local res, data = coro.request("GET", "https://www.affirmations.dev/")
			local result = JSON.parse(data)    
            motivator = result["affirmation"]
          end)

        message:newReply(string.lower(motivator))

end}