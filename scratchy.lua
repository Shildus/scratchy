-- scratchy.lua
-- makes love2d easier for children coming from MIT Scratch

local scratchy = {}

scratchy.sprites = {}

scratchy.sprite = function (args)
	sprite = {}
	sprite.image = love.graphics.newImage(args.image)
	sprite.x = args.x or 0
	sprite.y = args.y or 0
	sprite.direction = args.direction or 0
	sprite.scale = args.scale or 1
	sprite.hide = args.hide or false
	sprite.layer = args.layer or #scratchy.sprites + 1
	sprite.sounds = {}

	--------------------------------- MOTION ---------------------------------

	sprite.move = function(self, distance)
		self.x = self.x + distance * math.sin(self.direction)
		self.y = self.y - distance * math.cos(self.direction)
	end

	sprite.turn = function(self, degrees)
		radians = degrees * math.pi / 180
		self.direction = self.direction + radians
	end

	sprite.point_towards = function (self, object)
		self.direction = math.atan2(object.x - self.x, self.y - object.y)
	end


	--------------------------------- LOOKS ----------------------------------
	
	sprite.go_to_layer = function(self, layer)
		for position, sprite in ipairs(scratchy.sprites) do
			if sprite == self then
				table.remove(scratchy.sprites, position)
				table.insert(scratchy.sprites, layer, self)
				break 
			end
		end
	end

	sprite.go_to_front_layer = function(self) self:go_to_layer(#scratchy.sprites) end
	sprite.go_to_back_layer = function(self) self:go_to_layer(1) end

    table.insert(scratchy.sprites, sprite.layer, sprite)

	--------------------------------- SOUND ----------------------------------
	
	sprite.load_sound = function(self, sound, wav_file, volume, pitch)
		volume = volume or 1
		pitch = pitch or 1
		self.sounds[sound] = love.audio.newSource(wav_file, "static")
		self.sounds[sound]:setVolume(volume)
		self.sounds[sound]:setPitch(pitch)
	end

	sprite.start_sound = function(self, sound)
		self.sounds[sound]:play()
	end

	-------------------------------- SENSING ---------------------------------

	sprite.distance_to = function (self, object)
		return math.sqrt( 
			(object.x - self.x) * (object.x - self.x) + 
			(object.y - self.y) * (object.y - self.y)
		)
	end


	--------------------------------------------------------------------------  
	
	sprite.draw = function(self)
		love.graphics.draw(
			self.image, 
			self.x, 
			self.y,
			self.direction,
			self.scale,
			self.scale,
			self.image:getWidth()/2,
			self.image:getHeight()/2,
			0, -- shearing x
			0  -- shearing y
		)
	end

	return sprite
end



scratchy.draw = function()
	for _, sprite in ipairs(scratchy.sprites) do
		if not sprite.hide then
			sprite:draw()
		end
    end
end

return scratchy