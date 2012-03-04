local ENT = {}

ENT.classname = "crate"
ENT.basename = "prop"

ENT.image = graphics.newImage( "res/crate1.png" )
ENT.imageoffsetx = -4
ENT.imageoffsety = -8

function ENT:initialize()
	self:setBBSize( 1, 1 )
	
	ENT.baseclass.initialize( self )
end

entity.register( ENT )
