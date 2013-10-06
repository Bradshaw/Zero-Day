local state = gstate.new()

require("letterSelector")

function state:init()
	yesnomenu = menupopper.new({
			{text="Oui",
			func=function() cstate=cstate:inject("yes") end},
			{text="Non",
			func=function() cstate=cstate:inject("no") end},
			{text="Corriger pseudonyme",
			func=function() cstate=cstate:inject("correction") end}
		})
	m = {}
	m.pseudo = machine.newState(
	"pseudo",
	nil,
	function() errmess="" texto="Entrez votre pseudo: " end
	)
	m.upload = machine.newState(
	"upload",
	nil,
	function() errmess="" texto="Mettre en ligne votre score?" end
	)
	m.checkpseudo = machine.newState(
	"checkpseudo",
	nil,
	function() errmess="" texto="R<cup<ration donn<es r<seau..." end
	)
	m.wanttocreate = machine.newState(
	"wanttocreate",
	nil,
	function() texto="Cr<er nouveau compte \""..m.pseudo.input.."\"?" end
	)
	m.makepw = machine.newState(
	"makepw",
	nil,
	function() m.makepw.input = "" texto="Choisissez un mot de passe: " end
	)
	m.confirmpw = machine.newState(
	"confirmpw",
	nil,
	function() errmess="" m.confirmpw.input = "" texto="Confirmez votre mot de passe: " end
	)
	m.checkmake = machine.newState(
	"checkmake",
	nil,
	function()
		errmess=""
		texto="En attente du r<seau"
		if m.confirmpw.input~=m.makepw.input then
			discrep = true
			errmess = "Les mots de passe ne corr<spondent pas"
		end
	end
	)
	m.checkpw = machine.newState(
	"checkpw",
	nil,
	function()m.checkpw.input = "" texto="Entrez votre mot de passe: " end
	)
	m.verifpw = machine.newState(
	"verifpw",
	nil,
	function() errmess="" texto="En attente du serveur" end
	)
	m.gotoscore = machine.newState(
	"gotoscore",
	nil,
	function() if m.pseudo.input~="" then sauvegarde(m.pseudo.input, score+scorepartie, totalkills, diff, temps+past, maxstreak) end initflyby() gstate.switch(hiscorescreen) texto="Chargement des scores" end
	)
	m.pseudo.textinput = true
	m.pseudo.input = ""
	if love.filesystem.exists("config.lua") then
    	m.pseudo.input = ""
    end
	m.pseudo:newTransition(m.gotoscore,"escape")
	m.pseudo:newTransition(m.gotoscore,"return")
	--m.pseudo:addTFunction(function() sendthread:set("pseudo",m.pseudo.input) end, "return")
	m.upload.menuinput = true
	m.upload.menu = yesnomenu
	m.upload:newTransition(m.pseudo,"correction")
	m.upload:newTransition(m.checkpseudo,"yes")
	m.upload:newTransition(m.gotoscore,"no")
	m.upload:newTransition(m.upload,"escape")
	m.upload:addTFunction(function() getthread:set("go",true) end, "yes")
	m.checkpseudo:newTransition(m.wanttocreate,"create")
	m.checkpseudo:newTransition(m.checkpw,"login")
	m.checkpseudo:newTransition(m.upload,"ERR")
	m.checkpw.textinput = true
	m.checkpw.hidden = true
	m.checkpw.input = ""
	m.checkpw:newTransition(m.verifpw,"return")
	m.checkpw:newTransition(m.upload,"escape")
	m.checkpw:addTFunction(function()
		sendthread:set("pseudo", m.pseudo.input)
		sendthread:set("score", score+scorepartie)
		sendthread:set("massacre", totalkills)
		sendthread:set("maxcombo", maxstreak)
		sendthread:set("diff", diff)
		sendthread:set("tempstotal", temps+past)
		sendthread:set("mdp",sha1(m.checkpw.input))
		sendthread:set("go",true)
		end, "return")
	m.verifpw:newTransition(m.upload,"ERR")
	m.verifpw:newTransition(m.gotoscore,"correct")
	m.verifpw:newTransition(m.checkpw,"incorrect")
	m.wanttocreate.menuinput = true
	m.wanttocreate.menu = yesnomenu
	m.wanttocreate:newTransition(m.makepw,"yes")
	m.wanttocreate:newTransition(m.upload,"no")
	m.wanttocreate:newTransition(m.pseudo,"correction")
	m.makepw.textinput = true
	m.makepw.hidden = true
	m.makepw.input = ""
	m.makepw:newTransition(m.confirmpw,"return")
	m.makepw:newTransition(m.upload, "escape")
	m.confirmpw.textinput = true
	m.confirmpw.input = ""
	m.confirmpw.hidden = true
	m.confirmpw:newTransition(m.checkmake,"return")
	m.confirmpw:newTransition(m.wanttocreate,"escape")
	m.confirmpw:addTFunction(
		function()
			if m.makepw.input==m.confirmpw.input then
				sendthread:set("pseudo", m.pseudo.input)
				sendthread:set("score", score+scorepartie)
				sendthread:set("massacre", totalkills)
				sendthread:set("maxcombo", maxstreak)
				sendthread:set("diff", diff)
				sendthread:set("tempstotal", temps+past)
				sendthread:set("mdp",sha1(m.makepw.input))
				sendthread:set("go",true)
			else
				cstate=m.upload
			end
		end, "return")
	m.checkmake:newTransition(m.gotoscore,"correct")
	m.checkmake:newTransition(m.wanttocreate,"incorrect")
	m.checkmake:newTransition(m.wanttocreate,"ERR")




