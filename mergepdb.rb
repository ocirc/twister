#mergepdb
filenames=Dir.glob("roty*.pdb")
#puts files
fo=File.new("merge.pdb", 'w')
i=0
filenames.each {|fn|	
	s="MODEL %i\n" % i
	i+=1
	s+=File.new(fn,'r').gets(nil).gsub("END\n","")
	s+="ENDMDL\n"
	fo.write(s)
	}
fo.close