package controlpanel
{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import com.bit101.components.*;
import utils.MyF;
import utils.STATE;

public class  CP_top_menu extends CP_top_menusym {	
 public var s_conf:Object;
 private var up_step:int;
 private var up_step_many:int;
 private var down_step:int;
 private var down_step_many:int;
 private var left_step:int;
 private var right_step:int;

 public var active:Boolean;
 public var nomer : int;
 private var first_x:int;
 private var first_y:int;
 private var start_btn:PushButton; 
 private var view_point_btn:PushButton; 
 private var kick_btn:PushButton; 
 private var res_btn:PushButton; 
 private var time_btn:PushButton; 
 private var help_btn:PushButton; 


 public function  CP_top_menu(s_c:Object):void {		
	
		 s_conf = s_c;
		  s_conf.stage.addChild(this);
		 initEvents();
		 initVars();
		
		
 }
	protected  function initVars():void {
		active=false;
		x = 0
		y = 0;
		var y_top:uint = 0;
		var h_btn:uint = 14;
		var w_btn:uint = s_conf.stage.width * 0.1;
		var btn_face:uint = Style.BUTTON_FACE;
		
		Style.BUTTON_FACE = 0x3333FF;
		start_btn= new PushButton(this, s_conf.stage.width*0.1, y_top, "Settings",onSettingBtn);
        start_btn.width = w_btn;
		start_btn.height = h_btn;
		
		//trace("  start_btn x=" + start_btn.x + " y=" + start_btn.y);
		view_point_btn= new PushButton(this, s_conf.stage.width*0.20, y_top, " ViewPoint ",onViewPointBtn);
        view_point_btn.width = w_btn;
		view_point_btn.height = h_btn;
		//MyF.moveToTop(view_point_btn);
		
		kick_btn= new PushButton(this, s_conf.stage.width*0.30, y_top, "Kick",onKickBtn);
        kick_btn.width = w_btn;
		kick_btn.height = h_btn;
		
		res_btn= new PushButton(this, s_conf.stage.width*0.40, y_top, "Result",onResBtn);
        res_btn.width = w_btn;
		res_btn.height = h_btn; res_btn.selected = true;
		
		time_btn= new PushButton(this, s_conf.stage.width*0.50, y_top, "Time",onTimeBtn);
        time_btn.width = w_btn;
		time_btn.height = h_btn;
		
		help_btn= new PushButton(this, s_conf.stage.width*0.60, y_top, "Help",onHelpBtn);
        help_btn.width = w_btn;
		help_btn.height = h_btn;
		
		Style.BUTTON_FACE=btn_face;
	}
	
	protected  function initEvents():void {
	  
	}

	private function onSettingBtn(e:MouseEvent):void {
		var item_mc:Object = s_conf.main.cp_cell_control_mc.start_mc;
		if (item_mc.cur_state == STATE.LEFT) {
			item_mc.onOpenBtnClick(null);
		}
		if (item_mc.cur_state == STATE.CENTER) {
			item_mc.onCloseBtnClick(null);
		}
	}
	private function onViewPointBtn(e:MouseEvent):void {
		var item_mc:Object = s_conf.main.cp_cell_control_mc.camera_mc;		
		var kick_mc:Object = s_conf.main.cp_cell_control_mc.kick_mc;
		if (kick_mc.visible == true) {
			kick_mc.visible = false;			
		}
		item_mc.visible = (item_mc.visible == true)?false:true;		
	}
	private function onKickBtn(e:MouseEvent):void {
		var item_mc:Object = s_conf.main.cp_cell_control_mc.kick_mc;
		var vp:Object = s_conf.main.cp_cell_control_mc.camera_mc;
		if (vp.visible == true) {
			vp.visible = false;			
		}
		item_mc.visible = (item_mc.visible == true)?false:true;	
	}
	private function onResBtn(e:MouseEvent):void {
		var item_mc:Object = s_conf.main.cp_cell_control_mc.result_mc;		
		item_mc.visible = (item_mc.visible == true)?false:true;	
	}
	private function onTimeBtn(e:MouseEvent):void {
		var item_mc:Object = s_conf.main.cp_cell_control_mc.time_mc;		
		item_mc.visible = (item_mc.visible == true)?false:true;	
	}
	private function onHelpBtn(e:MouseEvent):void {
		var item_mc:Object = s_conf.main.cp_cell_control_mc.help_mc;
		if (item_mc.cur_state == STATE.RIGHT) {
			item_mc.onOpenBtnClick(null);
		}
		if (item_mc.cur_state == STATE.CENTER) {
			item_mc.onCloseBtnClick(null);
		}
	}
	
	
}
}