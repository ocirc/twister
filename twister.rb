#OK a] 4pts.pdb	# 4 atomy wokó³ pionowej osi
# b] wczytywanie pdb i wypisywanie wspó³rzêdnych
require "bio"
require "optparse"
require "./rotmatrix.rb"

class Coords
	attr_accessor :x, :y, :z
	def initialize(x,y,z)
	  @x=x; @y=y; @z=z
	end
	def to_s
	  "(%.3f, %.3f, %.3f)" % [x,y,z]
	end
	# przenosi os swobodna z Y na Z (i z powrotem)
	def switchYZ
		@y,@z=@z,@y
		return self
	end
	def switchYX
		@y,@x=@x,@y
		return self
	end
	
	def to_polar
		# atan2 bierze pod uwage cwiartke ukladu wspolrzednych
		Cpolar.new(Math.sqrt(x**2+z**2), Math.atan2(z,x), y)
	end
end

class Cpolar
	attr_accessor :r, :ang, :y
	def initialize(r,ang,y)
	  @r=r; @ang=ang; @y=y
	end
	def to_s
	  "<%.3f, %.3f, %.3f>" % [r,ang,y]
	end
	def to_coords
		Coords.new(Math.cos(ang)*r, y, Math.sin(ang)*r)
	end
end
#c=Coords.new(1,2,3)
#puts c.to_polar
#puts c.to_polar.to_coords
#exit

#c=coords.new(1,2,3)
#puts c.to_s
USEINFO=!true

def info(msg)
	puts msg if USEINFO
end

options = {}
OptionParser.new do |opts|
	options[:i] = "4pts.pdb"
	options[:a] = 0.0
	options[:o] = "out.pdb"
	
	opts.on( '-i [%s]' % options[:i], "input pdb file") do |s|
		options[:i] = s
	end
	opts.on( '-a [%s]' % options[:a], "angle, deg") do |a|
		options[:a] = Float(a) #rescue 0.0
	end
	opts.on( '-o [%s]' % options[:o], "output pdb file") do |o|
		options[:o] = o
	end
end.parse!

info "[*] Using file '%s' as input."%options[:i]
s=Bio::PDB.new(File.new(options[:i]).gets(nil))

atoms1={}
s.atoms.each {|a|
	atoms1[a.serial]=Coords.new(a.x, a.y, a.z)
	}

#puts atoms1.inspect	#prints structure (lista tez)

# wprowadzenie zmian
# *czy to bezpieczne? spr id obiektow
#myatoms.each {|serial, xyz|
#	myatoms[serial]=Coords.new(xyz.x/2,xyz.y*2,xyz.z/2)
#	}
#puts myatoms.inspect

# > tutaj jest juz zaktualizowana struktura
# c] zapisywanie pdb
class Bio::PDB
	def sv(fname)
		File.open(fname, 'w').write(self.to_s)
		puts "Saved struct to %s."%fname
	end
	def updateatoms(newatoms)
	newatoms.each {|serial, xyz|
		self.atoms.each {|a|
			if serial==a.serial
				a.x, a.y, a.z = xyz.x, xyz.y, xyz.z
				break
			end
			}
		}
	puts "Updated."
	end
end


# d] wizualizacja (pymol non-iteractive, albo znaleŸæ inny renderer pdb)
#hop
def switchYX(myatoms)
	myatoms.each {|serial, xyz|
		xyz.switchYX
		}
	return myatoms
end


def rotateAtoms(myatoms, angle)
	# e] transformacja do wspó³rzêdnych pó³polarnych (r=x^2+z^2; a=atan(z/x))
	# f] obrót wszystkiego o jednakowy k¹t
	#  ] transformacja powrotna
	
	myatoms.each {|serial, xyz|
		pol=xyz.to_polar
		pol.ang+=angle
		xyz1=pol.to_coords
		myatoms[serial]=xyz1
		}
	return myatoms
end


#atoms2=rotateAtoms(atoms1,options[:a]*Math::PI/180.0)
#s.updateatoms(atoms2)
#s.sv(options[:o])
a=Matrix.column_vector([1,1,1])
b=Matrix.column_vector([0,1,0])
puts rotmatrix(a,5)


#g] normalizacja wspó³rzêdnych Y (koniec_A = 1.0, koniec_B=-1.0; 0 w œrodku odleg³oœci, |y_cor|>1.0 dla atomów dalszych ni¿ koñce)
#h] obrót o k¹t zale¿ny od y_cor (w³aœciwa transformacja)
# ] <MATEMATYKA: jaki typ funkcji przejœcia (k¹t(y_cor)) bêdzie najlepszy (liniowy, exp, tan, x^3,...?)>
#i] odnajdywanie osi
#j] normalizacja i denormalizacja Y


