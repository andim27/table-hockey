package controlpanel
{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.*;
import flash.text.TextField;
import flash.system.Security;
import flash.system.Capabilities;

import events.CPEvents;
import utils.*;

import com.greensock.*;
import com.greensock.easing.*;
import com.bit101.components.*;

public class  CP_intro extends CP_intro_sym {	
 public  var s_conf:Object;
 public  var cur_state:uint;
 private var part_1_mc:MovieClip;
 private var part_2_mc:MovieClip;
 private var man_1_mc:MovieClip;
 private var man_2_mc:MovieClip;
 private var progres_mc:ProgressBar;
 private var ld_txt:TextField;
 private var ps_loaded_txt:TextField;

 //public var up_many_btn : SimpleButton;
 //public var rslider_mc : RoundSlider;

 //public var vsliderBtn:MovieClip;
 //public var vsliderLine:MovieClip;


 public function  CP_intro(s_c:Object):void {			     
		 name='intro';
		 s_conf=s_c;								
	     initVars();
		 initEvents();
	     //onOpenBtnClick(null);
 }
 protected  function initVars():void {
	cur_state=STATE.INIT;
	//part_1_mc=getDefinitionByName("part_1") as MovieClip;
	//part_2_mc=getDefinitionByName("part_2") as MovieClip;
	//man_1_mc=getDefinitionByName("m_1") as MovieClip;
	//man_2_mc=getDefinitionByName("m_2") as MovieClip;
	//progres_mc= new ProgressBar(this,);
	//progres_mc.maximum = 100;
	ps_loaded_txt = new TextField();
	ps_loaded_txt.x = this.width * 0.5;
	ps_loaded_txt.y = this.height * 0.8;
	ps_loaded_txt.textColor = 0x000000;
	
	//ps_loaded_txt.width = this.width * 0.01;
	width =s_conf.stage.stageWidth;
	height=s_conf.stage.stageHeight;
	x=s_conf.stage.stageWidth  * 0.5;
	y=s_conf.stage.stageHeight * 0.5;
	s_conf.stage.addChild(this);
	this.addChild(ps_loaded_txt);
 }
 private function initEvents():void {
	addEventListener(Event.ENTER_FRAME,onEnterFrame);
	s_conf.main.loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
 }
 private function onCloseParts():void {//---when all parts closed--
 	
	cur_state=STATE.STOP;
 }
 private function onMoveStop():void {//---when all parts closed--
 	
	cur_state=STATE.MOVE_STOP;
   
 }
 private function closeParts():void {//--do close
			
 	cur_state=STATE.LEFT;
	TweenLite.to(part_1_mc, 2, {x:-part_1_mc.width, y:part_1_mc.y, ease:Elastic.easeIn});
	TweenLite.to(part_2_mc, 2, {x:s_conf.stage.stageWidth+part_1_mc.width, y:part_1_mc.y, ease:Elastic.easeIn,onComplete:onCloseParts});
	s_conf.main.flyOver();
 }
 private function onOpenStop(n:uint):void {
	if (n == 1) {
		this.removeChild(this["kt_part_1_mc"]);
	} else {
		this.removeChild(this["kt_part_2_mc"]);
	}
	s_conf.main.cp_cell_control_mc.setCellsVisible(true);
 }
 private function manToIce(team_n:uint,nomer:uint):void {//--move man symbol to ice
   cur_state=STATE.MOVE;
   var man_mc:MovieClip;
   var step:uint=70;
   var man_w:uint=30;
   var man_h:uint=60;
   if (team_n == 1) {
	   man_mc=new m_1();
	   man_mc.name="man_mc_"+team_n+"_"+nomer;
	   this["kt_part_1_mc"].addChild(man_mc);
	   this["kt_part_1_mc"].man_mc.width=man_w;
	   this["kt_part_1_mc"].man_mc.height=man_h;
	   this["kt_part_1_mc"].man_mc.x=-this["kt_part_1_mc"].width;
	   this["kt_part_1_mc"].man_mc.y=step*nomer;
	   TweenLite.to(man_mc, 0.5, {x:0.8*this["kt_part_1_mc"].width,ease:Elastic.easeOut,delay:0.5,onComplete:onMoveStop});
   }
   if (team_n == 2) {
	   man_mc=new m_2();
	   man_mc.name="man_mc_"+team_n+"_"+nomer;
	   this["kt_part_2_mc"].addChild(man_mc);
	   this["kt_part_2_mc"].man_mc.width=man_w;
	   this["kt_part_2_mc"].man_mc.height=man_h;
	   this["kt_part_2_mc"].man_mc.x=this["kt_part_1_mc"].width;
	   this["kt_part_2_mc"].man_mc.y=step*nomer;
	   TweenLite.to(man_mc, 0.5, {x:0.8*this["kt_part_1_mc"].width,ease:Elastic.easeOut,delay:0.5,onComplete:onMoveStop});
   }
 }
 private function openParts():void  {
	   //if ((Capabilities.playerType == 'Desktop')||(Security.sandboxType != Security.REMOTE)) return;
	   if (s_conf.main.lg == 0) { return;}
       TweenLite.to(this["kt_part_2_mc"], 10, {delay:0.5,x:-this["kt_part_1_mc"].width,y:this["kt_part_1_mc"].y,ease:Elastic.easeOut,onComplete:onOpenStop,onCompleteParams:[1]});	 
       TweenLite.to(this["kt_part_1_mc"], 10, {delay:0.5,x:this["kt_part_1_mc"].width,y:this["kt_part_1_mc"].y,ease:Elastic.easeOut,onComplete:onOpenStop,onCompleteParams:[2]});	 
 }
 private function showPs(ps:Number):void  {
	  this["kt_part_1_mc"]["ps_txt"].text = int(ps);
	  ps_loaded_txt.text= String(int(ps));
	  if (ps >= 10) {this["kt_part_1_mc"].m_1_mc.visible=true;}
	  if (ps >= 20) {this["kt_part_1_mc"].m_2_mc.visible=true;}
	  if (ps >= 30) {this["kt_part_1_mc"].m_3_mc.visible=true;}
	  if (ps >= 40) {this["kt_part_1_mc"].m_4_mc.visible=true;}
	  if (ps >= 50) {this["kt_part_1_mc"].m_5_mc.visible=true;}
	  
	  if (ps >= 60)  {this["kt_part_2_mc"].m_1_mc.visible=true;}
	  if (ps >= 70)  {this["kt_part_2_mc"].m_2_mc.visible=true;}
	  if (ps >= 80)  {this["kt_part_2_mc"].m_3_mc.visible=true;}
	  if (ps >= 90)  {this["kt_part_2_mc"].m_4_mc.visible=true;}
	  if (ps >= 100) {this["kt_part_2_mc"].m_5_mc.visible=true;}
 }
 //----------------------EVENTS------------------------
 private function progress(e:ProgressEvent):void 
 {
	//trace("event.bytesLoaded="+e.bytesLoaded+" bytesTotal=" + e.bytesTotal);
	//trace("ph_engine.bytesLoaded="+s_conf.main.ph_engine.loaderInfo.bytesLoaded+" bytesTotal=" + s_conf.main.ph_engine.loaderInfo.bytesTotal);
	var ps:Number =(e.bytesLoaded / e.bytesTotal)*100;
	//trace(" ps="+ ps);
	showPs(ps);
	if (e.bytesLoaded >= e.bytesTotal) {
		s_conf.main.tb = e.bytesTotal;
		openParts();
	}
 }
 private function onEnterFrame(e:Event):void {
	if (cur_state == STATE.STOP) {
		//trace("INTRO remove "+this["ps_txt"]);
		s_conf.stage.removeChild(this["ps_txt"]);		
		this.removeChild(this["ps_txt"]);
		this.removeChild(ps_loaded_txt);
		//s_conf.main.createCPControl();
		s_conf.stage.removeChild(this);
		
		
		
	}
 }

	
}
}