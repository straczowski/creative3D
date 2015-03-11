# install creaive3D
# and execute this file from your Console:
# $ ruby hyperboloid.rb

require 'creative3D'


stl = STL.new
stl.set_workspace("C:/ruby3d/exampleSTL/") # Define your workspace here

meshes = Array.new

zero_vec = Vector3.new(0, 0, 0)

vec1 = Vector3.new 3, -1, 0
vec2 = Vector3.new -1,  2, 10
line = FiniteLine.new vec2, vec1

10.times do |i|
	poly = Stick.new line
	poly = rotate poly, :axis => :z, :degree => -(360/10*i), :vector => zero_vec
	meshes << poly
end

stl.write :filename => "hyperboloid", :mesh => meshes