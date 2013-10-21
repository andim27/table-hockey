package controlpanel
{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import events.CPEvents;

//import lib.control.hint.Hint;
public class  CP_shayba extends MovieClip {	
 public var level:int;
 public var level_cnt:int;
	public function  CP_shayba() {				
	     initVars();
		 initEvents();
		 setParamVis(level);
	 }
	 protected  function initVars() {
		level      = 0;
		level_cnt  = 3;
		this.mouseEnabled = true;
	 }
	 protected  function initEvents() {		
		 var shayba_cur;
		 for (var i:int=0; i <= level_cnt; i++) {
			 shayba_cur = this["shayba_" + i + "_mc"];
			 shayba_cur.buttonMode=true;
		     shayba_cur.addEventListener(MouseEvent.CLICK,onClickGO);
		 }		
	 }
	 public function initHints() {
		 //Hint.add(man_go_r, "Идти вперед!");
		 //Hint.add(man_go_l, "Идти назад!");
	 }
	 public function setParamVis(nomer) {
		 var shayba_cur;
		 for (var i:int=0; i <= level_cnt; i++) {
			 shayba_cur = this["shayba_" + i + "_mc"];
			 if (i == nomer) {
				 shayba_cur.gotoAndStop("black");
			 } else {
				 shayba_cur.gotoAndStop("white");
			 }
		 }
	 }


	 protected  function onClickGO(e:Event) {
		 var objEvent=new CPEvents(CPEvents.SHAYBA_CONTROL);
		 objEvent.event_label="level";
		 //trace(e.target.name);
		 switch (e.target.name) {
			 case "shayba_0_mc":
			   setParamVis(0);      
		  	   objEvent.event_value=0;			
			   break;
			 case "shayba_1_mc":
			   setParamVis(1);		  	   
			   objEvent.event_value=1;			  
			   break;
		     case "shayba_2_mc":
			   setParamVis(2);			 
			   objEvent.event_value=2;
			   break;
		     case "shayba_3_mc":
			   setParamVis(3);			   
		       objEvent.event_value=3;
			   break;
			 case "shayba_4_mc":
			   setParamVis(4);			    
			   objEvent.event_value=4;
			   break;		     
		 }
		 this.dispatchEvent(objEvent);
		 
	 }


	
}
}