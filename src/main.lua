
function love.load(arg)
	tgslogo = love.graphics.newImage("images/image002.png")
	title = love.graphics.newImage("images/title.png")
	itguy = love.graphics.newImage("images/itguy.png")
	zombieguy = love.graphics.newImage("images/zombieguy.png")
	zombieguy2 = love.graphics.newImage("images/zombieguy2.png")
	miliguy = love.graphics.newImage("images/miliguy.png")
	tdrive = love.graphics.newImage("images/thumbdrive.png")
	tdrive:setFilter("nearest","nearest")
	capture = false
	screenbox = love.graphics.newCanvas(1024,1024)
	otherbox = love.graphics.newCanvas(1024,1024)
	overlay = love.graphics.newCanvas(1024,1024)
	love.graphics.setLineStyle("rough",0.8)
	screenbox:setFilter("nearest","nearest")
	otherbox:setFilter("nearest","nearest")
	overlay:setFilter("nearest","nearest")
	bigvig=love.graphics.newImage("images/bigvig.png")
	bigpain=love.graphics.newImage("images/bigpain.png")
	love.graphics.setPointStyle("rough")
	love.graphics.setDefaultFilter("nearest","nearest")
	-- Charger les modules
	--[[]]
	font = love.graphics.newImageFont("images/myfont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%_`'*__[]\"" ..
    "<>&#=$")
	--]]
	--font = love.graphics.newFont("images/DisposableDroidBB.ttf",12)
    love.graphics.setFont(font)
    machine = require("machine")
    require("threadsauvegarde")
    require("updategame")
	require("animated")
	require("default")
	require("camera")
	require("shaone")
	require("entity")
	require("bomb")
	require("cart")
	require("aicart")
	require("flyby")
	require("wreck")
	require("filer")
	require("level")
	require("tile")
	require("useful")
	require("military")
	--require("collision")
	require("menupopper")
	require("zombie")
	require("projectile")
	require("splatter")
	require("score")
	require("sounder")


	-- Charger les ressources
	cheeky = love.audio.newSource("music/Alarmed.ogg")
	cheeky:setLooping(true)
	cheeky:setVolume(0.6)
	darkness = love.audio.newSource("music/darkness.ogg")
	darkness:setLooping(false)
	darkness:setVolume(1)
	cheekyfade = love.audio.newSource("music/Alarmedfade.ogg")
	cheekyfade:setLooping(true)
	cheekyfade:setVolume(0)

	engine = love.audio.newSource("music/motor.ogg")
	engine:setLooping(true)
	engine:setVolume(0.3)
	countdown = math.huge

	restab = {
		{width=800,height=600},
		{width=1024,height=600},
		{width=1024,height=768},
		{width=1200,height=768},
		{width=1200,height=900},
		{width=1600,height=900}
	}
	--[[
	if love.filesystem.exists("config.lua") then
    	local opt = filer.fromFile("config.lua")
    	love.graphics.setMode(restab[opt.res].width,restab[opt.res].height,false,false,0)
 		default.playername = opt.playername
    else
    	cycleres()
    end
    --]]

    midx = (love.graphics.getWidth()/default.scale)/2
	midy = (love.graphics.getHeight()/default.scale)/2


	--[[] -- Limiteur de FPS
	min_dt = 1/60
	next_time = love.timer.getMicroTime()
	--]]

	-- Charger les gamestates

	--love.mouse.setGrab(true)
	love.mouse.setVisible(false)

	gstate = require "gamestate"
	hiscorescreen = require("hiscorescreen")
	game = require("game")
	roundstart = require("roundstart")
	intro = require("intro")
	credits = require("credits")
	demo = require("demo")
	pause = require("pause")
	options = require("options")
	flybyscreen = require("flybyscreen")
	endscreen = require("endscreen")
	deadscreen = require("deadscreen")
	resetgame()
	initflyby()
	love.keyboard.setKeyRepeat(0.5,0.025)
	gstate.switch(intro)
end


function love.focus(f)
	gstate.focus(f)
end

function love.mousepressed(x, y, btn)
	gstate.mousepressed(x, y, btn)
end

function love.mousereleased(x, y, btn)
	gstate.mousereleased(x, y, btn)
end

function love.joystickpressed(joystick, button)
	gstate.joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
	gstate.joystickreleased(joystick, button)
end

function love.quit()
	gstate.quit()
end

function love.keypressed(key, uni)
	gstate.keypressed(key, uni)
end

function keyreleased(key, uni)
	gstate.keyreleased(key)
end

function love.update(dt)
	--[[] -- Limiteur de FPS
	next_time = next_time + min_dt
	--]]
	gstate.update(math.min(1/30,dt))
	--gstate.update(1/60)

end


function love.draw()
	gstate.draw()
	--[[] -- Limiteur de FPS
	local cur_time = love.timer.getMicroTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love.timer.sleep((next_time - cur_time))
	--]]
end
