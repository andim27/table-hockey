package  ai {

import flash.display.*;
import flash.events.Event;
import utils.MyF;
import utils.STATE;
import utils.CMD;

	public class AI extends Sprite {
		
	public static var cur_state:uint;		
	public var s_conf:Object;
	public var body_obj:Object;
	private var prev_better_man:uint;//--предыдущий которому был отдан пасс
	protected var prev_cmd:uint=0;//---предыдущая команда
	protected var cur_pass_cnt:uint=0;
	protected var cur_cmd:uint;
		public function AI(s_c:Object,parent_mc:Object):void {
			// constructor code
			s_conf=s_c;
			body_obj=parent_mc;
			//trace("AI parent_mc="+body_obj);
			initVars();
			initEvents(); 
			cur_state=STATE.GET_INFO;
		}
		public function initVars():void {
			// code
			cur_state=STATE.STOP;
			prev_better_man=6;
			cur_pass_cnt=0;
		}
		public function initEvents():void {
			// code
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		public function getExternalInfo():void {
			// code
			if (s_conf.main.lg == 0) {
				cur_state=STATE.STOP
			} else {
				cur_state=STATE.GET_INFO;	
			}
			
		}
		public function getBodyInfo():void {
			// code
			cur_state=STATE.GET_INFO;
		}
		public function analyze():void {
			// code
			cur_state=STATE.THINKING;
		}
		public function sendCommand(cmd:uint=0,param:Object=null):void  {
			cur_state=STATE.SEND_COMMAND;
			cur_cmd=cmd;
			// code
			body_obj.command(cmd,param);
		}
		public function startThink():void {
			cur_state=STATE.GET_INFO;
		}
		public function stopThink():void {
			cur_state=STATE.STOP;
		}
		public function findBetterMan():Object {
			//---simple method
			var r_val:uint=MyF.random(1,5);
			while ((r_val == body_obj.nomer)||(r_val == prev_better_man)) {
				r_val=MyF.random(1,5);
			}
			//trace("AI findBetterMan="+r_val+"  body_obj.nomer="+body_obj.nomer+" prev_better_man="+prev_better_man);
			prev_better_man=r_val;
			return s_conf.main.team_2.getMan(r_val);
		}
		public function findNearestToShayba():Object {
			return {};
		}
		public function findVorotaPoint(ai_type:int):Object {
			var res:Object;
			var dx:Number;//--дельта от центра задней стойки
			if (ai_type == 1) {//---первый уровень
				dx=MyF.random(s_conf.main.vorota_1.model.x-s_conf.main.vorota_1.vorota_W/2,
							  s_conf.main.vorota_1.model.x+s_conf.main.vorota_1.vorota_W/2
							  );
				res={x:s_conf.main.vorota_1.model.x+dx,z:s_conf.main.vorota_1.model.z};
			}
		
			return res;
		}
		public function passToMan(man:Object):void {
		    var man_point:Object = {x:man.klushka.x,z:man.klushka.z};//--ФИЗИЧЕСКИЕ КООРДИНАТЫ ПЕРЕДАЕМ!!!
		    sendCommand(CMD.SHOOT_TO_POINT,{point:man_point});
			prev_cmd=CMD.SHOOT_TO_POINT;
			cur_pass_cnt=cur_pass_cnt+1;
		    //trace("AI("+body_obj.nomer+") PASSED  TO nomer "+man.nomer+" cur_pass_cnt="+cur_pass_cnt+" man_point.x="+man_point.x+" man_point.z="+man_point.z);
		}
		//-----------------------Events-------------------
		private function onEnterFrame(e:Event):void {
			//trace("AI onEnterFrame ");
			if (cur_state != STATE.STOP) {
				getExternalInfo();
				getBodyInfo();
				analyze();
				//sendCommand();
			}
		 }

	}
	
}
