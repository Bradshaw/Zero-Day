http = require("socket.http")

score_mt = {}


totalkills = 0
maxstreak = 0
score=0
scorepartie=0

function score_mt.kill()
	totalkills = totalkills+1
	score=score+9+math.floor(math.log(math.max(1,streak)*3));
end

function score_mt.endstreak()
	maxstreak = math.max(streak, maxstreak)
	if streak>=3 then
		local bonus=math.floor(streak*math.log(streak))
		score = score+bonus
	end
end

function score_mt.fin()
	score_mt.endstreak()
	bonusmilitaire = 0
	bonuszombie = 0
	bonusdegat = 0
	bonustemps = 0
	--[[
	if militairekill==0 then
		bonusmilitaire=math.floor(score*1.5)
	end
	]]
	--[[
	if militairekill/miltairemax then
		bonusmilitaire=math.floor(score*1.5)
	end
	--]]
	if past<100 then
		bonustemps=math.floor(100-past)
	end
	bonuszombie=math.floor((kills/numzombies)*100)
	bonusdegat=math.floor(c[1].hitpoints)
	if c[1].hitpoints >= 100 then
		awesomehitpoints = true
	else
		awesomehitpoints = false
	end
	if c[1].hitpoints <=5 then
		survivorhitpoints = true
	else
		survivorhitpoints = false
	end
	score=score+math.floor(bonuszombie*(score/100))+math.floor(bonusdegat*(score/100))+math.floor(bonustemps*(score/100))+math.floor(bonusmilitaire*(score/100))
	if awesomehitpoints then score = score + (500*diff) end
	if survivorpoints then score = score + (100*diff) end

	--return {bonusnonmilitaire,bonusmilitaire,bonuszombie,bonusdegat,bonustemps}
end

function score_mt.ajoutweb(pseudo,score,massacre,diff,tempstotal,maxcombo,mdp)
	--print('http://xi.gd/thumbdrive/scoreenvoie.php?speudo="'..pseudo..'"&mdp='..mdp..'&score='..score..'&massacre='..massacre..'&durdur='..diff..'&tempstotal='..math.floor(tempstotal)..'&maxcombo='..maxcombo..' ')
	http.request('http://xi.gd/thumbdrive/scoreenvoie.php?speudo="'..pseudo..'"&mdp='..mdp..'&score='..score..'&massacre='..massacre..'&durdur='..diff..'&tempstotal='..math.floor(tempstotal)..'&maxcombo='..maxcombo..' ')
	message=tonumber(body);
end

function score_mt.consultationweb()
	tableau={}
	body,c,l,h = http.request('http://xi.gd/scorereception.php')
	if body then
		loadstring(body)()
	end

end

function score_mt.new()
	scorepartie=scorepartie+score
	score=0
end
return score