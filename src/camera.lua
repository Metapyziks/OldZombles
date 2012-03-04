camera = {}

camera.x = 0
camera.y = 0

camera.width = 1
camera.height = 1

function camera.setSize( width, height )
	camera.width = width
	camera.height = height
end

function camera.getBounds()
	return camera.x, camera.y, camera.width, camera.height
end