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
	
	world.initialize( 40, 30 )
	entity.initialize()
	
	camera.setSize( 40, 30 )
	
	world.generate()
end

function love.keypressed( key )
	if key == "escape" then
		love.event.push( "q" )
	end
end

function love.update( dt )	
	if love.keyboard.isDown( " " ) then
		dt = dt * 4
	end
	
	if love.keyboard.isDown( "w" ) then
		camera.y = camera.y - dt * 16
	end
	if love.keyboard.isDown( "s" ) then
		camera.y = camera.y + dt * 16
	end
	if love.keyboard.isDown( "a" ) then
		camera.x = camera.x - dt * 16
	end
	if love.keyboard.isDown( "d" ) then
		camera.x = camera.x + dt * 16
	end
	
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
