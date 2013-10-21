package controlpanel
{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

import events.CPEvents;
import controlpanel.CP_force;
import utils.STATE;

import com.greensock.*;
import com.greensock.easing.*;
import com.bit101.components.*;

public class  CP_start extends CP_startsym {	
 public  var s_conf:Object;
 public  var cur_state:uint;
 private var panel:Panel;
 private var level_r_1:RadioButton;
 private var level_r_2:RadioButton;
 private var level_r_3:RadioButton;
 private var period_cmb:ComboBox;
 
 private var first_x:int;
 private var first_y:int;
 
 private var center_x:int;
 private var center_y:int;
 public var force_mc:CP_force;  //--индикатор силы удара
 //public var up_many_btn : SimpleButton;
 //public var rslider_mc : RoundSlider;

 //public var vsliderBtn:MovieClip;
 //public var vsliderLine:MovieClip;


 public function  CP_start(s_c:Object):void {		
	     cur_state=STATE.INIT;//"init";
		 s_conf=s_c;								
	     initVars();
	     //onOpenBtnClick(null);
 }
protected  function initVars():void {
		first_x=-10;//-s_conf.stage.stageWidth*0.55;
		first_y=s_conf.stage.stageHeight*0.2;
		center_x=s_conf.stage.stageWidth*0.67;
		center_y=first_y;
		this["s_mc"].addEventListener(MouseEvent.CLICK,onSndClick);
		//this["open_btn"].visible = false;
	  
		this.x=first_x;
		this.y=first_y;
		this["mes_txt"].visible=false;
		this["open_btn"].addEventListener(MouseEvent.CLICK,onOpenBtnClick);
		this["close_btn"].addEventListener(MouseEvent.CLICK,onCloseBtnClick);
		this["start_btn"].addEventListener(MouseEvent.CLICK,onStartBtnClick);
		panel = new Panel(this, -this.width*0.85, this.height*0.87);
		panel.width=this.width*0.84;
		panel.height=18;
		panel.color = 0x6565FF;
				
		var r_first_x:Number=5;
		level_r_1 = new RadioButton(panel, r_first_x+panel.width*0.05, panel.height*0.3, "Beginner", true);
		level_r_2 = new RadioButton(panel, r_first_x+panel.width*0.45, panel.height*0.3, "Middle");
		level_r_3 = new RadioButton(panel, r_first_x+panel.width*0.75, panel.height*0.3, "Profi");
	    
		level_r_1.addEventListener(MouseEvent.CLICK,onRbBtnClick);
		level_r_2.addEventListener(MouseEvent.CLICK,onRbBtnClick);
		level_r_3.addEventListener(MouseEvent.CLICK, onRbBtnClick);
		
		period_cmb = new ComboBox(this, -this.width * 0.5, this.height * 0.62, "1",new Array("1","2","3"));
		//period_cmb.addItem("1");
		//period_cmb.addItem("2");
		//period_cmb.addItem("3");
		period_cmb.width = 45;
		period_cmb.numVisibleItems=3;
		period_cmb.openPosition = "top";
		period_cmb.selectedIndex = 0;

		level_r_1.name="level_r_1";
		level_r_2.name="level_r_2";
		level_r_3.name="level_r_3";
		s_conf.stage.addChild(this);		
		//addCPforce();
		cur_state=STATE.LEFT;
}
public function addCPforce():void {
	force_mc = new CP_force(s_conf,-this.width*0.46,this.height*0.65,2,11,9);
	this.addChild(force_mc);
 
}
private function onToCenter():void  {
 //force_mc.visible=true;
 cur_state=STATE.CENTER;//"center";

}
private function onToLeft():void  {
 //force_mc.hint_mc.visible=false;
 cur_state = STATE.LEFT;//"left";
 trace("CP_start x="+this.x);

}
private function onSndClick(e:MouseEvent):void {
	//trace(this["s_mc"].currentFrame);
	if (this["s_mc"].currentFrame==1) {
		this["s_mc"].gotoAndStop(2);
		s_conf.main.can_sound=false;
		return;
	}
	this["s_mc"].gotoAndStop(1);
	s_conf.main.can_sound=true;
}
public function onRbBtnClick(e:MouseEvent=null):void {
	//trace(e.target.name);
	if ((e.target.name=="level_r_2")||(e.target.name=="level_r_3")) {
		mes_txt.visible=true;
	} else {
		mes_txt.visible=false;
	}
}
public function onOpenBtnClick(e:MouseEvent=null):void {
	if (cur_state==STATE.LEFT){
		 if (s_conf.main.cp_cell_control_mc.help_mc.cur_state == STATE.CENTER) {
			 s_conf.main.cp_cell_control_mc.help_mc.onCloseBtnClick(null);
		 }
		 this["open_btn"].visible=false;
		 this["close_btn"].visible=true;
		 TweenLite.to(this, 1.5, {x:center_x, y:center_y, ease:Elastic.easeOut,onComplete:onToCenter});
		return;
	} else {
		onCloseBtnClick(null);
	}

}
public function onCloseBtnClick(e:MouseEvent=null):void {
	if ((cur_state==STATE.CENTER)||(e == null)){
		this["open_btn"].visible=true;
 		this["close_btn"].visible=false;
		TweenLite.to(this, 1.5, {x:first_x, y:first_y, ease:Elastic.easeOut,onComplete:onToLeft});
		return;
	}
}
public function onStartBtnClick(e:MouseEvent=null):void {
	onCloseBtnClick(null);
	
	if ((int(period_cmb.selectedIndex) == 0) || (int(period_cmb.selectedIndex) == 1) || (int(period_cmb.selectedIndex) == 2) ) {
		s_conf.main.cp_cell_control_mc.time_mc.setPeriodLen(period_cmb.selectedIndex+1);
		//(this["period_min_txt"] as MovieClip).enabled = false;
	}
	s_conf.main.cp_cell_control_mc.time_mc.showCountDown();
}
	
}
}