
#require 'matrix'

class Extrude < TriMesh

	#@tpolygon = Array.new
	@ttriangle = Array.new(3)
	@ttriangles = Array.new 

	def initialize (vecs, params={})

	end

	class TriNode
		attr_accessor :x
		attr_accessor :y
		attr_accessor :index
		def initialize (x,y,index)
			@x = x
			@y = y
			@index = index
		end
	end

	def self.triangulate tpolygon
		lst = Array.new
		atriangles = Array.new

		#lst = tpolygon.clone
		tpolygon.each_with_index do| v, i|
			lst << (TriNode.new v.x, v.y, i)
		end

		puts "Start triangulate"

		i = 0
		lastear = -1
		while (lastear <= lst.length*2) and (lst.length != 3)   ##repeat
			lastear = lastear + 1

			p1 = lst[Extrude.get_item(i-1, lst.length)]
			p  = lst[Extrude.get_item(i  , lst.length)]
			p2 = lst[Extrude.get_item(i+1, lst.length)]

			l = ((p1.x - p.x) * (p2.y - p.y) - (p1.y - p.y) * (p2.x - p.x))

			#puts "lastear = " + lastear.to_s
			#puts "l = " + l.to_s + " on pos " + i.to_s

			if l > 0 
				in_triangle = false
				2.upto(lst.length) do | j |
					pt = lst[Extrude.get_item( i+j , lst.length)]
					if Extrude.point_in_traingle(pt, p1, p, p2)
						in_triangle = true
						#puts "p" + p.index.to_s + " in Triangle " + p1.index.to_s + p.index.to_s + p2.index.to_s 
					end
				end

				#puts "Not in triangle" if not in_triangle

				if not in_triangle 
					#SetLength(ATriangles, Length(ATriangles) + 1);
					atriangles << Array.new(3)
			        atriangles.last[0] = p1.index #Extrude.get_item(i-1, lst.length) #Vector3.new(p1.x, p1.y, 0);
			        atriangles.last[1] = p.index  #Extrude.get_item(i  , lst.length) #Vector3.new(p.x, p.y, 0);
			        atriangles.last[2] = p2.index #Extrude.get_item(i+1, lst.length) #Vector3.new(p2.x, p2.y, 0);
			 		
			 		#puts "count i = " + i.to_s
			        
			        lst.delete_at(Extrude.get_item(i, lst.length))
			 
			        lastear = 0
			 
			        i = i-1
				end

			end
			i = i + 1
			i = 0 if i > (lst.length)
		end
		
		if lst.length == 3
			p1 = lst[Extrude.get_item(0, lst.length)]
			p  = lst[Extrude.get_item(1, lst.length)]
			p2 = lst[Extrude.get_item(2, lst.length)]
			atriangles << Array.new(3)
	        atriangles.last[0] = p1.index #Extrude.get_item(i-1, lst.length) #Vector3.new(p1.x, p1.y, 0);
	        atriangles.last[1] = p.index  #Extrude.get_item(i  , lst.length) #Vector3.new(p.x, p.y, 0);
	        atriangles.last[2] = p2.index #Extrude.get_item(i+1, lst.length) #Vector3.new(p2.x, p2.y, 0);
		end

		atriangles
	end

	def self.get_item(ai, amax)
		result = ai % amax
		result = amax + result if result < 0
		return result
	end

	def self.point_in_traingle(pt, v1, v2, v3)
		b1 = (Extrude.sign(pt, v1, v2) < 0)
		b2 = (Extrude.sign(pt, v2, v3) < 0)
		b3 = (Extrude.sign(pt, v3, v1) < 0)

		return ((b1 == b2) && (b2 == b3))
	end

	def self.sign(p1, p2, p3)
		return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
	end
	
end
