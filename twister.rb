#OK a] 4pts.pdb	# 4 atomy wokó³ pionowej osi
# b] wczytywanie pdb i wypisywanie wspó³rzêdnych
require "bio"
s=Bio::PDB.new(File.new('4pts.pdb').gets(nil))
myatoms={}
class Coords
	attr_accessor :x, :y, :z
	def initialize(x,y,z)
	  @x=x; @y=y; @z=z
	end
	def to_s
	  "(%.3f, %.3f, %.3f)" % [x,y,z]
	end
end

class Cpolar
	attr_accessor :r, :ang
end

#c=coords.new(1,2,3)
#puts c.to_s

s.atoms.each {|a|
	myatoms[a.serial]=Coords.new(a.x, a.y, a.z)
	}

#puts myatoms.inspect	#prints structure (lista tez)

# wprowadzenie zmian
# *czy to bezpieczne? spr id obiektow
myatoms.each {|serial, xyz|
	myatoms[serial]=Coords.new(xyz.x/2,xyz.y*2,xyz.z/2)
	}
puts myatoms.inspect
# c] zapisywanie pdb
myatoms.each {|serial, xyz|
	s.atoms.each {|a|
		if serial==a.serial
			a.x, a.y, a.z = xyz.x, xyz.y, xyz.z
			break
		end
		}
	}
# > tutaj jest juz zaktualizowana struktura
File.open('out.pdb', 'w').write(s.to_s)

# d] wizualizacja (pymol non-iteractive, albo znaleŸæ inny renderer pdb)
# e] transformacja do wspó³rzêdnych pó³polarnych (r=x^2+z^2; a=atan(z/x))
#f] obrót wszystkiego o jednakowy k¹t
#g] normalizacja wspó³rzêdnych Y (koniec_A = 1.0, koniec_B=-1.0; 0 w œrodku odleg³oœci, |y_cor|>1.0 dla atomów dalszych ni¿ koñce)
#h] obrót o k¹t zale¿ny od y_cor (w³aœciwa transformacja)
# ] <MATEMATYKA: jaki typ funkcji przejœcia (k¹t(y_cor)) bêdzie najlepszy (liniowy, exp, tan, x^3,...?)>
#i] odnajdywanie osi
#j] normalizacja i denormalizacja Y