end


function state:enter()
	letterSelector.reset()
	c[1].flyby = true
	errmess = ""
	cheeky:stop()
	cheekyfade:stop()
	darkness:play()
	texto = "Entrez votre pseudo: "
	cstate = m.pseudo
	love.keyboard.setKeyRepeat(0.5,0.025)
	gotname = false
	gotpass = false
	--sauvthread= love.thread.newThread("sauvegarde", "threadsauvegarde.lua")
	if not (sendthread or getthread) then
		--sendthread= love.thread.newThread("send", "threadenvoie.lua")
		--getthread= love.thread.newThread("get", "threadreception.lua")
		--sendthread:start()
		--getthread:start()
	end
	names = {}
	online = false
	--getthread:set("go",true)


	--print(sendthread,getthread)
	e = love.filesystem.exists("tableauscore.lua")

	--print(e)

	--sauvthread:start()
	--sauvthread:wait()
	--sauvthread:set("speudo","moi")
	--sauvthread:set("score",100)
	--sauvthread:set("massacre",25)
	--sauvthread:set("maxcombo",1)
	--sauvthread:set("diff",1)
	--sauvthread:set("tempstotal",10)
--	sauvthread:start()
	--sendthread:set("score", score+scorepartie)
	--sendthread:set("massacre", totalkills)
	--sendthread:set("maxcombo", maxstreak)
	--sendthread:set("diff", diff)
	--sendthread:set("tempstotal", temps+past)
	--sendthread:set("mdp", sha1("lolzors"))
	--sendthread:start()

	input = ""
	if love.filesystem.exists("config.lua") then
    	local opt = filer.fromFile("config.lua")
    	if type(opt.playername)=="string" then
    		input = opt.playername
    	end
    else
    	input = ""
    end

	pass = ""
end


function state:focus()

end


function state:mousepressed(x, y, btn)

end


function state:mousereleased(x, y, btn)
	
end


function state:joystickpressed(joystick, button)
	
end


function state:joystickreleased(joystick, button)
	
end


function state:quit()
	
end


function state:keypressed(key, uni)
	if cstate.menuinput then
		cstate.menu:doKey(key)
	else
		if useful.isIn(key, "return","j") then
			cstate = cstate:inject("return")
		end
		if cstate.textinput then
			if key == "up" then
				letterSelector.up()
			end
			if key == "down" then
				letterSelector.down()
			end
			if key == "q" then
				cstate.input = useful.buildString(letterSelector.select(), string.byte(letterSelector.select()), cstate.input)
			end
			if key == "a" then
				cstate.input = useful.buildString("backspace", 8, cstate.input)
			end
		end
	end
	if useful.isIn(key, "escape","l") then
		cstate = cstate:inject("escape")
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	if discrep then
		cstate = cstate:inject("incorrect")
		discrep = false
	end

	updategame(dt/2)
	--[[]
	if getthread:get("finie") then
		local ret =getthread:get("message")
		if type(ret)=="string" and ret:sub(1,1)=="t" then
			tableau = {}
			loadstring(ret)()
			names = {}
			for k,v in pairs(tableau) do
				names[v.speudo]=v.score
			end
			if names[m.pseudo.input] then
				cstate = cstate:inject("login")
			else
				cstate = cstate:inject("create")
			end
		else
			cstate = cstate:inject("ERR")
			errmess = " "
		end
	end
	if getthread:get("ERR") then
		cstate = cstate:inject("ERR")
		errmess = " "
	end
	if sendthread:get("finie") then
		local ret =sendthread:get("message")
		if ret=="3" then
			cstate = cstate:inject("incorrect")
			errmess = "Mot de passe incorrect"
		else
			getthread:set("go",true)
			cstate = cstate:inject("correct")
		end
	end
	if sendthread:get("ERR") then
		cstate = cstate:inject("ERR")
		errmess = " "
	end
	--]]
	shake = math.min(1,math.max(shake-(dt), 0))
	letterSelector.update(dt)
end

local maxZombies = 0
function state:draw()
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setCanvas(overlay)
		love.graphics.print("Vous &tes mort!",midx-font:getWidth("Vous &tes mort!")/2,midy-60)
		love.graphics.print("Score: "..score+scorepartie,midx-100,midy-40)
		love.graphics.print("Combo max: "..maxstreak,midx-100,midy-30)
		love.graphics.print("Zombies tu<s: "..totalkills,midx-100,midy-20)
		love.graphics.print("Rounds: "..diff,midx-100,midy-10)
		love.graphics.print(errmess,midx-100,midy+10)
		if cstate.textinput then
			if cstate.hidden then
				love.graphics.print(texto..string.rep("*",cstate.input:len()),midx-100,midy+20)
			else
				love.graphics.print(texto..cstate.input..letterSelector.display(),midx-100,midy+20)
			end
		elseif cstate.menuinput then
			love.graphics.print(texto,midx-100,midy+20)
			cstate.menu:draw(midx-100,midy+30)
		else
			love.graphics.print(texto,midx-100,midy+20)
		end
	love.graphics.setCanvas()
	drawgame()
end

return state
