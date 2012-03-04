local ENT = {}

ENT.classname = "moveable"
ENT.basename = "entity"

ENT.movex = 0
ENT.movey = 0
ENT.movedir = 1

function ENT:initialize()
	self:setBBSize( 0.5, 0.25 )
	
	ENT.baseclass.initialize( self )
end

function ENT:setMovement( x, y )
	self.movex = x
	self.movey = y
	if x ~= 0 and y ~= 0 then
		self.movedir = math.ceil( math.atan2( y, x ) / math.pi * 2 + 1.5 )
		if self.movedir == 0 then
			self.movedir = 4
		end
	end
end

function ENT:update( dt )
	if self.movex ~= 0 or self.movey ~= 0 then
		local dx = self.movex * dt
		local dy = self.movey * dt
		
		if self.solid then
			local bsl, bst, bsr, bsb = self:getBBBounds()
			
			local ents = world.getEntsInBounds(
				bsl + math.min( dx, 0 ) - 1,
				bst + math.min( dy, 0 ) - 1,
				self.bbwid + math.abs( dx ) + 2,
				self.bbhei + math.abs( dy ) + 2 )
			
			for k, ent in ipairs( ents ) do
				if ent ~= self and ent.solid then
					local bel, bet, ber, beb = ent:getBBBounds()
					if dx > 0 and bel > bsr and bel < bsr + dx then
						local ndx = bsr - bel
						local mul = ndx / dx
						local ndy = mul * dy
						if bst + ndy < beb and bsb + ndy > bet then
							dx = ndx
							--dy = ndy
						end
					elseif dx < 0 and ber < bsl and ber > bsl + dx then
						local ndx = bsl - ber
						local mul = ndx / dx
						local ndy = mul * dy
						if bst + ndy < beb and bsb + ndy > bet then
							dx = ndx
							--dy = ndy
						end
					end
					if dy > 0 and bet > bsb and bet < bsb + dy then
						local ndy = bsb - bet
						local mul = ndy / dy
						local ndx = mul * dx
						if bsl + ndx < ber and bsr + ndx > bel then
							--dx = ndx
							dy = ndy
						end
					elseif dy < 0 and beb < bst and beb > bst + dy then
						local ndy = bst - beb
						local mul = ndy / dy
						local ndx = mul * dx
						if bsl + ndx < ber and bsr + ndx > bel then
							--dx = ndx
							dy = ndy
						end
					end
				end
			end
			
			self.x = self.x + dx
			self.y = self.y + dy
		end
	end
	self:setMovement( 0, 0 )
	
	ENT.baseclass.update( self, dt )
end

entity.register( ENT )
