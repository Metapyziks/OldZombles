local ENT = {}

ENT.classname = "zombie"
ENT.basename = "character"

ENT.animimage = graphics.newImage( "res/zombie.png" )
ENT.walkspeed = 1.5

ENT.target = nil
ENT.wanderx = 0
ENT.wandery = 0

ENT.lastthink = 0
ENT.thinkinterval = 1

function ENT:initialize()
	self.walkspeed = math.random() * 0.5 + 1.25
end

function ENT:update( dt )
	if self:getAge() < 2 then
		self:setMovement( 0, 0 )
		self.animspeed = 0
	else
		if self.target and not self.target.exists then
			self.target = null
		end
	
		if getTime() - self.lastthink > self.thinkinterval then
			self.lastthink = getTime() + math.random()
			self.target = nil
			local near = world.getNearbyEnts( self, 12 )
			local dist = 12 * 12
			for k, v in ipairs( near ) do
				if v.classname == "human" then
					local xd, yd = self:getDiffEnt( v )
					local d = xd * xd + yd * yd
					
					if d < dist then
						self.target = v
						dist = d
					end
				end
			end
			
			if self.target == nil then
				local olddir
				if self.wanderx == 0 and self.wandery == 0 then
					olddir = math.random() * math.pi * 2
				else
					olddir = math.atan2( self.wandery, self.wanderx )
				end
				local wanderdir = olddir + ( math.random() - 0.5 ) * math.pi / 8
				local speed = self.walkspeed * ( math.random() * 0.75 + 0.25 )
				self.wanderx = math.cos( wanderdir ) * speed
				self.wandery = math.sin( wanderdir ) * speed
			end
		end
		
		if self.target ~= nil then
			local xd, yd = self:getDiffEnt( self.target )
			if math.abs( xd ) <= 1 and math.abs( yd ) <= 1 then
				self.target:remove()
				local zomb = entity.create( "zombie" )
				zomb:setPosition( self.target:getPosition() )
				zomb:spawn()
				self.target = nil
			else
				self:setMovement( mul( self.walkspeed, normalize( xd, yd ) ) )
			end
		else
			self:setMovement( self.wanderx, self.wandery )
		end
		self.animspeed = self.walkspeed
	end
	
	ENT.baseclass.update( self, dt )
end

function ENT:toString()
	return self.baseclass.toString( self ) .. ",\n health: 100"
end

entity.register( ENT )
