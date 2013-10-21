package controlpanel
{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.*;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat; 

import events.CPEvents;
import man.Man;
import controlpanel.OpenSlider;
import utils.CMD;

import com.greensock.*;
import com.greensock.easing.*;


public class  CP_cell extends CP_cellsym {	
 public var s_conf:Object;
 private var up_step:int;
 private var up_step_many:int;
 private var down_step:int;
 private var down_step_many:int;
 private var left_step:int;
 private var right_step:int;
 private var slider_prev_val:int;

// public var up_btn : SimpleButton;
// public var down_btn : SimpleButton;
// public var stop_btn : SimpleButton;
// public var rot_left_btn : SimpleButton;
// public var rot_right_btn : SimpleButton;
// public var shoot_btn : SimpleButton;

 //public var up_many_btn : SimpleButton;
 //public var rslider_mc : RoundSlider;
 public var vslider_mc :OpenSlider;
 //public var vsliderBtn:MovieClip;
 //public var vsliderLine:MovieClip;
 public var active:Boolean;
 public var nomer : int;
 private var first_x:int;
 private var first_y:int;
 private var nomer_field:TextField ;

 public function  CP_cell(s_c:Object,x1:int,y1:int,n:int):void {		
	     visible=false;
		 s_conf=s_c;
		 nomer=n;
		 first_x=x1;
		 first_y=y1;
		 initEvents();
		 initVars();
		 //firstShow(first_x,first_y);		
		 //trace("CP_cell x1="+x1+" y1="+y1+" nomer="+nomer);
 }
	 protected  function initVars():void {
		active=false;
		this["shoot_btn"].visible=false;
		this["vsliderLine"].visible=false;
		up_step   = 10;
		down_step = 10;		
		
		nomer_field = new TextField();
		var text_format:TextFormat = new TextFormat();
		text_format.size = 18;
        text_format.underline = false;
        text_format.bold = true;
		nomer_field.type = TextFieldType.DYNAMIC;
		nomer_field.border = false;
		nomer_field.x = this.width*0.18;
		nomer_field.y = -this.height*0.35;
		if (( nomer == 4) || (nomer == 5) ) { //--vratar--
		    //initVratarView();
			nomer_field.x = this.width*0.3;
		    nomer_field.y = -this.height*0.35;
			this["cell_fon_mc"].scaleX=-this["cell_fon_mc"].scaleX;
			this["vsliderLine"].x=-9;
			this["vsliderBtn"].scaleX=-this["vsliderBtn"].scaleX;
			this["rot_left_btn"].y=this["rot_left_btn"].y+this.height*0.1;
			this["rot_right_btn"].y=this["rot_right_btn"].y-this.height*0.1;
			this["shoot_btn"].x=this.width*0.4;
		}
						
		nomer_field.width = this.width*0.25;
        nomer_field.height =this.height*0.2;
		nomer_field.textColor=0xFFFFFF;
		nomer_field.multiline = false;
		nomer_field.wordWrap = false;
		nomer_field.selectable=false; 
		nomer_field.text=String(nomer);
		nomer_field.setTextFormat(text_format);
		addChild(nomer_field);
		//trace("theTextField.text="+nomer_field.text);
		//this["nomer_mc"].text=nomer;
		initSlider();		
		//addChild(new CPCellClass());
	 }
	 public function firstShow():void {
		 if ((nomer == 4)||(nomer == 5)) {//--- справа показать
			 this.x=s_conf.stage.stageWidth*1.25;		 
		 } else { //--слева показать
		 	 this.x=-s_conf.stage.stageWidth;//first_x;
		 }
		 this.y=first_y;//s_conf.stage.stageHeight+this.height;
		 this.alpha=0;
		 s_conf.stage.addChild(this);
		 visible=true;
		 //trace("CELL first show "+nomer);
		 TweenLite.to(this,2,{y:first_y,x:first_x,delay:0.2,alpha:100,ease:Elastic.easeIn,onComplete:onFirstShowDone});
	 }
	 private function onFirstShowDone():void {
		 if (nomer == 1) {
			 s_conf.main.cp_cell_control_mc.cell_items[1].firstShow();		 			 
		 }
		 if (nomer == 2) {
			 s_conf.main.cp_cell_control_mc.cell_items[2].firstShow();		 			 
		 }
		 if (nomer == 3) { //--vratar he has't callball
			 s_conf.main.cp_cell_control_mc.cell_items[3].firstShow();		 			 
			 s_conf.main.cp_cell_control_mc.cell_items[4].firstShow();		 			 
		 }
		 if (nomer == 4) {
			 s_conf.main.cp_cell_control_mc.cell_items[5].firstShow();		 			 
		 }
		 if (nomer == 5) {
			 //s_conf.main.cp_cell_control_mc.force_mc.firstShow();
			 s_conf.main.cp_cell_control_mc.setClipsDeepth();
		 }
		  
	 }
	 public function setShootVisible(n:int,vis:Boolean):void {
	 	this["shoot_btn"].visible=vis;
		nomer_field.visible=(this["shoot_btn"].visible == true)?false:true;
		
	 }
     protected  function initSlider():void {
	    vslider_mc = new OpenSlider(vsliderBtn,vsliderLine);
		vslider_mc.addEventListener(Event.CHANGE,onVSliderChange);
		vsliderBtn.addEventListener(MouseEvent.MOUSE_OVER,onVSliderBtnSet);
		
		vslider_mc.name = "VSlider_"+nomer;
		//trace("Init slider max="+s_conf.main.kt.ice_L);
		//vslider_mc.setRange(1,int(s_conf.main.kt.ice_L*0.96));//s_conf.main.kt.ice_L
		var cell_man:Object = s_conf.main.team_1.getMan(nomer);
		var max_val:int=s_conf.main.team_1.getMan(nomer).max_z;
		var min_val:int=s_conf.main.team_1.getMan(nomer).min_z;
		vslider_mc.setRange(min_val,max_val);
		vslider_mc.value = cell_man.model.z; //((max_val-min_val)/2)+min_val;//int(s_conf.main.kt.ice_L*0.5);
		slider_prev_val = vslider_mc.value;
		vsliderBtn.x=vsliderLine.x;
		vsliderBtn.y = vsliderLine.y + vsliderLine.height * 0.5;
		onVSliderBtnSet(null);
	 }
	 protected  function initEvents():void {

		addEventListener(MouseEvent.MOUSE_OVER,onActive);
		addEventListener(MouseEvent.MOUSE_OUT,onDeActive);
		s_conf.stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
		
		up_btn.addEventListener(MouseEvent.CLICK,onClickGO);		
		down_btn.addEventListener(MouseEvent.CLICK,onClickGO);
		stop_btn.addEventListener(MouseEvent.CLICK,onClickGO);		
		rot_left_btn.addEventListener(MouseEvent.CLICK,onClickGO);
		rot_right_btn.addEventListener(MouseEvent.CLICK,onClickGO);		
		shoot_btn.addEventListener(MouseEvent.CLICK,onClickGO);
		
	 }
	 protected function initVratarView():void {
	    vslider_mc.setRange(-20,20);
		vsliderLine.height=this.width-20;
		vsliderLine.rotate=-90;
		vsliderBtn.rotate=-90;
		//vsliderLine.y=this.height-20;		
		vsliderLine.x=10;
		vsliderBtn.y=vsliderLine.y;
		vsliderBtn.x=vsliderLine.y;
	 }
	public function sliderCommand(cmd:uint):void {
		var nomer_man:Man = s_conf.main.team_1.getMan(nomer);
		var ps:int=3;
		var step:Number=(ps*(Math.abs(vslider_mc.max-vslider_mc.min))/100);
		var step_sliderBtn:int;
		//var ps_man:int = (nomer_man.model.z - nomer_man.min_z) * (nomer_man.max_z - nomer_man.min_z) / 100;
		//var dY_slider:int = int((ps_man * vsliderLine.height) / 100);
		step_sliderBtn = (vsliderLine.height*(nomer_man.model.z - nomer_man.min_z) )/(nomer_man.max_z - nomer_man.min_z);
		//trace("step_sliderBtn=" + step_sliderBtn + " model.z=" + nomer_man.model.z + " max_z=" + nomer_man.max_z + " min_z=" + nomer_man.min_z);
		if (cmd == CMD.STEP_UP) {			
			if (nomer_man.model.z > nomer_man.min_z ) {//--Верх предел проверить
				vslider_mc.value=vslider_mc.value - step;
				this["vsliderBtn"].y=this["vsliderLine"].y+step_sliderBtn;//(vsliderLine.height*(nomer_man.model.z-nomer_man.min_z))/s_conf.main.kt.ice_L;				
				s_conf.main.team_1.manCommand(nomer,CMD.MOVE_POINT,{z:nomer_man.model.z-step});//--Двигаем игрока
				
			}
		}
		if (cmd == CMD.STEP_DOWN) {			
			
			if (nomer_man.model.z < nomer_man.max_z) {//--Низ предел проверить
				vslider_mc.value=vslider_mc.value + step;
				this["vsliderBtn"].y=this["vsliderLine"].y+step_sliderBtn;//(vsliderLine.height*(nomer_man.model.z-nomer_man.min_z))/s_conf.main.kt.ice_L;
				s_conf.main.team_1.manCommand(nomer,CMD.MOVE_POINT,{z:nomer_man.model.z+step});//--Двигаем игрока
			}
			
		}
	}

	 public  function setControlVis(vid:Boolean):void {
		up_btn.visible=vid;
		down_btn.visible=vid;
		rot_left_btn.visible=vid;
		rot_right_btn.visible=vid;

	 }
	protected function onVSliderBtnSet(e:MouseEvent):void {
	    var nomer_man:Man= s_conf.main.team_1.getMan(nomer);		
		var step_sliderBtn:int= (vsliderLine.height*(nomer_man.model.z - nomer_man.min_z) )/(nomer_man.max_z - nomer_man.min_z);;	
		this["vsliderBtn"].y =this["vsliderLine"].y + step_sliderBtn;
		//trace("Click step_sliderBtn=" + step_sliderBtn + " nomer_man.model.z=" + nomer_man.model.z + " nomer_man.max_z=" + nomer_man.max_z + " nomer_man.min_z=" + nomer_man.min_z);
	}
	 protected function onVSliderChange(e:Event):void {
		//trace("onVSliderChange value="+e.target.value);		
		var nomer_man:Object = s_conf.main.team_1.getMan(nomer);
		var val:Number =vslider_mc.max -e.target.value+vslider_mc.min;
		var dval:int = val-slider_prev_val;
		var step:int = 3;
		//var step:Number=(ps*(Math.abs(vslider_mc.max-vslider_mc.min))/100);
		if (dval >=1) {
			//s_conf.main.team_1.manCommand(nomer,CMD.MOVE_POINT,{z:nomer_man.model.z-val});
			//sliderCommand(CMD.STEP_DOWN);
			//trace("onVSliderChange CMD.STEP_UP val="+val+" slider_prev_val="+slider_prev_val);
			
		} else {
			//s_conf.main.team_1.manCommand(nomer,CMD.MOVE_POINT,{z:nomer_man.model.z+val});
			//sliderCommand(CMD.STEP_UP);
			//trace("onVSliderChange CMD.STEP_DOWN val="+val+" slider_prev_val="+slider_prev_val);
		}
		slider_prev_val = val;
		//trace("CP_cell Slider nomer="+nomer+" e.target.value="+e.target.value+" val="+val+" max="+vslider_mc.max+" min="+vslider_mc.min+" percent="+vslider_mc.percent);
	    s_conf.main.team_1.manCommand(nomer,CMD.MOVE_POINT,{z:val});
	 }
	 public function onActive(e:MouseEvent):void {
	    var colorActive:Number=0x000;//0xFFFF00--желтый 0-черный FF0000-красный 888888 -серый
		active = true;
	    var glow:GlowFilter = new GlowFilter(colorActive,0.9,10,10,1,1);
	    var filters:Array = [glow];
	    this.filters = filters;
		//trace("onActive nomer="+nomer);
	    s_conf.main.team_1.manCommand(nomer,CMD.SHOW_ACTIVE,{nomer:nomer,active:true});
		
	 }
	 public function onDeActive(e:MouseEvent):void {
	   active = false;
	   this.filters=null;
	   s_conf.main.team_1.manCommand(nomer,CMD.SHOW_ACTIVE,{nomer:nomer,active:false});
	 }
	 private function onMouseWheel(e:MouseEvent):void {
		 if (active) {
			 s_conf.main.team_1.manCommand(nomer,CMD.ROTATE_Y,{angle:e.delta*2});
		 }
		 //trace("CP_cell onMouseWheel nomer="+nomer);
	 }
	 protected function onManSelect(e:CPEvents):void {
		nomer = int(e.event_value);
		//trace("Selected man "+nomer);
	 }
	 public function btnCommand(cmd:uint):void {
	  switch (cmd) {
		  case CMD.MOVE_UP:
		    s_conf.main.team_1.manCommand(nomer,CMD.MOVE_UP,{time_cmd_lim:0});
		    break;
		  case CMD.MOVE_DOWN:
		    s_conf.main.team_1.manCommand(nomer,CMD.MOVE_DOWN,{time_cmd_lim:0});
		    break;
		  case CMD.MOVE_STOP:
		    s_conf.main.team_1.manCommand(nomer,CMD.MOVE_STOP,{time_cmd_lim:0});
		    break;
	  }
	 }
	 protected  function onClickGO(e:Event):void {	
		 //trace("onClickGO nomer="+nomer);
		 switch (e.target.name) {
			  case "shoot_btn":			  
			   s_conf.main.team_1.manCommand(nomer,CMD.SHOOT,{time_cmd_lim:0});
			   setShootVisible(nomer,false);
			   break;	
			 case "up_btn":
			   s_conf.main.team_1.manCommand(nomer,CMD.MOVE_UP,{time_cmd_lim:0});			
			   break;
		     case "down_btn":
			   //trace("down_btn");			  
			    s_conf.main.team_1.manCommand(nomer,CMD.MOVE_DOWN,{time_cmd_lim:0});
			   break;
		     case "stop_btn":			   			   
			   s_conf.main.team_1.manCommand(nomer,CMD.MOVE_STOP,{time_cmd_lim:0});
			   break;
			 case "rot_left_btn":			   
				s_conf.main.team_1.manCommand(nomer,CMD.ROTATE_LEFT,{time_cmd_lim:0});
			   break;
		     case "rot_right_btn":			  
			   s_conf.main.team_1.manCommand(nomer,CMD.ROTATE_RIGHT,{time_cmd_lim:0});
			   break;			
		 }		
		
	 }


	
}
}