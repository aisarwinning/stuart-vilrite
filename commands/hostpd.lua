
require("discordia-interactions")
require("discordia-components")
require("discordia-slash")

require('../deps/discordia-replies/discordia-replies')()

local discordia = require('discordia')
local client = discordia.Client()

return {
  usePrefix = true;
  
  command = {"hostpermadeath", "hostpd", " host"};
  permissions = {"sendMessages"};

  callback = function(message, args, commandString)

     if not args[2] or not args[3] or not args[4] then
       message:newReply(commandString.." **<time> <region> <description>**\n\n- **time** (ex. 40)\n- **region** (ex. NA)\n- **description** (ex. cothaigh appears in this mysterious snow storm.)")

        return
    end
      
      local description = args[3]
      
      for _, arg in ipairs(args) do
         if _ > 4 then
           description = description.. " "..arg
        end
      end

     message:newReply("You're perma death event has been setup for XX:"..args[2])
    
   client:getGuild("1052305529021665411" ):getChannel("1058124374735073410"):send({
			embed = {
				title = "Perma Death Event",
				description = description,
        image = { url = "https://media.discordapp.net/attachments/1061686180946653235/1063183527321030826/deadlands_thumbnail.png"};       
				author = {
					name = " -  "..ia.member.user.username,
	   		},
				fields = { -- array of fields
					{
						name = "Time",
						value = "XX:" ..args[2],
						inline = true
					},
					{
						name = "Region",
						value = args[3],
						inline = true
					}
				},
				footer = {
					text = "- stuart vilrite"
				},
				color = 0xFFFFFF -- hex color code
			}
      })
  end

}