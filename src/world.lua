ENT_GRID_RES = 4

world = {}

world.width = 0
world.height = 0

world.gridwidth = 0
world.gridheight = 0

world.entities = {}
world.entgrid = {}

function world.initialize( width, height )
	world.width = width
	world.height = height
	
	world.entities = {}
	world.entgrid = {}
	
	world.gridwidth = math.ceil( width / ENT_GRID_RES )
	world.gridheight = math.ceil( height / ENT_GRID_RES )
	
	for i = 1, world.gridwidth do
		world.entgrid[ i ] = {}
		for j = 1, world.gridheight do
			world.entgrid[ i ][ j ] = {}
		end
	end
end

function world.generate()
	for i = 1, 1024 do
		local x, y = math.random( world.width ), math.random( world.height )
		local ent
		if i <= 1020 then
			ent = entity.create( "human" )
		else
			ent = entity.create( "zombie" )
		end
		ent:setPosition( x + 0.5, y + 0.5 )
		ent:spawn()
	end
	for i = 1, 512 do
		local x, y = math.random( world.width ), math.random( world.height )
		local ents = world.getEntsInBounds( x, y, 1, 1 )
		if #ents == 0 then
			local prop = entity.create( "crate" )
			prop:setPosition( x + 0.5, y + 0.5 )
			prop:spawn()
		else
			i = i - 1
		end
	end
end

function world.addEntity( ent )
	table.insert( world.entities, ent )
	local x, y = ent:getEntGridPosition()
	table.insert( world.entgrid[ x ][ y ], ent )
end

function world.removeEntity( ent )
	table.removeValue( world.entities, ent )
	local x, y = ent:getEntGridPosition()
	table.removeValue( world.entgrid[ x ][ y ], ent )
end

function world.updateEntity( ent )
	local x1, y1 = ent:getEntGridPosition()
	ent:updateGridPosition()
	x2, y2 = ent:getEntGridPosition()
	if x1 ~= x2 or y1 ~= y2 then
		table.removeValue( world.entgrid[ x1 ][ y1 ], ent )
		table.insert( world.entgrid[ x2 ][ y2 ], ent )
	end
end

function world.depthSortInBounds( x, y, width, height )
	local gix, giy = math.floor( x / ENT_GRID_RES ) + 1,
					 math.floor( y / ENT_GRID_RES ) + 1
	local gax, gay = math.ceil( ( x + width ) / ENT_GRID_RES ),
					 math.ceil( ( y + height ) / ENT_GRID_RES )
	
	for i = gix, gax do
		for j = giy, gay do
			local k = ( i - 1 ) % world.gridwidth + 1
			local l = ( j - 1 ) % world.gridheight + 1
			table.sort( world.entgrid[ k ][ l ],
				function( a, b ) return a.y + a.bbhei / 2 < b.y + b.bbhei / 2 end )
		end
	end
end

function world.getEntsInBounds( x, y, width, height )
	local gix, giy = math.floor( x / ENT_GRID_RES ) + 1,
					 math.floor( y / ENT_GRID_RES ) + 1
	local gax, gay = math.ceil( ( x + width ) / ENT_GRID_RES ),
					 math.ceil( ( y + height ) / ENT_GRID_RES )
	
	local ents = {}
		
	local maxx = x + width
	local maxy = y + height
	
	local hwid = width / 2
	local hhei = height / 2
	
	local midx = x + hwid
	local midy = y + hhei
	
	for i = gix, gax do
		for j = giy, gay do
			local k = ( i - 1 ) % world.gridwidth + 1
			local l = ( j - 1 ) % world.gridheight + 1
			for _, ent in ipairs( world.entgrid[ k ][ l ] ) do
				local dmx, dmy = ent:getDiffPos( midx, midy )
				if math.abs( dmx ) < hwid and math.abs( dmy ) < hhei then
					table.insert( ents, ent )
				end
			end
		end
	end
	
	return ents
end

function world.getNearbyEnts( entity, radius )
	local x, y = entity:getPosition()
	x = x - radius
	y = y - radius
	return world.getEntsInBounds( x, y, radius * 2, radius * 2 )
end
