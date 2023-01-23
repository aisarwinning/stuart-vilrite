local http = require("http")

local server = http.createServer(function(req, res)
    local body = "stuart vilrite: up\n"
    res:setHeader("Content-Type", "text/plain")
    res:setHeader("Content-Length", #body)
    
    res:finish(body)
end):listen(8080, "0.0.0.0")