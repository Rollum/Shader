Light = {}

Light.__index = Light

function Light.new(x, y, radius, color)
	local lgt = {}
	setmetatable(lgt, Light)
	lgt.x = x
	lgt.y = y
	lgt.radius = radius
	lgt.color = color
	return lgt
end