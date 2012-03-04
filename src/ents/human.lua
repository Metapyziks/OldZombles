local ENT = {}

ENT.classname = "human"
ENT.basename = "character"

ENT.animimage = graphics.newImage( "res/human.png" )

ENT.running = false

ENT.fleefromx = 0
ENT.fleefromy = 0

ENT.lastthink = 0
ENT.thinkinterval = 0.25

function ENT:initialize()
	local speedmul = math.random() * 0.5 + 0.75
	
	self.tiredspeed = 0.75 * speedmul
	self.walkspeed = 1 * speedmul
	self.runspeed = 3 * speedmul
	
	self.maxstamina = 3 + math.random() * 4
	self.stamina = self.maxstamina
	
	self.fleeradius = 4 + math.random() * 6
	self.runradius = 2 + math.random() * 4
	
	self.recoverrate = 1 / 3
	
	ENT.baseclass.initialize( self )
end

function ENT:update( dt )
	if getTime() - self.lastthink > self.thinkinterval then
		self.lastthink = getTime() + math.random() * self.thinkinterval
		local near = world.getNearbyEnts( self, 8 )
		self.fleefromx = 0
		self.fleefromy = 0
		for k, v in ipairs( near ) do
			if v.classname == "zombie" then
				local xdiff, ydiff = self:getDiffEnt( v )
				
				local dist2 = xdiff * xdiff + ydiff * ydiff
				
				if dist2 > 0 and dist2 < 8 * 8 then
					self.fleefromx = self.fleefromx + xdiff / dist2
					self.fleefromy = self.fleefromy + ydiff / dist2
					if dist2 < self.runradius * self.runradius then
						self:startRunning()
					end
				end
			end
		end
		
		if self.fleefromx == 0 and self.fleefromy == 0 then
			self.fleefromx = math.random() * 2 - 1
			self.fleefromy = math.random() * 2 - 1
		end
	end
	
	if self.running then
		if self.stamina <= 0 then
			self:stopRunning()
		else
			self:setMovement( mul( self.runspeed,
				normalize( -self.fleefromx, -self.fleefromy ) ) )
			self.animspeed = self.runspeed
			self.stamina = math.max( 0, self.stamina - dt )
		end
	end
	
	if not self.running then
		if self.stamina < self.maxstamina then
			self:setMovement( mul( self.tiredspeed,
				normalize( -self.fleefromx, -self.fleefromy ) ) )
			self.animspeed = self.tiredspeed
			self.stamina = math.min( self.maxstamina, self.stamina
				+ dt * self.recoverrate )
		else
			self:setMovement( mul( self.walkspeed,
				normalize( -self.fleefromx, -self.fleefromy ) ) )
			self.animspeed = self.walkspeed
		end
	end
	
	ENT.baseclass.update( self, dt )
end

function ENT:canRun()
	return not self.running and self.stamina > self.maxstamina / 2
end

function ENT:startRunning()
	if self:canRun() then
		self.running = true
		self.stamina = self.stamina - 0.5
	end
end

function ENT:stopRunning()
	self.running = false
end

function ENT:toString()
	return self.baseclass.toString( self ) .. ",\n health: 100"
end

entity.register( ENT )
