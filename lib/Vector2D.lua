Vector2D = {}

Vector2D.mt = {}
Vector2D.mt.__add = function(a, b)
	local c = vec2()
	c.x = a.x + b.x
	c.y = a.y + b.y
	return c
end

Vector2D.mt.__sub = function(a, b)
	local c = vec2()
	c.x = a.x - b.x
	c.y = a.y - b.y
	return c
end

Vector2D.mt.__unm = function(a)
	a.x = -a.x
	a.y = -a.y
	return a
end

Vector2D.mt.__mul = function(a, b)
	if getmetatable(a) == Vector2D.mt and getmetatable(b) == Vector2D.mt then
		return dot(a, b)
	else
		local c = vec2()
		if getmetatable(a) == Vector2D.mt then
			c.x = a.x * b
			c.y = a.y * b
		else
			c.x = a * b.x
			c.y = a * b.y
		end
		return c
	end
end

Vector2D.mt.__div = function(a, b)
	local c = vec2()
	if getmetatable(a) == Vector2D.mt then
		c.x = a.x / b
		c.y = a.y / b
	else
		c.x = b.x / a
		c.y = b.y / a
	end
	return c
end

Vector2D.mt.__eq = function(a, b)
	local c = (a.x / b.x)
	if c == (a.y / b.y) then
		return c
	else
		return nil
	end
end

Vector2D.mt.__tostring = function(a)
	return "(" .. a.x .. "," .. a.y .. ")"
end

function vec2(x, y)
	local vec = {}
	setmetatable(vec, Vector2D.mt)
	vec.x = x or 0
	vec.y = y or 0
	return vec
end	

--Gibt den Betrag, also die Länge des Vektors, zurück
function len(a)
	local l = math.sqrt(a.x * a.x + a.y * a.y)
	return l
end

--Gibt das Punktprodukt zweier Vektoren zurück
function dot(a, b)
	local d = (a.x * b.x + a.y * b.y)
	return d
end

--Gibt den zugehörigen Normaleneinheitsvektor zu einem Vektor zurück
function normalize(a)
	local b = a / len(a)
	return b
end

function tocoord(a)
	return a.x, a.y
end

function isFacingTowards(v_start, v_end, lgt)
	local vec = v_end - v_start
	local v_normal = vec2(vec.y, -1 * vec.x)
	local v_light_to_start = v_start - vec2(lgt.x, lgt.y)
	
	if dot(v_normal, v_light_to_start) < 0 then
		return true
	else
		return false
	end
end