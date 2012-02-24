#OK a] 4pts.pdb	# 4 atomy wokó³ pionowej osi
# b] wczytywanie pdb i wypisywanie wspó³rzêdnych
require "bio"
require "optparse"
require "./rotmatrix.rb"

USEINFO=!true

def info(msg)
	puts msg if USEINFO
end
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
				a.x, a.y, a.z = xyz[0,0], xyz[1,0], xyz[2,0]
				break
			end
			}
		}
	puts "Updated."
	end
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
	atoms1[a.serial]=Matrix.column_vector([a.x, a.y, a.z])
	}

# zbieramy atomy do wyznaczania prostych
# ..1 sa blizej N-konca
# atom-a1... etc
aa1=s[nil]['A']['1']['C4\'']
aa2=s[nil]['A']['20']['C4\'']

ab1=s[nil]['B']['40']['C4\'']
ab2=s[nil]['B']['21']['C4\'']

a1=Matrix.column_vector([aa1.x,aa1.y,aa1.z])
a2=Matrix.column_vector([aa2.x,aa2.y,aa2.z])
b1=Matrix.column_vector([ab1.x,ab1.y,ab1.z])
b2=Matrix.column_vector([ab2.x,ab2.y,ab2.z])

m1=(a1+b1)/2
m2=(a2+b2)/2
mm=(m1+m2)/2


[a1,a2,b1,b2,mm].each do |v| 
	#puts vec2str(v)
	end

puts "Wspolrzedne srodka: %s." % vec2str(mm)
# translacja mm do <0,0,0>, odejmowanie wektorow kolumnowych

puts "Translacja do (0,0,0)"
atoms2={}
atoms1.each do |serial,xyz|
	atoms2[serial] = xyz-mm
end
puts "[Zebranie wspolrzednych atomow szkieletowych po translacji]"

#korekta wektorow (translated-a1,etc)
ta1=atoms2[aa1.serial]
ta2=atoms2[aa2.serial]
tb1=atoms2[ab1.serial]
tb2=atoms2[ab2.serial]

tm1=(ta1+tb1)/2
tm2=(ta2+tb2)/2
tmm=(tm1+tm2)/2
puts "Wspolrzedne srodka po translacji: %s." % vec2str(tmm)
# wektor kierunkowy DNA
# ..1 jest na gorze (konwencja)
dir=(tm1-tm2)
dir=dir/cveclen(dir)	#normalizacja
puts "Znorm. wektor kierunkowy DNA: " + vec2str(dir)
yaxis=Matrix.column_vector([0,1,0])
if dir==yaxis
	puts "Wektor zgodny z osia OY... O_o nic nie obracam"
else
	puts "[Obliczanie osi obrotu do korekty Y (il. wektorowy z [010])]"
	rotaxis=cprod(dir,yaxis)
	rotaxis=rotaxis/cveclen(rotaxis)	#norm
	puts "Znormalizowana os obrotu: " + vec2str(rotaxis)
	puts "[Obliczanie kata obrotu do korekty Y]"
	rotang=Math.acos(dprod(dir,yaxis)/(cveclen(dir)*cveclen(yaxis)))
	# cveclen(dir)*cveclen(yaxis) zawsze ==1  (normalizacja)
	#rotang=Math.acos(dprod(dir,yaxis))
	puts "Kat obrotu: %.3f rad (%.3f deg)." %[rotang, rotang*180.0/Math::PI]
	m_rot=rotmatrix(rotaxis, rotang)
	m_unrot=rotmatrix(rotaxis, -rotang)
	puts "Macierz obrotu: " 
	puts m_rot
	puts "Przekszt. odwrotne: "
	puts m_unrot
	
	puts "Obrot -> atoms3"
	atoms3={}
	atoms2.each do |serial,xyz|
		atoms3[serial] = m_rot*xyz
	end
	puts "Obrocono."

	
end
exit
# wyznaczanie osi obrotu (cross-product, chcemy obrocic sie na os y)
# wyznaczanie kata obrotu (dot-product)


s.updateatoms(atoms2)
s.sv(options[:o])

exit
	
	
#puts atoms1.inspect	#prints structure (lista tez)

# wprowadzenie zmian
# *czy to bezpieczne? spr id obiektow
#myatoms.each {|serial, xyz|
#	myatoms[serial]=Coords.new(xyz.x/2,xyz.y*2,xyz.z/2)
#	}
#puts myatoms.inspect

# > tutaj jest juz zaktualizowana struktura



#atoms2=rotateAtoms(atoms1,options[:a]*Math::PI/180.0)
#s.updateatoms(atoms2)
#s.sv(options[:o])

#puts s.atoms.inspect
#puts s.atoms.search {|a| a["name"]=='C4' && a["resSeq"]==1}

#g] normalizacja wspó³rzêdnych Y (koniec_A = 1.0, koniec_B=-1.0; 0 w œrodku odleg³oœci, |y_cor|>1.0 dla atomów dalszych ni¿ koñce)
#h] obrót o k¹t zale¿ny od y_cor (w³aœciwa transformacja)
# ] <MATEMATYKA: jaki typ funkcji przejœcia (k¹t(y_cor)) bêdzie najlepszy (liniowy, exp, tan, x^3,...?)>
#i] odnajdywanie osi
#j] normalizacja i denormalizacja Y


