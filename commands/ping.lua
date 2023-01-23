
require("discordia-interactions")
require("discordia-components")
require("discordia-slash")

require('../deps/discordia-replies/discordia-replies')()


local discordia = require('discordia')
local client = discordia.Client()

return {
  usePrefix = true;
  
  command = {"pingpong", "ping"};
  permissions = {"readMessages"};

  callback = function(message, args)
     message:reply(" I will always come BACK!")
  end

}