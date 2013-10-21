package controlpanel
{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.*;

import com.greensock.*;
import com.greensock.easing.*;

import events.CPEvents;
import man.Man;
import controlpanel.OpenSlider;
import utils.CMD;


//public class  CP_vratar extends CP_vratar_sym {	
public class  CP_vratar  extends CP_vratarsym {	
 public var s_conf:Object;
 private var up_step:int;

 private var down_step:int;

 private var left_step:int;
 private var right_step:int;

 //public var stop_btn : SimpleButton;
 //public var left_btn : SimpleButton;
 //public var right_btn : SimpleButton;
 //public var shoot_btn : SimpleButton;

 //public var pos_0_btn : SimpleButton;
 //public var pos_1_btn : SimpleButton;
 //public var pos_2_btn : SimpleButton;

 public var vslider_mc :OpenSlider;
 //public var vsliderBtn:MovieClip;
 //public var vsliderLine:MovieClip;
 public var nomer : int;
 private var first_x:int;
 private var first_y:int;
 public var active:Boolean;

 public function  CP_vratar(s_c:Object,x1:int,y1:int,n:int):void {		
	     visible=false;
		 s_conf=s_c;
		 nomer=n;
		 first_x=x1;
		 first_y=y1;
		 initEvents();
		 initVars();		
		 //trace("CP_vratar x1="+x1+" y1="+y1+" nomer="+nomer);
 }
	 protected  function initVars():void {
		up_step   = 10;
		down_step = 10;
		this["vsliderLine"].visible=false;
		
		initSlider();
		//addChild(new CPCellClass());
	 }
	 public function firstShow():void {
		 this.x=-s_conf.stage.stageWidth;//0;
		 this.y=first_y;//s_conf.stage.stageHeight+this.height;
		 s_conf.stage.addChild(this);
		 visible=true;
		 //trace("CELL first show "+nomer);
		 TweenLite.to(this, 2, {y:first_y,x:first_x,delay:0.5,ease:Elastic.easeOut});
	 }

     protected  function initSlider():void {
	    vslider_mc = new OpenSlider(vsliderBtn,vsliderLine);
		vslider_mc.addEventListener(Event.CHANGE,onVSliderChange);
		vslider_mc.name = "VSlider_"+nomer;

		vslider_mc.setRange(int(s_conf.main.kt.ice_W*0.6),int(s_conf.main.kt.ice_W*0.3));
		vslider_mc.value = (s_conf.main.kt.ice_W*0.5);//(vslider_mc.max-vslider_mc.min)*0.5;
		
		vsliderBtn.x=vsliderLine.x;//-vsliderLine.width*0.5;
		vsliderBtn.y=vsliderLine.y;
		//trace("VRATAR Init vslider_mc.value="+vslider_mc.value+" vslider_mc.min="+vslider_mc.min+" vslider_mc.max="+vslider_mc.max);
	 }
	 public function sliderCommand(cmd:uint):void {
		var dvratX:Number =(vslider_mc.min-vslider_mc.max);
		var nomer_man:Object = s_conf.main.team_1.getMan(nomer);
		var ps:int=3;
		var step:Number=(ps*(vslider_mc.min-vslider_mc.max)/100);
		var step_sliderBtn:int=int(((nomer_man.model.x ) * vsliderLine.width)/dvratX);
		
		if (cmd == CMD.STEP_LEFT) {			
			
			if (nomer_man.model.x < nomer_man.min_x ) {//--Верх наоборот
				//vslider_mc.value=vslider_mc.value + step;
				//vslider_mc.percent=vslider_mc.percent-ps;
				//trace("(L) step="+step+" step_sliderBtn="+step_sliderBtn+" nomer_man.model.x="+nomer_man.model.x);
				//this["vsliderBtn"].x=this["vsliderLine"].x-step_sliderBtn;//(vsliderLine.height*(nomer_man.model.z-nomer_man.min_z))/s_conf.main.kt.ice_L;				
				s_conf.main.team_1.manCommand(nomer,CMD.MOVE_POINT,{x:nomer_man.model.x+step});//--Двигаем игрока
				
			}
		}
		if (cmd == CMD.STEP_RIGHT) {			
			
			if (nomer_man.model.x > nomer_man.max_x) {//--Низ наоборот
				//vslider_mc.value=vslider_mc.value - step;
				//vslider_mc.percent=vslider_mc.percent+ps;
				//trace("(R) step="+step+" step_sliderBtn="+step_sliderBtn+" nomer_man.model.x="+nomer_man.model.x);
				//this["vsliderBtn"].x=this["vsliderLine"].x+step_sliderBtn;//(vsliderLine.height*(nomer_man.model.z-nomer_man.min_z))/s_conf.main.kt.ice_L;
				s_conf.main.team_1.manCommand(nomer,CMD.MOVE_POINT,{x:nomer_man.model.x-step});//--Двигаем игрока
			}
			
		}
		//if (this["vsliderBtn"].x > this["vsliderLine"].x+this["vsliderLine"].width)  {this["vsliderBtn"].x=this["vsliderLine"].x+this["vsliderLine"].width;}
		//if (this["vsliderBtn"].x < this["vsliderLine"].x) {this["vsliderBtn"].x=this["vsliderLine"].x;}
	}
	 protected  function initEvents():void {
		 //trace("CELL initEvents SELECT_TAB_ITEM="+ControlPanelEvents.SELECT_TAB_ITEM);
  	     //parent.addEventListener(CPEvents.SELECT_TAB_ITEM,onSelectTabItem);
		//addEventListener(CPEvents.MAN_SELECT,onManSelect);
	    addEventListener(MouseEvent.MOUSE_OVER,onActive);
		addEventListener(MouseEvent.MOUSE_OUT,onDeActive);
		left_btn.addEventListener(MouseEvent.CLICK,onClickGO);		
		right_btn.addEventListener(MouseEvent.CLICK,onClickGO);
		stop_btn.addEventListener(MouseEvent.CLICK,onClickGO);		
		pos_0_btn.addEventListener(MouseEvent.CLICK,onClickGO);
		pos_1_btn.addEventListener(MouseEvent.CLICK,onClickGO);
		pos_2_btn.addEventListener(MouseEvent.CLICK,onClickGO);
		shoot_btn.addEventListener(MouseEvent.CLICK,onClickGO);
		
	 }
     public function setShootVisible(n:int,vis:Boolean):void {
	 	this["shoot_btn"].visible=vis;
	 }
	 protected function onVSliderChange(e:Event):void {
	   //trace("onVSliderChange val="+e.target.value+" vsliderBtn.x="+vsliderBtn.x+" vsliderLine.x="+vsliderLine.x);
	   s_conf.main.team_1.manCommand(nomer,CMD.MOVE_POINT,{x:e.target.value});
	 }
	 public function onActive(e:MouseEvent):void {
	    var colorActive:Number=0x000;//0xFFFF00--желтый 0-черный FF0000-красный 888888 -серый
		active = true;
	    var glow:GlowFilter = new GlowFilter(colorActive,0.9,10,10,1,1);
	    var filters:Array = [glow];
	    this.filters = filters;
	    s_conf.main.team_1.manCommand(nomer,CMD.SHOW_ACTIVE,{nomer:nomer,active:true});
		
	 }
	 public function onDeActive(e:MouseEvent):void {
	   active = false;
	   this.filters=null;
	   s_conf.main.team_1.manCommand(nomer,CMD.SHOW_ACTIVE,{nomer:nomer,active:false});
	 }
	protected function onManSelect(e:CPEvents):void {
		nomer = int(e.event_value);
		trace("Selected man "+nomer);
	}
	 protected  function onClickGO(e:Event):void {	
		 //trace("onClickGO nomer="+nomer);
		 switch (e.target.name) {
			  case "shoot_btn":			  
			   s_conf.main.team_1.manCommand(nomer,CMD.SHOOT,{time_cmd_lim:0 });
			   break;	
			 case "left_btn":
			   s_conf.main.team_1.manCommand(nomer,CMD.MOVE_LEFT);			
			   break;
		     case "right_btn":
			    s_conf.main.team_1.manCommand(nomer,CMD.MOVE_RIGHT);
			   break;
		     case "stop_btn":			   			   
			   s_conf.main.team_1.manCommand(nomer,CMD.MOVE_STOP);
			   break;
			 case "pos_0_btn":			   
				s_conf.main.team_1.manCommand(nomer,CMD.MOVE_POS,{n:0,cell_mc:this});
			   break;
		      case "pos_1_btn":			   
				s_conf.main.team_1.manCommand(nomer,CMD.MOVE_POS,{n:1,cell_mc:this});
			   break;
			  case "pos_2_btn":			   
				s_conf.main.team_1.manCommand(nomer,CMD.MOVE_POS,{n:2,cell_mc:this});
			   break;
		 }		
		
	 }


	
}
}