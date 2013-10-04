letterSelector = {}

letterSelector.alphabet = {
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z"
}

letterSelector.selected = 1

letterSelector.time = 0

function letterSelector.up()
	letterSelector.selected = letterSelector.selected+1
	if letterSelector.selected>#letterSelector.alphabet then
		letterSelector.selected = 1
	end
end

function letterSelector.down()
	letterSelector.selected = letterSelector.selected-1
	if letterSelector.selected<1 then
		letterSelector.selected = #letterSelector.alphabet
	end
end

function letterSelector.select()
	return letterSelector.alphabet[letterSelector.selected]
end

function letterSelector.reset()
	letterSelector.selected = 1
end

function letterSelector.update(dt)
	letterSelector.time = letterSelector.time+dt*5
end

function letterSelector.display( ... )
	if math.floor(letterSelector.time)%2==0 then
		return letterSelector.alphabet[letterSelector.selected]..""
	else
		return " "
	end
end