local discordia = require('discordia')

return {
    name = "ping",
    description = "idk",
    options = {
        {
         name = "realone",
            description = "Whether to show only real ones or not",
           type = discordia.enums.appCommandOptionType.role;
            required = true;
      autocomplete = true;
        },
        {
            name = "fakeones",
            description = "Whether to show only fake ones",
            type = discordia.enums.appCommandOptionType.role,
            required = false;
      autocomplete = true;
        };
    };
 callback = function(ia, command, args)
     ia:reply(" fuk u")
  end;
}