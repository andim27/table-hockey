package controlpanel 
{
import flash.display.*;
import flash.events.Event;
import flash.events.MouseEvent;
import events.CPEvents;

public class  RoundSlider extends MovieClip  {	

public var s_conf:Object;
private var rX:Number;
private var rY:Number;
private var numItems:Number;
private var zeroSector:Object;
private var s_rect_w:int;
private var s_rect_h:int;
private var myEllipse:Sprite;
private var bntMc:Sprite;
private var cont_mc:MovieClip;//--контейнер-владелец слайдера
public function  RoundSlider (s_c:Object) {		
	s_conf=s_c;
	initVars(); 	
	initMain();
	initEvents();
}
protected function initVars():void {
 	rX = this.width/2;//35;
	rY = this.width/2;//35;
	s_rect_w=14;
	s_rect_h=9;
 	numItems  = 12;
	zeroSector = sector(0, rX, rY);
	cont_mc = s_conf.main.cp_cell_control_mc.kick_mc;
}
protected  function initEvents():void {
		
  	//addEventListener(MouseEvent.MOUSE_DOWN,onSliderDown);
  	//addEventListener(MouseEvent.MOUSE_UP,onSliderUp);
  	//addEventListener(Event.ENTER_FRAME,onSliderEnterFrame);

}
protected function initMain():void {
	// draw ellipse
myEllipse = new Sprite();
myEllipse.x = 0;//this.width/2;//275;
myEllipse.y = 0;//this.height/2;//200;
myEllipse.graphics.lineStyle(0, 0x0033CC);
myEllipse.graphics.moveTo(zeroSector.x, zeroSector.y); 

for (var d:int = 0; d <= 360; d += 5) {
    var _sector:Object = sector(d, rX, rY);
    myEllipse.graphics.lineTo(_sector.x, _sector.y);
}
// create draggalbe clip
bntMc = new Sprite();
//bntMc.graphics.lineStyle(12, 0x002277, 100);
//bntMc.graphics.lineTo(0, 1);
///bntMc.graphics.beginFill(0xFFCC00);
///bntMc.graphics.drawCircle(0, 0, 9);
///bntMc.graphics.beginFill(0x3912DC);
///bntMc.graphics.drawCircle(0, 0, 7);
bntMc.graphics.beginFill(0x3912DC);
bntMc.graphics.drawRect(-(s_rect_h/2), 0, s_rect_w, s_rect_h);

bntMc.x = zeroSector.x;
bntMc.y = zeroSector.y;
bntMc.buttonMode = true;

myEllipse.addChild(bntMc);
addChild(myEllipse);

bntMc.addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
cont_mc.addEventListener(MouseEvent.MOUSE_UP, doMouseOut);

}
private function sector(degree:Number, radiusX:Number, radiusY:Number):Object {
    // coordinates of a point on ellipse
    var xpos:Number = radiusX * Math.cos(degree * Math.PI / 180);
    var ypos:Number = radiusY * Math.sin(degree * Math.PI / 180);
    
    // find the angle that has the Y-coords of the mouse position, solve for angle somehow...
    return {x:xpos, y:ypos};
}


private function objPosition():void { // detecting coordinates of a clip 
        var ratio:Number = rX / rY;
        var anAngle:Number = Math.atan2(mouseX - myEllipse.x, mouseY - myEllipse.y );
        var deg:Number = 90-(Math.atan2(Math.sin(anAngle), Math.cos(anAngle) * ratio)) * (180 / Math.PI);        
        var _sector:Object = sector(deg, rX, rY);       
        bntMc.x = _sector.x;
        bntMc.y = _sector.y;
		bntMc.rotation=deg;
		var objEvent:CPEvents=new CPEvents(CPEvents.MAN_CONTROL);
	    objEvent.event_label="rotate";  	   
  	    objEvent.event_value=String(deg);
		this.dispatchEvent(objEvent);
		trace("Parent ="+parent.name+" Name="+name+" deg="+deg)
}


private function doMouseDown(event:MouseEvent):void  {
   cont_mc.addEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);         
};

private function  doMouseOut (event:MouseEvent):void {
   cont_mc.removeEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
 };

private function doMouseMove(event:MouseEvent):void {
     objPosition();
 }
}
}