#OK a] 4pts.pdb	# 4 atomy wokó³ pionowej osi
# b] wczytywanie pdb i wypisywanie wspó³rzêdnych
require "bio"
s=Bio::PDB.new(File.new('4pts.pdb').gets(nil))
class Coords
	attr_accessor :x, :y, :z
	def initialize(x,y,z)
	  @x=x; @y=y; @z=z
	end
	def to_s
	  "(%.3f, %.3f, %.3f)" % [x,y,z]
	end
	def to_polar
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
		Coords.new(Math.cos(ang)*r,y,Math.sin(ang)*r)
	end
end
#c=Coords.new(1,2,3)
#puts c.to_polar
#puts c.to_polar.to_coords
#exit

#c=coords.new(1,2,3)
#puts c.to_s

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
# e] transformacja do wspó³rzêdnych pó³polarnych (r=x^2+z^2; a=atan(z/x))
def rotateAtoms(myatoms, angle)
	mypolar={}
	myatoms.each {|serial, xyz|
		x,y,z=xyz.x,xyz.y,xyz.z
		# atan2 bierze pod uwage cwiartke ukladu wspolrzednych
		mypolar[serial]=Cpolar.new(Math.sqrt(x**2+z**2), Math.atan2(z,x), y)
		}
	#f] obrót wszystkiego o jednakowy k¹t
	mypolar.each {|serial, crds|
		crds.ang+=angle
		mypolar[serial]=crds
		}
	puts mypolar
	# transformacja powrotna
	myatoms2={}
	mypolar.each {|serial, crds|
		z=Math.sin(crds.ang)*crds.r
		x=Math.cos(crds.ang)*crds.r
		myatoms2[serial]=Coords.new(x,crds.y,z)
		}
	return myatoms2
end

s.updateatoms(myatoms2)
s.sv('out.pdb')

#g] normalizacja wspó³rzêdnych Y (koniec_A = 1.0, koniec_B=-1.0; 0 w œrodku odleg³oœci, |y_cor|>1.0 dla atomów dalszych ni¿ koñce)
#h] obrót o k¹t zale¿ny od y_cor (w³aœciwa transformacja)
# ] <MATEMATYKA: jaki typ funkcji przejœcia (k¹t(y_cor)) bêdzie najlepszy (liniowy, exp, tan, x^3,...?)>
#i] odnajdywanie osi
#j] normalizacja i denormalizacja Y


