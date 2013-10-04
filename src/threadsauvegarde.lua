--print("moi")

function sauvegarde(pseudo,	score,	massacre,	diff,	tempstotal,	maxcombo)
	--print("Gotz da shizzle")
	e = love.filesystem.exists("tableauscore.lua")
	present=0
	--print("encore moi")
	if(e)then
		tableau=filer.fromFile("tableauscore.lua")
		for _,v in ipairs(tableau) do
			if v.pseudo==pseudo then
				present=1
				if v.score<score then
					v.score=score
					v.massacre=massacre
					v.diff=diff
					v.tempstotal=math.floor(tempstotal)
					v.maxcombo=maxcombo
				end
			end
		end
		if present==0 then
			table.insert(tableau,{pseudo=pseudo,score=score,massacre=massacre,diff=diff,tempstotal=math.floor(tempstotal),maxcombo=maxcombo})
		end
	else 
		file = love.filesystem.newFile("tableauscore.lua")
		tableau={}
		table.insert(tableau,{pseudo=pseudo,score=score,massacre=massacre,diff=diff,tempstotal=math.floor(tempstotal),maxcombo=maxcombo})
	end
	table.sort(tableau, function(a,b) return a.score>b.score end)
	filer.toFile("tableauscore.lua",tableau)
end


function charger()
	local e = love.filesystem.exists("tableauscore.lua")
	local tableau
	if(e) then
		tableau=filer.fromFile("tableauscore.lua")
	end
	return tableau or {}
end