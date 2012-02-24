require 'optparse'

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
	opts.on( '-o [%s]' % options[:o], "output pdb file") do |s|
		options[:o] = o
	end
end.parse!

p options
p ARGV