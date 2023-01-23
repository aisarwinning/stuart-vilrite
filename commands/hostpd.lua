local discordia = require('discordia')

return {
    name = "hostpd",
    description = "Notifies everyone that you are hosting a permadeath event.",
  permissions = discordia.enums.permission.sendMessages;
    options = {
    {
         name = "description",
            description = "what is the pd about",
           type = discordia.enums.appCommandOptionType.string;
            required = true;
      autocomplete = false;
    },
        {
         name = "time",
            description = "(IN MINUTES EX: 40)",
           type = discordia.enums.appCommandOptionType.number;
            required = true;
      autocomplete = false;
        },      
  {
         name = "region",
            description = "(EX: NA or EU or ASIA)",
           type = discordia.enums.appCommandOptionType.string;
            required = true;
      autocomplete = false;
    },
  },
 callback = function(ia, command, args, client)
    print(" runs")
    ia:reply("You're perma death event has been setup for XX:"..args["time"], true)
    
   client:getGuild("1052305529021665411" ):getChannel("1058124374735073410"):send({
			embed = {
				title = "Perma Death Event",
				description = args["description"],
        image = { url = "https://media.discordapp.net/attachments/1061686180946653235/1063183527321030826/deadlands_thumbnail.png"};       
				author = {
					name = " -  "..ia.member.user.username,
	   		},
				fields = { -- array of fields
					{
						name = "Time",
						value = "XX:" ..args["time"],
						inline = true
					},
					{
						name = "Region",
						value = args["region"],
						inline = true
					}
				},
				footer = {
					text = "- stuart vilrite"
				},
				color = 0xFFFFFF -- hex color code
			}
      })
    if err then print(err) end
  end;
}