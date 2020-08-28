-- require 'strict'

scratchy = require 'scratchy'

function love.load()
	love.window.setMode(800, 600, {})
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	
	space = scratchy.sprite({
		image = "space.jpg",
		x = width / 2,
		y = height / 2,
		scale = 0.8,
	})

	player_ship = scratchy.sprite({
		image = "ship_basic.png",
		x = width / 2,
		y = height / 2,
		direction = 0,
		scale = 2
	})
	player_ship:load_sound('shot', 'Shot01.wav', 1.2, 1.5)
	
	player_ship.shoot = function(self)
		shot = scratchy.sprite({
			image = "shot.png",
			x = self.x,
			y = self.y,
			direction = self.direction
		})
		player_ship:start_sound('shot')
		shot.update = function(self, dt)
			if not self:on_screen() then
				self:delete()
			end
			
			self:move(200 * dt)

			if self:touching(enemy_ship) then
				enemy_ship:delete()
				self:delete()
			end
		end
	end

	enemy_ship = scratchy.sprite({
		image = "ship_basic.png",
		x = width / 2 + 100,
		y = height / 2 + 100,
		direction = -3.14,
		scale = 4,
	})

	enemy_ship.update = function(self)
		self:point_towards(player_ship)
	end

	Vx = 0
	Vy = 0

	touching_debug = true
end

function love.update(dt)
	
	if love.keyboard.isDown('up') then
		player_ship:move(100 * dt)
	end 

	if not player_ship:on_screen() then
		player_ship:move(-100 * dt)
	end

	if love.keyboard.isDown('left') then
		player_ship:turn(-180 * dt)		
	end 

	if love.keyboard.isDown('right') then
		player_ship:turn(180 * dt)		
	end 

	

	scratchy.update(dt)

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
	elseif key == 'space' then
		player_ship:shoot()
	elseif key == 'kp+' then
		player_ship:go_to_front_layer()
		player_ship.scale = player_ship.scale * 1.1
	elseif key == 'kp-' then
		player_ship:go_to_back_layer()
		player_ship.scale = player_ship.scale * 0.9
	end
	print("Distance from player to enemy: ", enemy_ship:distance_to(player_ship))
	if enemy_ship:touching(player_ship) then
		print "TOUCHING"
	end
end


function love.draw()
	scratchy.draw()
	
end
