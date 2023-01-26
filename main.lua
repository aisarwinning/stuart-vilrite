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

local function handleError(err)
   if err ~= true then
     client:getGuild("1065772613403688980"):getChannel("1067153657428197416"):send({
        embed = {
          title = "stuart vilrite - error";
          description = tostring(err) or "error could not be sent or unavaliable";
          color = 0x990000;
        }
     })
  end
end

local commands = {}

for _, file in pairs(fs.readdirSync("./commands")) do
    local fileInfo = require(string.gsub("./commands/"..file, ".lua", ""))

    if fileInfo.command then
        for _, alias in pairs(fileInfo.command) do
            commands[alias] = fileInfo
        end
    end
end

client:on("messageCreate", function(message)
    if message.author.bot then return end

    local commandString = string.lower(split_sar(message.content)[1])
    local command = commands[commandString]

    if command then
        if command.usePrefix == true then
            if string.sub(message.content, 0, 1) ~= "$" then return end
        end

        if command.permissions then
            for _, permission in pairs(command.permissions) do
                if not message.member:hasPermission(client:getGuild("1052305529021665411"):getChannel("1058124374735073410"), discordia.enums.permission[permission]) then
                    return
                end
            end
        end

        local success, err = pcall(function() command.callback(client, message, split_sar(string.lower(message.content), " "), commandString) end)

       if not success then handleError(err) end
    end

 --> FAQ

  for question, answer in pairs(dataTable.faq) do
       if string.find(string.lower(message.content), question) then
        message:newReply(answer[math.random(1, #answer)])

        return
      end
    end

end)

client:run('Bot '.. os.getenv("token"))