local ENT = {}

ENT.classname = "character"
ENT.basename = "moveable"

ENT.animimage = nil
ENT.framequads = {
	{
		graphics.newQuad( 00, 00, 4, 8, 16, 40 ),
		graphics.newQuad( 04, 00, 4, 8, 16, 40 ),
		graphics.newQuad( 08, 00, 4, 8, 16, 40 ),
		graphics.newQuad( 12, 00, 4, 8, 16, 40 )
	},
	{
		graphics.newQuad( 00, 08, 4, 8, 16, 40 ),
		graphics.newQuad( 04, 08, 4, 8, 16, 40 ),
		graphics.newQuad( 08, 08, 4, 8, 16, 40 ),
		graphics.newQuad( 12, 08, 4, 8, 16, 40 )
	},
	{
		graphics.newQuad( 00, 16, 4, 8, 16, 40 ),
		graphics.newQuad( 04, 16, 4, 8, 16, 40 ),
		graphics.newQuad( 08, 16, 4, 8, 16, 40 ),
		graphics.newQuad( 12, 16, 4, 8, 16, 40 )
	},
	{
		graphics.newQuad( 00, 24, 4, 8, 16, 40 ),
		graphics.newQuad( 04, 24, 4, 8, 16, 40 ),
		graphics.newQuad( 08, 24, 4, 8, 16, 40 ),
		graphics.newQuad( 12, 24, 4, 8, 16, 40 )
	},
	{
		graphics.newQuad( 00, 32, 4, 8, 16, 40 ),
		graphics.newQuad( 04, 32, 4, 8, 16, 40 ),
		graphics.newQuad( 08, 32, 4, 8, 16, 40 ),
		graphics.newQuad( 12, 32, 4, 8, 16, 40 )
	}
}

ENT.animspeed = 1

ENT.solid = true

function ENT:initialize()
	self:setBBSize( 0.5, 0.25 )
	
	ENT.baseclass.initialize( self )
end

function ENT:draw()
	if self.animimage ~= nil then
		local x, y = self:getScreenPos()
		x = x - 2
		y = y - 6
		local frame = math.floor( ( getTime() - self.spawntime )
			* 4 * self.animspeed ) % 4 + 1
		graphics.drawq( self.animimage, self.framequads[ self.movedir + 1 ][ frame ], x, y )
	end
end

entity.register( ENT )
