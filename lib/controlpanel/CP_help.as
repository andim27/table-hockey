package controlpanel
{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

import utils.STATE;
import events.CPEvents;

import com.greensock.*;
import com.greensock.easing.*;
import com.bit101.components.*;

public class  CP_help extends CP_helpsym {	
 public var s_conf:Object;
 public  var cur_state:uint;
 private var first_x:int;
 private var first_y:int;
 
 private var center_x:int;
 private var center_y:int;
 
 private var acc:Accordion;
 //public var up_many_btn : SimpleButton;
 //public var rslider_mc : RoundSlider;

 //public var vsliderBtn:MovieClip;
 //public var vsliderLine:MovieClip;


 public function  CP_help(s_c:Object,x1:int,y1:int):void {		
	     s_conf=s_c;
		 first_x=x1;//s_conf.stage.stageWidth-5;
	     first_y=y1;//s_conf.stage.stageHeight*0.15;
	     initVars();
	     s_conf.stage.addChild(this);
		 //s_conf.stage.setChildIndex(this,100);
 }
protected  function initVars():void {
	cur_state=STATE.INIT;
	
	
	
	center_x=s_conf.stage.stageWidth*0.15;
	center_y=first_y;
	
	this.x=first_x;
	this.y=first_y;
	this["open_btn"].addEventListener(MouseEvent.CLICK,onOpenBtnClick);
	this["close_btn"].addEventListener(MouseEvent.CLICK,onCloseBtnClick);
	initAccordion();

	//setStrategy();
	setDesc();
	setAuthor();
	setKeys();
	setControls();
	setFaqs();
	s_conf.stage.addChild(this);		
	cur_state=STATE.RIGHT;
}
protected function initAccordion():void {
 acc=new Accordion(this,5,this.height*0.11);
 
 acc.addWindow("Common");           
 acc.addWindow("Control");          
 acc.addWindow("Fags"); 
 
 acc.getWindowAt(0).titleBar.content.addChild(new help_common_sym());
 acc.getWindowAt(1).titleBar.content.addChild(new help_control_sym());
 acc.getWindowAt(2).titleBar.content.addChild(new help_keys_sym());
 acc.getWindowAt(3).titleBar.content.addChild(new help_fags_sym());
 acc.getWindowAt(4).titleBar.content.addChild(new help_author_sym());
 
 acc.getWindowAt(0).title="Common";     //--0  Общее описание
 //acc.getWindowAt(1).title="Contr";//--1 авление игроками
 acc.width=this.width*0.91;
 acc.height=this.height*0.87;
 //trace("acc.getWindowAt(1).titleBar.content="+acc.getWindowAt(1).titleBar.content);
}
private function setDesc():void {
acc.getWindowAt(0).content.addChild(new Desc());
}
private function setAuthor():void {
acc.getWindowAt(4).content.addChild(new Author());
}
private function setKeys():void {
acc.getWindowAt(2).content.addChild(new Keys());
}
private function setControls():void {
acc.getWindowAt(1).content.addChild(new Controls());
}
private function setFaqs():void {
acc.getWindowAt(3).content.addChild(new Fags());
}
private function onToCenter():void  {
 cur_state=STATE.CENTER;
}
private function onToRight():void  {
 cur_state=STATE.RIGHT;
}
public function onOpenBtnClick(e:MouseEvent):void {
	s_conf.main.tracker.checkpoint(0, "help open", "help open");
	if (cur_state==STATE.RIGHT){
		 //---check start open---
		 if (s_conf.main.cp_cell_control_mc.start_mc.cur_state == STATE.CENTER) {
			 s_conf.main.cp_cell_control_mc.start_mc.onCloseBtnClick(null);
		 }
		 this["open_btn"].visible=false;
		 this["close_btn"].visible=true;
		 TweenLite.to(this, 1.5, {x:center_x, y:center_y, ease:Elastic.easeOut,onComplete:onToCenter});
		return;
	} else {
		onCloseBtnClick(null);
	}

}
public function onCloseBtnClick(e:MouseEvent):void {
	s_conf.main.tracker.checkpoint(0, "help closed", "help closed");
	if (cur_state==STATE.CENTER){
		this["open_btn"].visible=true;
 		this["close_btn"].visible=false;
		TweenLite.to(this, 1.5, {x:first_x, y:first_y, ease:Elastic.easeOut,onComplete:onToRight});
		return;
	}
}
	
}
}