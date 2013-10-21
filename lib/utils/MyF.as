package utils {
import flash.display.DisplayObject;
//import away3d.core.math.*;
import away3d.materials.*;
import away3d.core.base.*;

public class MyF {
/*
public function MyF() {
}
*/
public static function random(minNum:Number, maxNum:Number, round:Boolean = true):Number {

 if(minNum < 0) {
	var posMin:Number = (minNum*-1);
	var range:Number = posMin+maxNum;
	if(round) { return Math.floor(Math.random() * (range - 1))-posMin; }
	else { return Math.random() * (range - 1)-posMin; }
	} else {
		if(round) { return Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum; }
			else { return Math.random() * (maxNum - minNum + 1) + minNum; }
		}
	}

 public static function moveToTop(child:DisplayObject):void{  
   (child.parent != null) ? child.parent.setChildIndex(child, child.parent.numChildren-1) : null;
 }
 //-----------------------away-------------------------------
  public static function getMeshByName(m:Array,nm:String=""):Mesh {//--my
		 var L:uint=m.length;
		 for (var i:uint=0; i < L; i++) 
		 	 if (m[i].name == nm) { return m[i];}
		 return null; 
 }
 public static function setMaterialToAllMesh(m:Array,mat:Material=null):void {
			var L:uint=m.length;
		    for (var i:uint=0; i < L; i++) {
				m[i].material=mat;
			}
 }
 }
}