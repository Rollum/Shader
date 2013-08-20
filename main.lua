require "lib.Light"
require "lib.Lighting"
require "lib.Polygon"
require "lib.Vector2D"

function love.load()
	height = love.graphics.getHeight()
	width = love.graphics.getWidth()
	
	lightMask = love.graphics.newCanvas(width, height)
	singleLight = love.graphics.newCanvas(width, height)
	shadowMask = love.graphics.newCanvas(width, height)
	
	background = love.graphics.newImage("/images/Background.png")
	
	--Lichtshader
    effect = love.graphics.newPixelEffect [[
		extern vec2 lightPos = vec2(300.0, 300.0);
		extern vec3 lightColor = vec3(0.9, 0.8, 0.0);
		extern number lightRadius = 200.0;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
			vec2 pixel = vec2(pixel_coords.x, 600.0 - pixel_coords.y);
			number dis = distance(lightPos, pixel);
			number fac = 1.0 - dis / lightRadius;
			return vec4(lightColor, 1.0) * fac;
        }
    ]]
	
	--Stencil- / Schablonen-Shader
	mask_effect = love.graphics.newPixelEffect [[
		vec4 effect ( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
			if (Texel(texture, texture_coords).rgb == vec3(0.0))
				return vec4(1.0);
			discard;
		}
	]]
	
	--Stencil- / Schablonen-Funktion
	stencilFunc = function ()
		love.graphics.setPixelEffect(mask_effect)
		love.graphics.draw(shadowMask, 0, 0)
		love.graphics.setPixelEffect()
	end
	
	--Initialisierung der Schablone
	stencil = love.graphics.newStencil(stencilFunc)
	
	--Initialisierung der einzelnen Variablen
	lights = {}
	lights[1] = {
		x = 300,
		y = 300,
		color = {0.9, 0.8, 0.2},
		radius = 500.0
	}
	objects = {
		Polygon.new(400, 300, 400, 350, 450, 350, 450, 300),
		Polygon.new(500, 300, 500, 350, 550, 350, 550, 300),
		Polygon.new(600, 300, 600, 350, 650, 350, 650, 300),
		Polygon.new(300, 300, 300, 350, 350, 350, 350, 300)
	}
	ambientLight = {80, 80, 40, 255}
end

function love.draw()
	--Zeichnen des Hintergrundes und sonstiger Objekte
	love.graphics.draw(background, 0, 0)
	love.graphics.setColor(255, 0, 0, 255)
	for k, v in pairs(objects) do
		v:draw()
	end
	love.graphics.setColor(255, 255, 255, 255)
	
	--lightMask auf die Farbe der Ambient-Beleuchtung setzen
	lightMask:clear(getAmbient())
	
	--Für jedes Licht:
	for k, v in pairs(lights) do
		--Entsprechende Canvases clearen
		singleLight:clear(0, 0, 0, 0)
		shadowMask:clear(0, 0, 0, 0)
		
		--Einzelnes Licht rendern
		love.graphics.setPixelEffect(effect)
		love.graphics.setCanvas(singleLight)
		effect:send("lightColor", v.color)
		effect:send("lightRadius", v.radius)
		effect:send("lightPos", {v.x, v.y})
		love.graphics.rectangle("fill", v.x - v.radius, v.y - v.radius, v.radius * 2, v.radius * 2)
		love.graphics.setPixelEffect()
		
		--Für jedes Objekt Schatten entsprechend zur aktuellen Lichtquelle rendern
		love.graphics.setCanvas(shadowMask)	
		for i, j in pairs(objects) do
			Lighting.drawShadow(v, j)
		end
		
		--Einzelnes Licht (zuvor gerendert) mit Schatten-Schablone auf die lightMask rendern
		love.graphics.setCanvas(lightMask)
		love.graphics.setStencil(stencil)
		love.graphics.setBlendMode("additive") --PX
		love.graphics.draw(singleLight)
		love.graphics.setStencil()
	end
	
	--LightMask über die Szene "multiplizieren"
	love.graphics.setCanvas()
	love.graphics.setBlendMode("multiplicative")
	love.graphics.draw(lightMask)
	love.graphics.setBlendMode("alpha")
	love.graphics.print("FPS: " .. love.timer.getFPS(), 5, 5)
	love.graphics.print("Lights: " .. # lights, 500, 5)
	love.graphics.print("Escape = Beenden; Linke Maustaste = Neues Licht; Rechte Maustaste = Licht entfernen; Mausradklick = Ambient Light", 5, 575)
end

function love.update(dt)
	lights[1].x = love.mouse.getX()
	lights[1].y = love.mouse.getY()
end

function love.mousepressed(mX, mY, button)
	if button == "l" then
		table.insert(lights, {x = mX, y = mY, color = {math.random(0, 9) / 10, math.random(0, 9) / 10, math.random(0, 9) / 10}, radius = math.random(500, 700)})
	elseif button == "m" then
		toggleAmbient()
	elseif button == "r" and #lights > 1 then
		table.remove(lights, #lights)
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function toggleAmbient()
	if ambientLight[1] ~= 0 then
		ambientLight = {0, 0, 0, 255}
	else
		ambientLight = {80, 80, 40, 255}
	end
end

function getAmbient()
	return ambientLight[1], ambientLight[2], ambientLight[3], ambientLight[4]
end