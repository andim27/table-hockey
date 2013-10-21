package controlpanel
{
import flash.display.*;
import flash.events.Event;
import flash.events.MouseEvent;

import away3d.core.utils.Debug;

import events.*;
import controlpanel.*;
import utils.MyF;


public class  CP_cell_control extends Sprite {
  public var s_conf:Object;
  public  var cur_state:String;
  private var xClose:int;
  private var yClose:int;
  private var cell_cnt:int;
  public var cell_items:Array;
  public var cells_visible:Boolean;//--видимость всех ячеек с игроками
  private var x0:int;
  private var y0:int;
  private var x1:int;
  private var y1:int;
  private var step:int;
  
  public var cp_bort_mc:MovieClip;//--борт -фон где сидят игроки
  public var camera_mc:CP_camera;//--табло управления камеройвремени
  //public var force_mc:CP_force;  //--индикатор силы удара
  public var result_mc:CP_result;//--табло результата
  public var time_mc:CP_time;    //--табло времени
  public var start_mc:CP_start;  //--табло старта
  public var help_mc:CP_help;    //--табло помощи
  public var kick_mc:CP_kick;    //--табло настройки удара
	public function CP_cell_control(s_c:Object) {  
	  initVars(s_c);
	  //initEvents();
	}
	
	protected  function initVars(s_c:Object):void {
	 s_conf=s_c;
	 cell_cnt=6;
     step=110;
	 x0= - step;//- (s_c.stage.stageWidth /3) ;
	 y0= s_conf.stage.stageHeight-15;
	 cells_visible=true;
	 var y_top:int=17;
	
	 //Debug.trace("CP_cell_control y1="+y1+" s_c.stage.height "+s_c.stage.stageHeight  );
	 cell_items=new Array();
	 cell_items.push(new CP_cell(s_c,x0+1*step,y0,1));
	 cell_items.push(new CP_cell(s_c,x0+2*step,y0,2));
	 cell_items.push(new CP_cell(s_c,x0+3*step,y0,3));
	 cell_items.push(new CP_vratar(s_c,x0+4.3*step,y0,6));
	 cell_items.push(new CP_cell(s_c,x0+5.3*step,y0,4));
	 cell_items.push(new CP_cell(s_c,x0+6.1*step,y0,5));
	 
	 //firstShow();
	 
	 //---add Camera control-----
	 camera_mc=new CP_camera(s_c,15,y_top);	
	 //---add табло результата-----
	 result_mc = new CP_result(s_c,s_c.stage.stageWidth*0.37,y_top);
     result_mc.addEventListener(GameEvents.GOAL,onGoal);
	 //---add индикатор времени-----
	 time_mc = new CP_time(s_c,s_c.stage.stageWidth*0.65,y_top);
		 //---add start panel---------
	 start_mc= new CP_start(s_c);
	 //start_mc.addCPforce();	 
     //---help panel---------
	 help_mc= new CP_help(s_c,s_c.stage.stageWidth+2,s_c.stage.stageHeight*0.01);
	 //---add индикатор силы-----
	 //force_mc = new CP_force(s_c,s_c.stage.stageWidth*0.50,s_c.stage.stageHeight-7,2,11,9);
 	//--табло настройки удара--
	 kick_mc=new CP_kick(s_c,15,y_top);	
	}
	public function firstShow():void {
	  /*
	  for (var i:int=1; i <= 6; i++) {
		  cell_items[i-1].firstShow();		  		
	  }
	   */
	  cp_bort_mc = new CP_bort_sym();
	  cp_bort_mc.x=0;
	  cp_bort_mc.y=s_conf.stage.stageHeight;	  
	  s_conf.stage.addChild(cp_bort_mc);
	  
	  cell_items[0].firstShow();//--каскадный показ следующих
	  camera_mc.firstShow();
	  kick_mc.firstShow();
	  result_mc.firstShow();
	  time_mc.firstShow();
	  //force_mc.firstShow();
	  //start_mc.firstShow();
	  MyF.moveToTop(help_mc);
	}
	private function onGoal(e:GameEvents):void  {
		result_mc.setGoal(e.event_obj.nomer);
		//Debug.trace("onGoal!!!!!");
	}
	public function setClipsDeepth():void {
		MyF.moveToTop(start_mc);
		MyF.moveToTop(help_mc);
	}
	public function onResize(k_scale_x:Number=1,k_scale_y:Number=1):void {
		step=s_conf.stage.stageWidth/6;
		x0= - step*0.97;//- (s_c.stage.stageWidth /3) ;
	    y0= s_conf.stage.stageHeight*0.96;
		for (var i:int=1; i <= 6; i++) {
		  cell_items[i-1].x=x0+i*step;
		  cell_items[i-1].y=y0;
		  cell_items[i-1].width=step*0.95;
		  cell_items[i-1].height=step*1;
	    }
		
		var y_top:int=s_conf.stage.stageHeight*0.1;
		//---------camera----------------------
		camera_mc.x=s_conf.stage.stageWidth*0.05;
		camera_mc.y=y_top;
		camera_mc.width=s_conf.stage.stageWidth*0.25;
		camera_mc.height=s_conf.stage.stageHeight*0.15;
		
		//---------result----------------------
		result_mc.x=camera_mc.x+camera_mc.width+s_conf.stage.stageWidth*0.01;
		result_mc.y=y_top;
		result_mc.width=s_conf.stage.stageWidth*0.25;
		result_mc.height=s_conf.stage.stageHeight*0.15;
		//---------time----------------------
		time_mc.x=result_mc.x+result_mc.width+s_conf.stage.stageWidth*0.01;
		time_mc.y=y_top;
		time_mc.width=s_conf.stage.stageWidth*0.25;
		time_mc.height=s_conf.stage.stageHeight*0.15;
		//----------force---------------------
		//start_mc.force_mc.x=s_conf.stage.stageWidth*0.35;
		//start_mc.force_mc.y=s_conf.stage.stageHeight*.096;
		//start_mc.force_mc.width=s_conf.stage.stageWidth*0.25;
		//start_mc.force_mc.height=s_conf.stage.stageHeight*0.05;
		//-------------start-------------------
		start_mc.x=0;//-s_conf.stage.stageWidth*0.35;
		start_mc.y=s_conf.stage.stageHeight*0.2;
		//start_mc.width=s_conf.stage.stageWidth*0.5;
		//start_mc.height=s_conf.stage.stageHeight*0.5;
		//-------------help-------------------
		help_mc.x=s_conf.stage.stageWidth*0.98;
		help_mc.y=s_conf.stage.stageHeight*0.2;
		//help_mc.width=s_conf.stage.stageWidth*0.5;
		//help_mc.height=s_conf.stage.stageHeight*0.5;
		//-----bort----------------------------
		cp_bort_mc.width=s_conf.stage.stageWidth;
	}
	public function setShootVisible(n:int,vis:Boolean):void {
	var not_vis:Boolean=(vis==true)?false:true;	
	for (var i:int=1; i <= cell_cnt; i++) {
		 if (cell_items[i-1].nomer == n) {
		     cell_items[i-1].setShootVisible(n,vis);
			 cell_items[i-1].active = true;
		 } else {
		     cell_items[i-1].setShootVisible(n,not_vis);
			 cell_items[i-1].active = false;
		 }
	}
	}
	public function setCellsVisible(t:Boolean):void {
		//Debug.trace("setCellsVisible="+t)
		cells_visible=t;
		for (var i:int=1; i <= cell_cnt; i++) {
			cell_items[i-1].visible=t;
		}
	}
	public function setActiveCell(n:int):void {
	s_conf.main.team_1.active_nomer=n;
	//Debug.trace("setActiveCell active_nomer="+s_conf.main.team_1.active_nomer);
	for (var i:int=1; i <= cell_cnt; i++) {
		 if (cell_items[i-1].nomer == n) {	
		     cell_items[i-1].active=true;
			 cell_items[i-1].onActive(null);
			 
		 } else {		
			 cell_items[i-1].onDeActive(null);
		 }
	}
	}
	public function getCPCellMoveMaxMin(nomer:int):Object {
		var res:Object = new Object();
		res.max_z=res.min_z=0;
		for (var i:int=1; i <= cell_cnt; i++) {
		   if (cell_items[i-1].nomer == nomer) {
  		      res.max_z=cell_items[i-1].vslider_mc.max;
   		      res.min_z=cell_items[i-1].vslider_mc.min;
			  return res;
		   }
		}
		return res;
	}
	public function cellSliderCommand(nomer:int,cmd:uint):void {
		for (var i:int=1; i <= cell_cnt; i++) {			
			if (cell_items[i-1].nomer == nomer) {
				//trace("cellSliderCommand nomer="+nomer);
			  if (i != 6) {
	          	   cell_items[i-1].sliderCommand(cmd);
		  	   } else {//--vratar--
  	          	  cell_items[i-1].sliderCommand(cmd);
		       }
			   return;
			}
		}   
	}
	public function cellCommand(nomer:int,cmd:uint):void {
		for (var i:int=1; i <= cell_cnt; i++) {			
			if (cell_items[i-1].nomer == nomer) {				
			  if (i != 6) {
	          	   cell_items[i-1].btnCommand(cmd);
		  	   } else {//--vratar--
  	          	  //cell_items[i-1].btnCommand(cmd);
		       }
			   return;
			}
		}   
	}
	

}
}