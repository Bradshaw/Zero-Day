local sounder_table = {}
local sounder_delay = {}
sounder = {}

volmult = 1

function sounder.play(name, pitch, volume)
	if not sounder_table[name] then
		--print("This is new")
		sounder_table[name] = {}
		for i=1,1 do
			table.insert(sounder_table[name],love.audio.newSource(name))
		end
	else
		local free = false
		for i,v in ipairs(sounder_table[name]) do
			if v:isStopped() then
				--print("Found freedom")
				free = true
			end		
		end
		if not free then
		end
	end
	local playme = math.random(1,1)
	--print(name, #sounder_table[name])
	for i,v in ipairs(sounder_table[name]) do
		if v:isStopped() then
			--print(i.." is a candidate")
			playme = i
		end
	end
	if pitch then
		sounder_table[name][playme]:setPitch(pitch)
	end
	if volume then
		sounder_table[name][playme]:setVolume(volume*volmult)
	else
		sounder_table[name][playme]:setVolume(volmult)
	end
	--print("Playing "..playme)
	sounder_table[name][playme]:rewind()
	sounder_table[name][playme]:play()
end

function sounder.pitch(name, pitch, all)
	if sounder_table[name] then
		for i,v in ipairs(sounder_table[name]) do
			if all or v:playing() then
				v:setPitch(pitch)
			end
		end
	end
end

function sounder.volume(name, volume, all)
	if sounder_table[name] then
		for i,v in ipairs(sounder_table[name]) do
			if all or v:playing() then
				v:setVolume(volume*volmult)
			end
		end
	end
end

function sounder.stop(name)
	if sounder_table[name] then
		for i,v in ipairs(sounder_table[name]) do
			v:stop()
		end
	end
end