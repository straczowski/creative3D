require "gmath3D"
include GMath3D

require "creative3D/version"
require "creative3D/transform"
require "creative3D/stl"

require "creative3D/primitives/cuboid"
require "creative3D/primitives/cylinder"
require "creative3D/primitives/sphere"
require "creative3D/primitives/cone"
require "creative3D/primitives/stick"
require "creative3D/primitives/extrude"
require "creative3D/primitives/rform"

module Creative3D

	def self.version
		Creative3D::VERSION
	end	

end

# $ gem build creative3D.gemspec
# $ gem install creative3D-0.0.1.gem