--print("Salut!")

http = require("socket.http")

treadenvoie=love.thread.getThread()


while treadenvoie:demand("go") do
	pseudo=treadenvoie:get("pseudo")
	score=treadenvoie:get("score")
	massacre=treadenvoie:get("massacre")
	diff=treadenvoie:get("diff")
	tempstotal=treadenvoie:get("tempstotal")
	maxcombo=treadenvoie:get("maxcombo")
	mdp=treadenvoie:get("mdp")
	if not (pseudo and score and massacre and diff and tempstotal and maxcombo and mdp) then
		treadenvoie:set("ERR",true)
	else
	--print("J'ai tout trouvé")
	--print('http://xi.gd/thumbdrive/scoreenvoie.php?speudo="'..pseudo..'"&mdp='..mdp..'&score='..score..'&massacre='..massacre..'&durdur='..diff..'&tempstotal='..math.floor(tempstotal)..'&maxcombo='..maxcombo..' ')
		body=http.request('http://xi.gd/thumbdrive/scoreenvoie.php?speudo='..pseudo..'&mdp='..mdp..'&score='..score..'&massacre='..massacre..'&durdur='..diff..'&tempstotal='..math.floor(tempstotal)..'&maxcombo='..maxcombo..' ')
		if body then
			treadenvoie:set("message",body)
			treadenvoie:set("finie",true)
		else
			treadenvoie:set("ERR",true)
		end
	end

end

--print("Ayééé")
