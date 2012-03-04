camera = {}

camera.x = 0
camera.y = 0

camera.width = 1
camera.height = 1

camera.hwid = 0.5
camera.hhei = 0.5

function camera.setSize( width, height )
	camera.width = width
	camera.height = height
	camera.hwid = width / 2
	camera.hhei = height / 2
end

function camera.setPosition( x, y )
	if x < 0 then x = x + world.width
	elseif x >= world.width then x = x - world.width end
	if y < 0 then y = y + world.height
	elseif y >= world.height then y = y - world.height end
	
	camera.x = x
	camera.y = y
end

function camera.getPosition()
	return camera.x, camera.y
end

function camera.getBounds()
	return camera.x - camera.hwid, camera.y - camera.hhei, camera.width, camera.height
end