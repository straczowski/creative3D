# install creaive3D
# and execute this file from your Console:
# $ ruby house.rb

require 'creative3D'


stl = STL.new
stl.set_workspace("C:/ruby3d/exampleSTL/") # Define your workspace here

cube = Cuboid.new :width => 5, :height => 2, :depth => 10

roof = Extrude.new [[0,0], [3,3], [6,0]], :height => 10
roof = translate roof, :x => -0.5, :y => 2

chimney = Cylinder.new :height => 5, :radius => 0.5
chimney = rotate chimney, :axis => :x, :degree => -90, :vector => Vector3.new(0,0,0)
chimney = translate chimney, :x => 1, :z => 1.5

stl.write :filename => "house", :mesh => [cube, roof, chimney] 