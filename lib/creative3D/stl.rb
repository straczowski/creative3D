require "gmath3D"
include GMath3D

class STL

	#Important to end with the /
	@workspace = ""

	def set_workspace(workspace_path)
		raise StandardError, "workspace Path is no String" if (workspace_path.nil? || !(workspace_path.kind_of? String))

		if workspace_path[-1, 1] != "/"
			workspace_path = workspace_path + "/"
		end

		@workspace = workspace_path		
	end

	# params is a Hash Array
	# :filename => <String>, :mesh => <TriMesh>, :format => :ascii 
	def write(params = {})
		
		raise StandardError, "argument :filename is nil or not a String" if (params[:filename].nil? || !(params[:filename].kind_of? String))
		raise StandardError, "argument :mesh is nil or not a kind of TriMesh" if (params[:mesh].nil? || !(params[:mesh].kind_of? TriMesh))

		name 	  = params[:filename]
		triangles = params[:mesh].triangles
		format    = params[:format]

		File.open( (@workspace+name+".stl") , 'w') do |file|

			if format == :ascii
				file.puts "solid #{name}"
				
				triangles.each do | t |
					#Vectornormal
					n = t.normal
					file.puts ("    facet normal " + n.x.to_s + " " + n.y.to_s + " " + n.z.to_s )

					#Vertices
					file.puts "\touter loop"
					t.vertices.each do | v |
						file.puts ("\t    vertex " + v.x.to_s + " " + v.y.to_s + " " + v.z.to_s)
					end

					file.puts "\tendloop"
					file.puts '    endfacet'
				end
				file.puts 'endsolid'
			else 
				file.write 'STL #{name}'.ljust(80, "\0")
				file.write [triangles.length].pack('V')	

				triangles.each do | t |
				    file.write t.normal.to_ary.pack("FFF")

				    t.vertices.each do | v |
						file.write v.to_ary.pack("FFF")
				    end
				    file.write "\0\0"
				end
			end

		end
	end	


	class Float # Helper method
	  def self.from_sn str # generate a float from scientific notation
	    ("%f" % str).to_f
	  end
	end
	#params is Hash Array
	#:filename => <String>, 
	def read(params = {})
		name = params[:filename]
		data = Array.new

		file = File.new((@workspace+name+".stl") , 'r')
		
		aLine = file.gets
		if aLine.include? "solid"
			while line = file.gets
			    next if line =~ /^\s*$/ or line.include? 'endsolid' 
			    line.sub! /facet normal/, ''
			    normal = line.split(' ').map{ |num| Float.from_sn num }
			    line = file.gets # outer loop

			    line = file.gets
			    a = line.sub(/vertex/, '').split(' ').map{ |num| ("%f" % num).to_f }
			    line = file.gets
			    b = line.sub(/vertex/, '').split(' ').map{ |num| ("%f" % num).to_f }
			    line = file.gets
			    c = line.sub(/vertex/, '').split(' ').map{ |num| ("%f" % num).to_f }

			    line = file.gets #endsolid
			    line = file.gets #endfacet

			    #puts "Hier: " + a.to_s + " " + normal.to_s
			    data << {:normal => normal, :vertices => [a, b, c]}
			end
		else
			file.seek(80, IO::SEEK_SET)
		    triCount = file.read(4).unpack('V')[0]
		    triCount.times do |triNdx|
		      normal = file.read(12).unpack('FFF')
		      a = file.read(12).unpack('FFF')
		      b = file.read(12).unpack('FFF')
		      c = file.read(12).unpack('FFF')
		      file.seek(2, IO::SEEK_CUR)
		      data << {:normal => normal, :vertices => [a, b, c]}
		    end
		end
		convert_for_gmath3D data
	end

private
	def convert_for_gmath3D(data)	
		vecs     = Array.new
		indicies = Array.new 

		data.each do | face |
			n = face[:normal]
			v = face[:vertices]
			ori_normal = Vector3.new n[0], n[1], n[2]
			face_indicies = Array.new 

			#Check Normal
			temp_tri = Triangle.new(
				Vector3.new(v[0][0], v[0][1], v[0][2]),
				Vector3.new(v[1][0], v[1][1], v[1][2]),
				Vector3.new(v[2][0], v[2][1], v[2][2])
			)
			temp_n  = temp_tri.normal
			temp_rn = temp_tri.reverse.normal
			if( temp_n.distance(ori_normal) > temp_rn.distance(ori_normal) )
				#Sequence is wrong! Swap
				v[1], v[2] = v[2], v[1]
			end

			#Eliminate Redundant
			v.each do | vertex |  # 3.times
				new_vec = Vector3.new vertex[0], vertex[1], vertex[2]
				vec_index = nil
				if not vecs.empty?					
					strike = false
					#Compare with existing vecs
					vecs.each_with_index do | existing_vec, i |
						if existing_vec == new_vec #strike
							vec_index = i
							strike = true
						end
						break if strike #Don't have to search anymore
					end
					if not strike
						vecs << new_vec 
						vec_index = vecs.length - 1
					end
				else
					#first Vector, only!
					vecs << new_vec
					vec_index = 0
				end
				face_indicies << vec_index
			end

			indicies << face_indicies

		end

		return TriMesh.new vecs, indicies
	end

end