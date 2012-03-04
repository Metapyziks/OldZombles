local ENT = {}

ENT.classname = "prop"
ENT.basename = "entity"

ENT.image = nil
ENT.imageoffsetx = 0
ENT.imageoffsety = 0

ENT.solid = true

function ENT:draw()
	if self.image ~= nil then
		local x, y = self:getScreenPos()
		x = x + self.imageoffsetx
		y = y + self.imageoffsety
		graphics.draw( self.image, x, y )
	end
end

entity.register( ENT )
