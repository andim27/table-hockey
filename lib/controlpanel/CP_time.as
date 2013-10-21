package controlpanel
{
import flash.display.*;
import flash.media.Sound;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.*;
import flash.filters.DropShadowFilter;
import flash.filters.BitmapFilterQuality;

import flash.events.TimerEvent; 
import flash.utils.Timer; 

import com.greensock.*;
import com.greensock.easing.*;

import events.*;
import controlpanel.OpenSlider;
import com.bit101.components.*;

public class  CP_time extends CP_timesym {	
 public var s_conf:Object;

 //public var up_many_btn : SimpleButton;
 public var cur_state:String;
 private var cur_period: int;
 private var period_len: int;//---минуты--
 private var period_time_rest:int;//----сек--
 private var time_min: int;
 private var time_sec: int;
 private var myTimer:Timer;
 private var count_down_sec:int;
 private var count_down_mc:CountDown;
 private var can_game:Boolean;
 private var a_win:Window;
 private var gm_win:MovieClip;//Window;
 private var first_x:int;
 private var first_y:int;
 //public var res_1_txt:TextField;
 //public var res_2_txt:TextField;

 public function  CP_time(s_c:Object,x1:int,y1:int):void {		
         this.filters = [new DropShadowFilter(10,45,0x000000,0.8,8,8,0.65,BitmapFilterQuality.HIGH,false,false)];
		 s_conf=s_c;						
		 first_x=x1;
		 first_y=y1;
	     initVars();	     
		 initEvents();
		 //startTime();
		 //showCountDown();
		 
 }
    public function firstShow():void {
		 this.x=first_x;
		 this.y=-this.height;
		 this.alpha=0;
		 s_conf.stage.addChild(this);
		 visible=true;		 
		 TweenLite.to(this,4,{y:first_y,x:first_x,delay:0.5,alpha:100,ease:Elastic.easeOut});
	 }
	 private  function initVars():void {
		cur_state="init";
		visible=false;
		cur_period=1;
		period_len=3;//minutes
		count_down_sec=3;
		can_game=true;
		resetTime();
		
	 }
	 private function initEvents():void {
  		addEventListener(Event.ENTER_FRAME,onEnterFrame);
 	 }
	 public function setPeriodLen(p_min:uint):void {
		 period_len = p_min;
	 }
 	 public function showCountDown():void{
		 count_down_mc=new CountDown();
		 count_down_mc.x=s_conf.stage.stageWidth*0.5;
 		 count_down_mc.y=s_conf.stage.stageWidth*0.35;
		 s_conf.stage.addChild(count_down_mc);
		 
		 count_down_mc.count_down_txt.text=String(count_down_sec);
		 myTimer = new Timer(1000,count_down_sec);
		 myTimer.addEventListener(TimerEvent.TIMER, myTimerCountDown);
		 myTimer.start();
	 }
	 protected function resetTime():void{
		 this["time_min_txt"].text=0;
		 this["time_sec_txt"].text=0;
	 }
	 protected function resetPeriod():void {
		 cur_period = 0;
		 setNextPeriod();		 
	 }
	 public function startTime():void{
		 setMinSec(period_len-1,59);		 
		 myTimer = new Timer(1000);
		 myTimer.addEventListener(TimerEvent.TIMER, timerListener);
		 myTimer.start();
		 cur_state="work";
		 //s_conf.main.cp_cell_control_mc.start_mc.onOpenBtnClick(null);//----OPEN START WINDOW!!!-----------------
	 }
	 public function stopTime():void {
	 	myTimer.stop();
	 }
	 public function resumTime():void {
	 	myTimer.start();
	 }
	 private function setMinSec(min:int,sec:int):void {		
		time_min=(min <=-1)?(period_len-1):min;
		time_sec=sec;
		this["time_min_txt"].text=time_min;
		this["time_sec_txt"].text=time_sec; 
	 }
	 private function nextPeriodWin():void {
		if (cur_period >= 3 ) {
			gameOver();
			return;
		}
		a_win = new Window(s_conf.stage,s_conf.stage.stageWidth*0.30,s_conf.stage.stageHeight*0.40,"  PERIOD - "+(cur_period+1)+"  ");
		a_win.width = s_conf.stage.width * 0.2;
		a_win.shadow=true;
		a_win.color= 0x6699CC;
		a_win.titleBar.color=0xFF0000;
		var ok_btn:PushButton = new PushButton(a_win, a_win.width*0.40, a_win.height*0.5, "  Start  ",onNextPeriodOkBtn);
        ok_btn.width = a_win.width * 0.25;
		var sudya:Bitmap = new Bitmap(new sudya_up());
		sudya.x = a_win.width * 0.05;
		sudya.y = a_win.height * 0.2;
		sudya.width = a_win.width * 0.2;
		sudya.height = a_win.height * 0.8;
		
		a_win.addChild(sudya);
		var s:Sound = new svist();
		if (s_conf.main.can_sound == true) {
			s.play();
		}
		can_game=false;
		cur_state="showalert";

	 }
	public function removegmWin():void {
		s_conf.stage.removeChild(gm_win); 
	}
	public function gameOverWin():void {
		var s_str:String = s_conf.main.cp_cell_control_mc.result_mc.res_1 + ":" + s_conf.main.cp_cell_control_mc.result_mc.res_2;
		s_conf.main.tracker.endGame(s_conf.main.cp_cell_control_mc.result_mc.res_1,"gameover",s_str);
		gm_win = new GM_win(); 	
		gm_win.x=s_conf.stage.stageWidth*0.4;
		gm_win.y=s_conf.stage.stageWidth*0.20;
		gm_win.mes_txt.visible=false;
		s_conf.stage.addChild(gm_win);
		
		var restart_btn:PushButton = new PushButton(gm_win, gm_win.width*0.08, gm_win.height*0.8, "reStart",onReStartOkBtn);
		restart_btn.width=gm_win.width*0.35;
		var save_btn:PushButton = new PushButton(gm_win, gm_win.width*0.55, gm_win.height*0.8, "Save result",onSaveOkBtn);
		save_btn.width=gm_win.width*0.35;
		if (s_conf.main.cp_cell_control_mc.result_mc.res_1 > s_conf.main.cp_cell_control_mc.result_mc.res_2) {
			gm_win.who_txt.text="You";
			if (s_conf.main.can_sound==true) {
		  	    var w_a:Sound=new we_are();
		  	    w_a.play();
		  }
		}
		if (s_conf.main.cp_cell_control_mc.result_mc.res_1 < s_conf.main.cp_cell_control_mc.result_mc.res_2) {
			gm_win.who_txt.text="Comtuter";
		}
		if (s_conf.main.cp_cell_control_mc.result_mc.res_1 == s_conf.main.cp_cell_control_mc.result_mc.res_2) {
			gm_win.who_txt.text="Good fight!";
			gm_win.win_txt.text="The draw!";
		}
		gm_win.score_txt.text="score is "+s_conf.main.cp_cell_control_mc.result_mc.res_1+" : "+s_conf.main.cp_cell_control_mc.result_mc.res_2;
		//trace("gm_win.x="+gm_win.x+" gm_win.y="+gm_win.y+" gm_win.score_txt.text="+gm_win.score_txt.text);
	 }
	 
	 private function onReStartOkBtn(e:MouseEvent):void {
		cur_state="work";
	  	s_conf.main.stage.removeChild(gm_win);
		resetTime();
		resetPeriod();
		s_conf.main.cp_cell_control_mc.result_mc.reStart();
		showCountDown();
	 }
	private function onSaveOkBtn(e:MouseEvent):void {
		cur_state="work";
	  	//s_conf.main.stage.removeChild(gm_win);		
		gm_win.mes_txt.visible=true;
	 }
	private function onNextPeriodOkBtn(e:MouseEvent):void {
	  	var s_str:String = s_conf.main.cp_cell_control_mc.result_mc.res_1 + ":" + s_conf.main.cp_cell_control_mc.result_mc.res_2;
		s_conf.main.tracker.beginLevel(cur_period, "Period done", "srore="+s_str);
		cur_state="work";
	  	s_conf.stage.removeChild(a_win);
	  	setNextPeriod();
	 }
	private function setNextPeriod() :void{
	   cur_period++;
	   if (cur_period >3) {
		   gameOver();
	   } else {
		    setMinSec(period_len-1,59);	
	   		for (var i:uint=1;i<=3;i++) {
	   		    if (i == cur_period) {
					this["period_"+i+"_txt"].textColor = 0xFF0000;//--red
				} else {
					this["period_"+i+"_txt"].textColor = 0x555555;//--gray
				}
			}
	   }
	 }
	private function gameOver():void {
	      resetTime();
		  stopTime();
		  cur_period = 0;
		  var objEvent:Event=new CPEvents(GameEvents.GAME_OVER);
		  this.dispatchEvent(objEvent);
		  removeEventListener(TimerEvent.TIMER, timerListener);
		  gameOverWin();
	 }
	 private function myTimerCountDown(e:TimerEvent):void {
		 count_down_mc.count_down_txt.text=String(int(count_down_mc.count_down_txt.text)-1);
		 if (e.target.currentCount == count_down_sec){
			 s_conf.stage.removeChild(count_down_mc);
			 myTimer.stop();
			 startTime();
			 s_conf.main.shayba.fallDownCenter();
		 }
	 }
	 private function timerListener (e:TimerEvent):void{
		if (cur_state == "work") {
			time_sec--;			
			this["time_sec_txt"].text=time_sec;
			if (time_sec < 0) {//-- минута прошла---
				
				//---корректировка минут---
				time_min--;
				this["time_min_txt"].text=(time_min <=0)?0:time_min;
				//trace("Timer is working (-1 min)! "+time_min);
				if (time_min < 0) {
					//gameOver();
					this["time_min_txt"].text="00";
					this["time_sec_txt"].text="00";
					nextPeriodWin();
					//setNextPeriod();
				} else {
					time_sec=59;
					this["time_sec_txt"].text=59;
				}
			}
		}
	 }
	 
	 private function onEnterFrame(e:Event):void {
		 
	 }
}
}