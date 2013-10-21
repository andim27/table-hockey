package controlpanel
{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.filters.BitmapFilterQuality;
//import events.CPEvents;
//import man.Man;
import controlpanel.OpenSlider;
import away3d.core.base.*;
import away3d.core.math.Number3D;

import com.greensock.*;
import com.greensock.easing.*;

public class  CP_camera extends CP_camerasym {	
 public var s_conf:Object;
 public var cur_state:String;		
 public var vslider_1_mc :OpenSlider;
 public var vslider_2_mc :OpenSlider;
 public var dist:int;//---distance to center katok
 private var first_x:int;
 private var first_y:int;
 //private var vsliderBtn_1:MovieClip;
 //private var vsliderBtn_2:MovieClip;
 //private var vsliderLine_1:MovieClip;
 //private var vsliderLine_2:MovieClip;

 public function  CP_camera(s_c:Object,x1:int,y1:int):void {		
	     //this.filters = [new BlurFilter(32, 32)];
		 this.filters = [new DropShadowFilter(10,45,0x000000,0.8,8,8,0.65,BitmapFilterQuality.HIGH,false,false)];
		 s_conf=s_c;
		 initEvents();
		 initVars();		
		 x=first_x=x1;
		 y=first_y=y1;
		 cameraCommand(0);
 }
	 protected  function initVars():void {
		cur_state="pos_0";
		visible=false;
		dist=int(s_conf.main.kt.ice_L*8);
		initSliders();
	 }
	 public function firstShow():void {
		 visible = false;
		 s_conf.stage.addChild(this);		 
		 return;
		 //visible = true;
		 //this.x=first_x;
		 //this.y=-200;
		 //this.alpha=0;
		 //TweenLite.to(this,4,{y:first_y,x:first_x,delay:0.5,alpha:100,ease:Elastic.easeOut});
	 }
	 protected  function initSliders():void {
	    var dist_min:int=dist/1.5;
		var dist_max:int=dist*1.5;
		vslider_1_mc = new OpenSlider(vsliderBtn_1,vsliderLine_1);
		vslider_1_mc.addEventListener(Event.CHANGE,onVSlider_1_Change);
		vslider_1_mc.name = "VSlider_zoom";
		vslider_1_mc.value = dist;//s_conf.main.view.camera.zoom;		
		vslider_1_mc.setRange(dist_min,dist_max);
		vslider_1_mc.percent=int(dist/dist_max);
		
		
		vslider_2_mc = new OpenSlider(vsliderBtn_2,vsliderLine_2);
		vslider_2_mc.addEventListener(Event.CHANGE,onVSlider_2_Change);
		vslider_2_mc.name = "VSlider_pan";
		vslider_2_mc.setRange(-60,60);		
		vslider_2_mc.value = 0;
		//vsliderBtn.y=vsliderLine.y+vsliderBtn.width;//---т.к не работает начальная установка ползунка
	 }
	 protected function onVSlider_1_Change(e:Event):void {
	   s_conf.main.view.camera.distance = int(e.target.value);
	   s_conf.main.overlapControl();	
       //s_conf.main.view.camera.hover(true);
	   //trace("CAMERA distance is "+int(e.target.value));
	 }
	 protected function onVSlider_2_Change(e:Event):void {
	   //s_conf.main.shayba.setForce(int(e.target.value));
	   s_conf.main.view.camera.panAngle=int(e.target.value);
	   s_conf.main.view.camera.distance = s_conf.main.view.camera.distance;
	   s_conf.main.overlapControl();	
	   //s_conf.main.view.camera.hover(true);
	   //s_conf.main.view.render();
	   //trace("CAMERA panAngle is "+int(e.target.value));
	 }
	 protected  function initEvents():void {	
		pos_0_btn.addEventListener(MouseEvent.CLICK,onClickGO);		
		pos_1_btn.addEventListener(MouseEvent.CLICK,onClickGO);
		pos_2_btn.addEventListener(MouseEvent.CLICK,onClickGO);		
		//pos_3_btn.addEventListener(MouseEvent.CLICK,onClickGO);		
	 }


	 protected  function onClickGO(e:Event):void {	
		 switch (e.target.name) {
			  case "pos_0_btn":			  
			   cameraCommand(0);
			   cur_state="pos_0";
			   break;	
			 case "pos_1_btn":
			   cameraCommand(1);
			   cur_state="pos_1";
			   break;
		     case "pos_2_btn":
			   //trace("down_btn");			  
			   cameraCommand(2);
			   cur_state="pos_2";
			   break;
		     case "pos_3_btn":			   			   
			   cameraCommand(3);
			   cur_state="pos_3";
			   break;					
		 }		
		
	 }
	protected function cameraCommand(pos_n:int):void {
		var see_obj:Object3D = s_conf.main.kt.center;// new Object3D( { x: -s_conf.main.kt.ice_W, y:s_conf.main.kt.model.y, z:int(s_conf.main.kt.ice_L / 2) } );
	   
		s_conf.main.view.camera.x=-s_conf.main.kt.ice_W;
		s_conf.main.view.camera.z=s_conf.main.kt.ice_L;
		switch (pos_n) {
			  case 0:			
			    s_conf.main.view.camera.panAngle=0;//45;
				s_conf.main.view.camera.tiltAngle=10;//20;
				s_conf.main.view.camera.target=see_obj;
				s_conf.main.view.camera.distance =dist;
				s_conf.main.overlapControl();								
				s_conf.main.view.camera.hover(true);
				break;
			  case 1:
			    s_conf.main.view.camera.panAngle=45;//45;
				s_conf.main.view.camera.tiltAngle=10;//20;
				s_conf.main.view.camera.target=see_obj;
				s_conf.main.view.camera.distance = dist;
				s_conf.main.overlapControl();	
				s_conf.main.view.camera.hover(true);

			   break;
			  case 2:
			    s_conf.main.view.camera.panAngle=-45;//45;
				s_conf.main.view.camera.tiltAngle=10;//20;
				s_conf.main.view.camera.target=see_obj;
				s_conf.main.view.camera.distance = dist;
				s_conf.main.overlapControl();	
				s_conf.main.view.camera.hover(true);				
			    break;
			  case 3:
			    s_conf.main.view.camera.panAngle=0;//45;
				s_conf.main.view.camera.tiltAngle=5;//20;
				s_conf.main.view.camera.target=s_conf.main.vorota_2.model;
				s_conf.main.view.camera.distance = dist / 2;
				s_conf.main.overlapControl();	
				s_conf.main.view.camera.hover(true);
				s_conf.main.cp_cell_control_mc.setCellsVisible((s_conf.main.cp_cell_control_mc.cells_visible == true?false:true));
			    break;
		}
	}

	
}
}