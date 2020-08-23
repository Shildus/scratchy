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
	sprite.layer = args.layer or #scratchy.sprites + 1

	sprite.draw = function (self)
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

	sprite.move = function (self, distance)
		self.x = self.x + distance * math.sin(self.direction)
		self.y = self.y - distance * math.cos(self.direction)
	end

	sprite.turn = function (self, degrees)
		radians = degrees * math.pi / 180
		self.direction = self.direction + radians
	end

	------------------------------- LOOKS -------------------------------

	sprite.go_to_layer = function (self, layer)
		for position, sprite in ipairs(scratchy.sprites) do
			if sprite == self then
				table.remove(scratchy.sprites, position)
				table.insert(scratchy.sprites, layer, self)
				break 
			end
		end
	end

	sprite.go_to_front_layer = function (self) self:go_to_layer(#scratchy.sprites) end
	sprite.go_to_back_layer = function (self) self:go_to_layer(1) end

    table.insert(scratchy.sprites, sprite.layer, sprite)

	return sprite
end

scratchy.draw = function()
    for _, sprite in ipairs(scratchy.sprites) do
        sprite:draw()
    end
end

return scratchy