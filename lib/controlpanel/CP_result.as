package controlpanel
{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.Sound;
import flash.text.*;
import flash.events.TimerEvent; 
import flash.utils.Timer;
import flash.filters.DropShadowFilter;
import flash.filters.BitmapFilterQuality;

import com.greensock.*;
import com.greensock.easing.*;

import events.*;
import controlpanel.OpenSlider;
import utils.CMD;


public class  CP_result extends CP_resultsym {	
 public var s_conf:Object;

 //public var up_many_btn : SimpleButton;
 //public var rslider_mc : RoundSlider;
 public var vslider_mc :OpenSlider;
 //public var vsliderBtn:MovieClip;
 //public var vsliderLine:MovieClip;
 //public var res_1_txt:TextField;
 //public var res_2_txt:TextField;
 public var res_1: int;
 public var res_2: int;
 private var myTimer:Timer;
 private var first_x:int;
 private var first_y:int;
 private var s:Sound;
 private var goal_flame_mc:MovieClip;
 public function  CP_result(s_c:Object,x1:int,y1:int):void {		
	     this.filters = [new DropShadowFilter(10,45,0x000000,0.8,8,8,0.65,BitmapFilterQuality.HIGH,false,false)];
		 s_conf=s_c;						
		 first_x=x1;
		 first_y=y1;
	     initVars();
	     s_conf.stage.addChild(this);
		
 }
 	 public function firstShow():void {
		 this.x=first_x;
		 this.y=-200;//this.height;
		 this.alpha=0;
		 s_conf.stage.addChild(this);
		 visible=true;	
		 TweenLite.to(this,4,{y:first_y,x:first_x,delay:0.5,alpha:100,ease:Elastic.easeOut});
	 }
	 protected  function initVars():void {
		 visible=false;
		 goal_flame_mc= new goal_flame();
		 goal_flame_mc.x=this.width * 0.5;
		 goal_flame_mc.y = this.height * 0.5;
		 goal_flame_mc.visible=false;
		 this.addChild(goal_flame_mc);
		
		 goal_flame_mc.addEventListener(MouseEvent.CLICK, flameClick);				 
		 initRes();
		 s = new g_s();
	 }
	 protected function initRes():void {
		 this["res_1_txt"].text=0;
		 this["res_2_txt"].text=0;
	 }
	 public function reStart():void {
		 res_1=0;
		 res_2=0;
		 this["res_1_txt"].text=0;
		 this["res_2_txt"].text = 0;
		 hideFlame();
	 }
	 public function hideFlame():void {
		 goal_flame_mc.visible=false;
	 }
	 public function bGoal():void {
	   myTimer=new Timer(500,6);
	   myTimer.addEventListener(TimerEvent.TIMER,blinkAction);
	   myTimer.addEventListener(TimerEvent.TIMER_COMPLETE,afterGoalAction);
	   myTimer.start();
	 }
	 private function blinkAction(e:TimerEvent):void {
		 if (goal_flame_mc.visible == true) {
			 goal_flame_mc.visible=false;
		 } else {
		     goal_flame_mc.visible=true;
		 }	
	 }
	 private function afterGoalAction(e:TimerEvent):void {
		try {
		 hideFlame();
		 s_conf.main.shayba.fallDownCenter();
		 myTimer.stop();
		 //myTimer = null;
		} catch (e:Error) {
		};
	 }
	 public function setGoal(n:int):void {
		try {
		 if (s_conf.main.can_sound == true) {		 	
		 	s.play();
		 }
		 goal_flame_mc.visible=true;
		 if (n==1) {			 
		     s_conf.main.team_1.allCommand(CMD.MOVE_DOWN,{time_cmd_lim:2});
			 res_1++;
			 this["res_1_txt"].text=res_1;
		 }
		 if (n==2) {
			 s_conf.main.team_2.allCommand(CMD.MOVE_UP,{time_cmd_lim:2});
			 res_2++;
			 this["res_2_txt"].text=res_2;
		 }
		 bGoal();
		} catch (e:Error) {
		};
	 }
	 private function flameClick(e:MouseEvent):void {
		 //goal_flame_mc.visible = false; 
		 afterGoalAction(null);
	 }
	
}
}