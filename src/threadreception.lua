http = require("socket.http")

http.TIMEOUT = 3


threadreception=love.thread.getThread();

while threadreception:demand("go") do
	body= http.request('http://xi.gd/thumbdrive/scorereception.php')
	if not body then
		threadreception:set("message","TIMEOUT")
		threadreception:set("ERR",true)
	else
		threadreception:set("message",body)
		threadreception:set("finie",true)
	end
end