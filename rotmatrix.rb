require 'matrix'
require 'pp'

#a=Matrix.column_vector([1,1,1])
#b=Matrix.column_vector([0,1,0])

#x=Matrix.column_vector([1,0,0])
#y=Matrix.column_vector([0,1,0])
#z=Matrix.column_vector([0,0,1])

def cveclen(u)
	Math.sqrt(u[0,0]**2+u[1,0]**2+u[2,0]**2)
end

def vec2str(u)
	"vec(%.3f,%.3f,%.3f)" % [u[0,0],u[1,0],u[2,0]]
end 
class Matrix
	def pprint
		PP.pp self
	end
end

def rotmatrix(u_in,ang)
	#normalizacja u_in
	u = u_in / cveclen(u_in)
	c=Math.cos(ang)
	t=(1-c)
	s=Math.sin(ang)
	x,y,z=u[0,0],u[1,0],u[2,0]
	
Matrix[
	[c+t*x**2,  x*y*t-z*s, x*z*t+y*s],
	[x*y*t+z*s, c+y**2*t,  y*z*t-x*s],
	[z*x*t-y*s, z*y*t+x*s, c+z**2*t]
	]
end



def cprod(a,b)
	Matrix.column_vector([
	a[1,0]*b[2,0]-a[2,0]*b[1,0],
	a[0,0]*b[2,0]-a[2,0]*b[0,0],
	a[0,0]*b[1,0]-a[1,0]*b[0,0]
	])
end

def dprod(a,b)
	a[0,0]*b[0,0] + a[1,0]*b[1,0] + a[2,0]*b[2,0]
end

#m=rotmatrix(y, 90*Math::PI/180.0)




