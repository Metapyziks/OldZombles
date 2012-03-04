graphics = love.graphics
getTime = love.timer.getTime

math.randomseed( getTime() )
for i = 1, 12 do
	math.random()
end

function table.removeValue( t, val )
	for k, v in ipairs( t ) do
		if v == val then
			table.remove( t, k )
			return
		end
	end
end

function normalize( x, y )
	if x == 0 and y == 0 then
		return 0, 0
	end
	
	local len = math.sqrt( x * x + y * y )
	
	return x / len, y / len
end

function mul( z, x, y )

	return x * z, y * z
end

dofile( "src/camera.lua" )
dofile( "src/world.lua" )
dofile( "src/entity.lua" )

local fb

function love.load()
	graphics.setMode( 640, 480, false, false, 1 )
	--graphics.toggleFullscreen()
	
	fb = graphics.newFramebuffer( 320, 240 )
	fb:setFilter( "nearest", "nearest" )
	
	world.initialize( 128, 128 )
	entity.initialize()
	
	camera.setSize( 40, 30 )
	camera.setPosition( 20, 15 )
	
	world.generate()
end

function love.keypressed( key )
	if key == "escape" then
		love.event.push( "q" )
	end
end

function love.mousepressed( x, y, button )
	x = math.floor( ( x / 2 ) / 8 + camera.x - camera.hwid )
	y = math.floor( ( y / 2 ) / 8 + camera.y - camera.hhei )
	local ents = world.getEntsInBounds( x, y, 1, 1 )
	if button == "l" and #ents == 0 then
		print( "Placing crate at " .. x .. ", " .. y )
		local prop = entity.create( "crate" )
		prop:setPosition( x + 0.5, y + 0.5 )
		prop:spawn()
	elseif button == "r" then
		for _, ent in ipairs( ents ) do
			if ent.classname == "crate" then
				ent:remove()
			end
		end
	end
end

function love.update( dt )	
	if love.keyboard.isDown( " " ) then
		dt = dt * 4
	end
	
	local x, y = camera.getPosition()
	
	if love.keyboard.isDown( "w" ) then
		y = y - dt * 16
	end
	if love.keyboard.isDown( "s" ) then
		y = y + dt * 16
	end
	if love.keyboard.isDown( "a" ) then
		x = x - dt * 16
	end
	if love.keyboard.isDown( "d" ) then
		x = x + dt * 16
	end
	
	camera.setPosition( x, y )
	
	for k, v in ipairs( world.entities ) do
		v:update( dt )
	end
end

function love.draw()
	graphics.setRenderTarget( fb )
	world.depthSortInBounds( camera.getBounds() )
	for k, v in ipairs( world.getEntsInBounds( camera.getBounds() ) ) do
		v:draw()
	end
	graphics.setRenderTarget()
	graphics.draw( fb, 0, 0, 0, 2, 2 )
end
