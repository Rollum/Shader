Polygon = {}

Polygon.__index = Polygon

function Polygon.new(x1, y1, x2, y2, x3, y3, ...)
	local plg = {}
	setmetatable(plg, Polygon)
	plg.coords = {x1, y1, x2, y2, x3, y3, unpack(arg)}
	plg.vertices = {}
	for i = 1, (#plg.coords / 2) do
		plg.vertices[i] = vec2(plg.coords[i * 2 - 1], plg.coords[i * 2])
	end
	return plg
end

function Polygon:draw()
	love.graphics.polygon("fill", self.coords)
end

function Polygon:getCoords()
	return self.coords
end

function Polygon:getVertices()
	return self.vertices
end

function Polygon:getVertex(ind)
	if ind <= #self.vertices then
		return self.vertices[ind]
	else
		return self.vertices[1]
	end
end
