entity = {}

entity.classes = {}

function entity.register( classtable )
	print( "registering class " .. classtable.classname )
	if classtable.basename ~= nil then
		local basetable = entity.classes[ classtable.basename ]
		if basetable ~= nil then
			setmetatable( classtable, { __index = basetable } )
			classtable.baseclass = basetable
		end
	end
	for k, othertable in pairs( entity.classes ) do
		if othertable.basename == classtable.classname then
			setmetatable( othertable, { __index = classtable } )
			othertable.baseclass = classtable
		end
	end
	entity.classes[ classtable.classname ] = classtable
end

function entity.create( classname )
	local ent = {}
	local classtable = entity.classes[ classname ]
	setmetatable( ent, { __index = classtable, __tostring = classtable.toString } )
	ent:initialize()
	return ent
end

function entity.initialize()
	local files = love.filesystem.enumerate( "ents" )
	for i, v in ipairs( files ) do
		local file = "ents/" .. v
		if love.filesystem.isFile( file ) and string.match( file, ".lua" ) ~= nil then
			dofile( "src/" .. file )
		end
	end
end

local ENT = {}

ENT.classname = "entity"
ENT.basename = nil

ENT.exists = false
ENT.spawntime = 0

ENT.x = 0
ENT.y = 0
ENT.gridx = 1
ENT.gridy = 1

ENT.bbwid = 1
ENT.bbhei = 1

ENT.solid = false

function ENT:initialize()

end

function ENT:spawn()
	self:updateGridPosition()
	world.addEntity( self )
	self.exists = true
	self.spawntime = getTime()
	self:onSpawn()
end

function ENT:onSpawn()

end

function ENT:remove()
	world.removeEntity( self )
	self.exists = false
	self:onRemove()
end

function ENT:onRemove()

end

function ENT:getAge()
	return getTime() - self.spawntime
end

function ENT:setPosition( x, y )
	self.x = x
	self.y = y
end

function ENT:getPosition()
	return self.x, self.y
end

function ENT:getScreenPos()
	local x = ( self.x - camera.x + camera.hwid ) * 8
	local y = ( self.y - camera.y + camera.hhei ) * 8
	
	if x < 0 then x = x + world.width * 8
	elseif x >= camera.width * 8 then x = x - world.width * 8 end
	if y < 0 then y = y + world.height * 8
	elseif y >= camera.height * 8 then y = y - world.height * 8 end
	
	return math.floor( x + 0.5 ), math.floor( y + 0.5 )
end

function ENT:setBBSize( wid, hei )
	self.bbwid = wid
	self.bbhei = hei
end

function ENT:getBBSize()
	return self.bbwid, self.bbhei
end

function ENT:getBBBounds()
	return self.x - self.bbwid / 2, self.y - self.bbhei / 2,
		self.x + self.bbwid / 2, self.y + self.bbhei / 2
end

function ENT:getDiffEnt( ent )
	local x, y = ent.x - self.x, ent.y - self.y
	
	if x >= world.width / 2 then
		x = x - world.width
	elseif x < -world.width / 2 then
		x = x + world.width
	end
	
	if y >= world.height / 2 then
		y = y - world.height
	elseif y < -world.height / 2 then
		y = y + world.height
	end
	
	return x, y
end

function ENT:getDiffPos( x, y )
	x, y = x - self.x, y - self.y
	
	if x >= world.width / 2 then
		x = x - world.width
	elseif x < -world.width / 2 then
		x = x + world.width
	end
	
	if y >= world.height / 2 then
		y = y - world.height
	elseif y < -world.height / 2 then
		y = y + world.height
	end
	
	return x, y
end

function ENT:updateGridPosition()
	self.gridx = math.floor( self.x / ENT_GRID_RES ) + 1
	self.gridy = math.floor( self.y / ENT_GRID_RES ) + 1
	
	self.gridx = math.min( math.max( self.gridx, 1 ), world.gridwidth )
	self.gridy = math.min( math.max( self.gridy, 1 ), world.gridheight )
end

function ENT:getEntGridPosition()
	return self.gridx, self.gridy
end

function ENT:update( dt )
	if self.x < 0 then self.x = self.x + world.width
	elseif self.x >= world.width then self.x = self.x - world.width end
	if self.y < 0 then self.y = self.y + world.height
	elseif self.y >= world.height then self.y = self.y - world.height end
	world.updateEntity( self )
end

function ENT:draw()
	
end

function ENT:toString()
	return "classname: " .. self.classname .. ",\n x: " .. self.x .. ", y: " .. self.y
end

entity.register( ENT )
