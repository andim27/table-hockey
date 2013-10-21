package katok { 
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class VectorMy extends Object{
		
		public var deltaX:Number;
		public var deltaY:Number;
		private var thisParent:Sprite;
		public var x:Number;
		public var y:Number;
		
		// constructor
		public function VectorMy(posX:Number, posY:Number, dX:Number, dY:Number){
			reset(posX, posY, dX, dY);
		}
		
		
		//////// SET ////////
		
		// reset the Vector given 
		public function reset(posX:Number, posY:Number, dX:Number, dY:Number):void{
			x = posX;
			y = posY;
			deltaX = new Number(dX);
			deltaY = new Number(dY);
		}
		
		// reset the Vector given another vector (alternative to reset())
		public function resetFromVector(v:VectorMy):void{
			x = v.x;
			y = v.y;
			deltaX = v.deltaX;
			deltaY = v.deltaY;
		}
		
		// set a reference to the parent of this Vector
		public function setThisParent(parent:Sprite):void{
			thisParent = parent;
		}
		
		// reset the Vector given a length and an angle
		public function setPolar(l:Number, a:Number):void{
			var newDeltas:Point = Point.polar(l, degToRad(a));
			reset(x, y, newDeltas.x, newDeltas.y);
		}
		
		// reset the Vector given a length
		public function setLength(l:Number):void{
			var newDeltas:Point = Point.polar(l, degToRad(getAngle()));
			reset(x, y, newDeltas.x, newDeltas.y);
		}
		
		// set Vector to a given angle
		public function setAngle(newAngle:Number):void{
			var newDeltas:Point = Point.polar(getLength(), degToRad(newAngle));
			reset(x, y, newDeltas.x, newDeltas.y);
		}
		
		// rotate by a given number of degrees
		public function rotate(degrees:Number):void{
			var len:Number = getLength();
			var angle:Number = getAngle();
			deltaX = len*Math.cos( degToRad(angle + degrees));
			deltaY = len*Math.sin( degToRad(angle + degrees));
		}
		
		
		//////// GET ////////
		
		// length in pixels
		public function getLength():Number{
			return Math.sqrt(deltaX*deltaX + deltaY*deltaY);
		}
		
		// angle in degrees
		public function getAngle():Number{
			return Math.atan2(deltaY, deltaX)*180/Math.PI;
		}
		
		// angle in radians
		public function getAngleRad():Number{
			return degToRad(this.getAngle());
		}
		
		// unit vector
		public function unit():VectorMy {
			var len:Number = getLength();
			if(len == 0){len = 1};
			return new VectorMy(x, y, deltaX/len, deltaY/len); 
		}
		
		// right hand normal (perpendicular vector)
		public function normalRight():VectorMy { 
			var vR:VectorMy = new VectorMy(x, y, 0, 0);
			vR.setPolar(getLength(), getAngle()+90);
			return vR;
		}
		
		// left hand normal (perpendicular vector)
		public function normalLeft():VectorMy {
			var vL:VectorMy = new VectorMy(x, y, 0, 0);
			vL.setPolar(getLength(), getAngle()-90);
			return vL;
		}
		
		// 
		public function getEndpoint():Point{
			return new Point(x + deltaX, y + deltaY);
		}
		
		//////// MATH ////////
		
		public function sum(v:VectorMy):VectorMy {
			return new VectorMy(x, y, deltaX+v.deltaX, deltaY +v.deltaY);
		}
		
		public function difference(v:VectorMy):VectorMy {
			return new VectorMy(x, y, deltaX-v.deltaX, deltaY-v.deltaY);
		}
		
		public function dotProduct(v:VectorMy):Number{
			return deltaX*v.unit().deltaX + deltaY*v.unit().deltaY;
		}
		
		// project onto another given vector
		public function project(v:VectorMy):VectorMy{
			var dp:Number = dotProduct(v);
			return new VectorMy(v.x, v.y, dp*v.unit().deltaX, dp*v.unit().deltaY);
		}
		
		private function perP(va:VectorMy, vb:VectorMy):Number{
			return va.deltaX*vb.deltaY - va.deltaY * vb.deltaX;
		}
		
		public function degToRad(degrees:Number):Number{
			return degrees*Math.PI/180;
		}
		
		
		//////// COLLISIONS ////////
		
		// where do these vectors intersect 
		public function getIntersection(v:VectorMy):Point{
			var v3:VectorMy = new VectorMy(0, 0, v.x-x, v.y-y);
			var t:Number = perP(v3, v)/perP(this, v);
			return new Point(x+deltaX*t, y+deltaY*t);
		}
		
		// is point p on the vector (between start and end points)?
		public function intersectsWith(p:Point):Boolean{
			var startToP:VectorMy = new VectorMy(x, y, p.x -x, p.y - y);
			var endPoint:Point = getEndpoint();
			var endToP:VectorMy  = new VectorMy(endPoint.x, endPoint.y, p.x - endPoint.x, p.y - endPoint.y);
			return ( Math.round( endToP.getLength() + startToP.getLength() ) == Math.round(this.getLength()) );
		}
		
		//////// REPORTING ////////
		
		public function vectorToString():String{
			return ('x: ' + x + ', y: ' + y + ', deltaX: ' + deltaX + ', deltaY ' + deltaY + ', length: ' + getLength());
		}
		
	}
	
	
	
}