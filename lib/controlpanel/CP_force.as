package controlpanel
{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.filters.BitmapFilterQuality;
import com.greensock.*;
import com.greensock.easing.*;

import events.CPEvents;
import controlpanel.OpenSlider;


public class  CP_force extends CP_forcesym {	
 public var s_conf:Object;

 //public var up_many_btn : SimpleButton;
 //public var rslider_mc : RoundSlider;
 public var vslider_mc :OpenSlider;
 //public var vsliderBtn:MovieClip;
 //public var vsliderLine:MovieClip;
 public var force_cur : int=1;
 public var force_min: int;
 public var force_max : int;
 private var first_x:int;
 private var first_y:int;
 
 public function  CP_force(s_c:Object,x1:int,y1:int,f_min:int,f_max:int,f_cur:int):void {		
	     s_conf=s_c;						
		 first_x=x1;
		 first_y=y1;
		 force_min=f_min;
		 force_max=f_max;
		 force_cur=f_cur;
	     initVars();
	     //this.parent.addChild(this);
		 //s_conf.main.cp_cell_control_mc.start_mc.addChild(this);
 }
	 protected  function initVars():void {
		visible=false;
		hint_mc.visible=false; 
		this.x=first_x;
		this.y=first_y;
		this["hint_mc"].filters = [new DropShadowFilter(10,45,0x000000,0.8,8,8,0.65,BitmapFilterQuality.HIGH,false,false)];
		this["hint_mc"].visible=false;		
		initSlider();
	 }
	 public function firstShow():void {
		 this.x=s_conf.stage.width*0.25;//first_x;
		 this.y=first_y;//s_conf.stage.height*0.25;
		 this.alpha=0;
		 s_conf.stage.addChild(this);
		 visible=true;		
		 TweenLite.to(this,4,{y:first_y,x:first_x,delay:0.5,alpha:100,ease:Elastic.easeOut});
	 }
     protected  function initSlider():void {
	    vslider_mc = new OpenSlider(vsliderBtn,vsliderLine);
		vslider_mc.addEventListener(Event.CHANGE,onVSliderChange);
		vsliderBtn.addEventListener(MouseEvent.MOUSE_OVER, onvsliderBtnDown);
		vsliderBtn.addEventListener(MouseEvent.MOUSE_OUT, onvsliderBtnUp);
		vsliderBtn.addEventListener(MouseEvent.MOUSE_UP, onvsliderBtnUp);
		vsliderBtn.addEventListener(Event.MOUSE_LEAVE, onvsliderBtnUp);
		vsliderBtn.addEventListener(MouseEvent.MOUSE_MOVE, onvsliderBtnMove);
		vslider_mc.name = "VSlider_force";
		vslider_mc.setRange(force_min,force_max);		
		vslider_mc.value = force_cur;
		vslider_mc.percent=force_cur*(force_max-force_min)/100;
		hint_mc.x=vsliderBtn.x;
		//vsliderBtn.y=vsliderLine.y+vsliderBtn.width;//---т.к не работает начальная установка ползунка
	 }
	 public function Increase():void {
		if (vslider_mc.value <= vslider_mc.max) {
			vslider_mc.value++;
		}
		var max_x:int=vsliderLine.x+vsliderLine.width/2;
		if (vsliderBtn.x > max_x) {vsliderBtn.x=max_x;}
	 }
	 public function Decrease():void {
	    if (vslider_mc.value >= vslider_mc.min) {
			vslider_mc.value--;
		}
		var min_x:int=vsliderLine.x-vsliderLine.width/2;
		if (vsliderBtn.x < min_x) {vsliderBtn.x=min_x;}
	 }
	 //--------------------------------Event--------------
	 protected function onvsliderBtnMove(e:MouseEvent):void {
		 onVSliderChange(null);
	 }
	 protected function onvsliderBtnDown(e:MouseEvent):void {
		hint_mc.visible=true;
	 }
	 protected function onvsliderBtnUp(e:MouseEvent):void {
		hint_mc.visible=false; 
	 }
	 protected function onVSliderChange(e:Event=null):void {
		var force_val:int= int(vslider_mc.value);//int(e.target.value);
		hint_mc.visible=true;
		hint_mc.x=vsliderBtn.x;
		hint_mc.mes_txt.text="Force: "+force_val;	 
	    s_conf.main.shayba.setForce(force_val);	 
	 }

	


	
}
}