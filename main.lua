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
		image = "evil_ship.png",
		x = width / 2 + 100,
		y = height / 2 + 100,
		direction = -3.14,
		scale = 0.2,
	})

	enemy_ship.shoot = function(self)
		print "enemy shoots"
		shot = scratchy.sprite({
			image = "enemy_shot.png",
			x = self.x,
			y = self.y,
			direction = self.direction,
			scale = 0.3
		})
		shot.update = function(self, dt)
			if not self:on_screen() then
				self:delete()
			end
			
			self:move(150 * dt)

			if self:touching(player_ship) then
				player_ship:delete()
				self:delete()
				game_over = true
			end
		end

	end

	enemy_ship.cool_down = 5
	enemy_ship.update = function(self, dt)
		self:point_towards(player_ship)
		self:move(20 * dt)
					
		if self:touching(player_ship) then
			player_ship:delete()
			game_over = true
		end

		self.cool_down = self.cool_down - dt
		if self.cool_down < 0 then
			self.cool_down = 5
			self:shoot()
			
		end
	end

	Vx = 0
	Vy = 0

	-- touching_debug = true
end

function love.update(dt)
	
	if game_over then 
		return
	end

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

    if key == 'escape' then
		love.event.quit()
	elseif key == 'space' and not game_over then
		player_ship:shoot()
	elseif key == 'kp+' then
		player_ship:go_to_front_layer()
		player_ship.scale = player_ship.scale * 1.1
	elseif key == 'kp-' then
		player_ship:go_to_back_layer()
		player_ship.scale = player_ship.scale * 0.9
	end
end


function love.draw()
	scratchy.draw()
	if game_over then
		love.graphics.print("GAME OVER", width/2, height / 2, 0, 5, 5, 35, 10)
	end
	
end
