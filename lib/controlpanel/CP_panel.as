package controlpanel
{
import flash.display.*;
import flash.text.TextField;
import fl.controls.Label;
import flash.events.Event;
import flash.events.MouseEvent;
import caurina.transitions.Tweener;
import caurina.transitions.properties.CurveModifiers;
import events.CPEvents;

public class  CP_panel extends MovieClip {
  public  var cur_state:String;
  private var xClose:int;
  private var yClose:int;
  private var mc_cnt:int;
  private var mc_cur;
	public function CP_panel() {  
	  initVars();
	  initEvents();
	}
	
	protected  function initVars() {
	 mc_cnt=5;
	 for (var i:int=1; i <= mc_cnt; i++) {
        mc_cur = this["n_man_" + i + "_mc"];
		mc_cur.buttonMode=true;//mouseEnabled=true;
		mc_cur.n_txt.mouseEnabled=false;
		mc_cur.n_txt.text=i;
		mc_cur.n_color_mc.visible=false;
		//mc_cur.pressfon_mc.mouseEnabled=false;
	 }
	}
	protected  function initEvents() {
	 for (var i:int=1; i <= mc_cnt; i++) {
			 mc_cur = this["n_man_" + i + "_mc"];
		     mc_cur.addEventListener(MouseEvent.CLICK,onClickGO);
	 }
	 //cell_man_mc.
	}
	protected  function onClickGO(e:Event) {
		var nomer_man:int;
		 var objEvent=new CPEvents(CPEvents.MAN_SELECT);
		 objEvent.event_label="select";
		 //trace(">>"+e.target.name);
		 switch (e.target.name) {
			 case "n_man_1_mc":
 			   nomer_man=1;
			   setParamVis(1);		  	   
			   objEvent.event_value=1;			  
			   break;
		     case "n_man_2_mc":
			   nomer_man=2;
			   setParamVis(2);			 
			   objEvent.event_value=2;
			   break;	
			 case "n_man_3_mc":
			   nomer_man=3;
			   setParamVis(3);			 
			   objEvent.event_value=3;
			   break;
			 case "n_man_4_mc":
			   nomer_man=4;
			   setParamVis(4);			 
			   objEvent.event_value=4;
			   break;	
			 case "n_man_5_mc":
			   nomer_man=5;
			   setParamVis(5);      
		  	   objEvent.event_value=5;			
			   break;
		 }
		 this.dispatchEvent(objEvent);
		 cell_man_mc.nomer=nomer_man;
	 }

	public function openPanel(){
	  //this.y=yOpen;
	  cur_state="open";
   }
   public function closePanel(){
	  //this.y=yClose;
  	  cur_state="close";
   }
   public function setParamVis(nomer) {
	 for (var i:int=1; i <= mc_cnt; i++) {
      mc_cur = this["n_man_" + i + "_mc"];
	  if (i == nomer) {	   
	    mc_cur.n_color_mc.visible=true;
	  } else {
	    mc_cur.n_color_mc.visible=false;
	  }
	 }

   }
}
}