# install creaive3D
# and execute this file from your Console:
# $ ruby spring.rb

require 'creative3D'

@meshes = Array.new
stl = STL.new
stl.set_workspace("C:/ruby3d/exampleSTL/") # Define your workspace here

def build_branch(x, y, z, axis, n)
	if n <= 10 
		r = Math.sqrt(x*x + y*y + z*z)
		theta = Math.atan2( Math.sqrt(x*x + y*y), z )
		phi = Math.atan2(y, x)

		newx = r**n * Math.sin(theta*n) * Math.cos(phi*n)
		newy = r**n * Math.sin(theta*n) * Math.sin(phi*n)
		newz = r**n * Math.cos(theta*n)

		vec = Vector3.new(newx, newy, newz)
		s = Sphere.new :position => vec
		s = scale s, :factor => (1+(n*0.5))
		s = translate s, :z => n*5
		s = rotate s, :axis => axis, :degree => n*10, :vector => Vector3.new(0,0,0)
		@meshes << s

		build_branch(newx, newy, newz, axis, n+1)
	end
end

build_branch(10, 0, 0, :x, 0)

clone = @meshes.clone
(360/20).times do |i|
	clone.each do | sphere |
		@meshes << (rotate sphere, :axis => :z, :degree => (20*i), :vector => Vector3.new(0,0,0))
	end
end

stl.write :filename => "spring", :mesh => @meshes

