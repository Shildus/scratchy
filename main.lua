-- require 'strict'

scratchy = require 'scratchy'

function love.load()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	player_ship = scratchy.sprite({
		image = "ship_basic.png",
		x = width / 2,
		y = height / 2,
		direction = 0,
		scale = 2,
	})

	enemy_ship = scratchy.sprite({
		image = "ship_basic.png",
		x = width / 2 + 100,
		y = height / 2 + 100,
		direction = -3.14,
		scale = 4,
	})

	Vx = 0
	Vy = 0
end

function love.update(dt)
	
	if love.keyboard.isDown('up') then
		player_ship:move(100 * dt)
	end 

	if love.keyboard.isDown('left') then
		player_ship:turn(-180 * dt)		
	end 

	if love.keyboard.isDown('right') then
		player_ship:turn(180 * dt)		
	end 

	-- if love.keyboard.isDown('down') then
	-- 	Vx = 0
	-- 	Vy = 0
	-- end 

	-- if love.keyboard.isDown('left') then
	-- 	rotation = rotation - math.pi * dt
	-- end 

	-- if love.keyboard.isDown('right') then
	-- 	rotation = rotation + math.pi * dt
	-- end 
	

	-- x = x + Vx * dt
	-- y = y - Vy * dt
	
	-- force_screen_boundaries()

end

-- function force_screen_boundaries()
-- 	if y > height + 20 then y = -20 end
-- 	if x > width + 20  then x = -20 end

-- 	if x < -20 then x = width + 20 end
-- 	if y < -20 then y = height + 20 end
-- end

function love.keypressed(key, unicode)
	print(key)
    if key == 'escape' then
		love.event.quit()
	elseif key == 'kp+' then
		player_ship:go_to_front_layer()
	elseif key == 'kp-' then
		player_ship:go_to_back_layer()
	end
end


function love.draw()
	scratchy.draw()
	
end
