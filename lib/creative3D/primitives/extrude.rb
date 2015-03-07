
#require 'matrix'

class Extrude < TriMesh


	def initialize (vecs2, params={})

		z = params[:height].nil? ? 1 : params[:height]

		vertices = Array.new
		vecs2.each do |v|
			vertices << (Vector3.new v[0], v[1], 0)
		end

		j = vecs2.length
		indices = triangulate vecs2

		vecs2.each do |v|
			vertices << (Vector3.new v[0], v[1], z)
		end

		
		clone = indices.clone
		clone.each_with_index do |index, i|
			#Back
			indices << [index[0]+j, index[2]+j, index[1]+j]
		end
		vecs2.each_with_index do |v,i|
			if( i == j-1)
				indices << [i, 0, j+i]
				indices << [0, j, j+i]
			else
				indices << [i,   i+1,   j+i]
				indices << [i+1, j+i+1, j+i] 
			end
		end

		super(vertices, indices)
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

	def triangulate vecs2
		lst = Array.new
		atriangles = Array.new

		vecs2.each_with_index do| v, i|
			lst << (TriNode.new v[0], v[1], i)
		end

		i = 0
		lastear = -1
		while (lastear <= lst.length*2) and (lst.length != 3)   ##repeat
			lastear = lastear + 1

			p1 = lst[get_item(i-1, lst.length)]
			p  = lst[get_item(i  , lst.length)]
			p2 = lst[get_item(i+1, lst.length)]

			l = ((p1.x - p.x) * (p2.y - p.y) - (p1.y - p.y) * (p2.x - p.x))

			if l > 0 
				in_triangle = false
				2.upto(lst.length) do | j |
					pt = lst[get_item( i+j , lst.length)]
					if point_in_traingle(pt, p1, p, p2)
						in_triangle = true
					end
				end

				if not in_triangle 
					atriangles << Array.new(3)
			        atriangles.last[0] = p1.index 
			        atriangles.last[1] = p.index  
			        atriangles.last[2] = p2.index 
			        
			        lst.delete_at(get_item(i, lst.length))
			 
			        lastear = 0
			 
			        i = i-1
				end

			end
			i = i + 1
			i = 0 if i > (lst.length)
		end
		
		if lst.length == 3
			p1 = lst[get_item(0, lst.length)]
			p  = lst[get_item(1, lst.length)]
			p2 = lst[get_item(2, lst.length)]
			atriangles << Array.new(3)
	        atriangles.last[0] = p1.index 
	        atriangles.last[1] = p.index  
	        atriangles.last[2] = p2.index 
		end

		atriangles
	end

	def get_item(ai, amax)
		result = ai % amax
		result = amax + result if result < 0
		return result
	end

	def point_in_traingle(pt, v1, v2, v3)
		b1 = (sign(pt, v1, v2) < 0)
		b2 = (sign(pt, v2, v3) < 0)
		b3 = (sign(pt, v3, v1) < 0)

		return ((b1 == b2) && (b2 == b3))
	end

	def sign(p1, p2, p3)
		return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
	end

end
