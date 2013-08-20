Lighting = {}

--Gibt den Wert 'true' zurück, wenn die entsprechende Kante von der Lichtquelle abgewandt ist
function Lighting.isCastingShadow(v_start, v_end, lgt)
	local vec = v_end - v_start
	local v_normal = vec2(vec.y, -1 * vec.x)
	local v_light_to_start = v_start - vec2(lgt.x, lgt.y)
	
	if dot(v_normal, v_light_to_start) < 0 then
		return true
	else
		return false
	end
end

--Gibt alle der Lichtquelle abgewandeten Kanten eines Polygons zurück;
--Nur diese sind für den Schatten verantwortlich
function Lighting.getCastingVertices(lgt, plg)
	local c_vert = {}
	for i = 1, #plg.vertices do
		if Lighting.isCastingShadow(plg.vertices[i], plg:getVertex(i + 1), lgt) then
			c_vert[#c_vert + 1] = plg.vertices[i]
			c_vert[#c_vert + 1] = plg:getVertex(i + 1)
		end
	end
	return c_vert
end

function Lighting.getProjection(vec, lgt)
	local proj_vec = normalize(vec - (vec2(lgt.x, lgt.y))) * lgt.radius + vec
	return proj_vec
end

--Wichtig! Reihenfolge von vec_3 und vec_4 beachten
function Lighting.drawShadowFin(vec_1, vec_2, vec_3, vec_4) 
	love.graphics.polygon("fill", vec_1.x, vec_1.y, vec_2.x, vec_2.y, vec_3.x, vec_3.y, vec_4.x, vec_4.y)
end
	

function Lighting.drawShadow(src, obj)
	c_vert = Lighting.getCastingVertices(src, obj)
	for i = 1, (#c_vert), 2 do
		Lighting.drawShadowFin(c_vert[i], c_vert[i + 1], Lighting.getProjection(c_vert[i + 1], src), Lighting.getProjection(c_vert[i], src))
	end
end
