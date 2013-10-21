package  ai {

import flash.display.*;
import flash.events.Event;
import ai.*;
import utils.MyF;
import utils.STATE;
import utils.CMD;

public class AI_vratar extends AI {
	//public static var cur_state:uint;
	//public static const STATE_STOP:uint = 0;
	//public static const STATE_GET_INFO:uint = 1;
	//public static const STATE_THINKING:uint= 2;
	//public static const STATE_SEND_COMMAND:uint = 3;
	
	//зона нахождения шайбы
	private static const ZONE_RIGHT:uint = 1; 
	private static const ZONE_LEFT:uint = 2;
	private static const ZONE_CENTER:uint = 0;
	private static const ZONE_1:uint = 0;
	private static const ZONE_2:uint = 0;
	
	private var shayba_zone:uint;
	private var shayba_dx:int;//--расстояние от центра катка до шайбы по х
		public function AI_vratar(s_c:Object,parent_mc:Object):void {
			// constructor code
			super(s_c,parent_mc);
			//trace("AI_vratar!!!! nomer="+body_obj.nomer+" team_nomer="+body_obj.team_nomer);
		}

		override public function getExternalInfo():void  {
			// code
			super.getExternalInfo();
			where_is_shayba();
	
		}

		override public function analyze():void  {
			// code
			super.analyze();
			//trace("AI_vratar : body_obj cur_state="+body_obj.cur_state+" time_state="+body_obj.time_state+" vratar.x="+body_obj.model.x+" min_x="+body_obj.min_x+" max_x="+body_obj.max_x);
			var r_val:uint=MyF.random(1,100);
			/*if (((body_obj.cur_state =="stop")||(body_obj.cur_state =="loaded") )) {
				sendCommand("moveLeft"); 
			}
			if ((r_val >= 50)&&(r_val <= 55)&&(body_obj.time_state >=0.2)) {
					 sendCommand("moveStop");					 
			}
			*/
			switch (shayba_zone) {
				case 22: //--TEAM_2				
				  sendCommand(CMD.ROTATE_Y,{angle:190});	
				  sendCommand(CMD.MOVE_RIGHT,{});
				break;
				case 20://--TEAM_2	
				  sendCommand(CMD.ROTATE_Y,{angle:10});	
				  sendCommand(CMD.MOVE_LEFT,{});
				break;
				case 21://--CENTER
				  sendCommand(CMD.ROTATE_Y,{angle:0});	
				  sendCommand(CMD.MOVE_STOP,{});
				break;
				case 10://--CENTER --TEAM_1 user
				  sendCommand(CMD.ROTATE_Y,{angle:0});	
				  sendCommand(CMD.MOVE_STOP,{});
				break;
				case 11://--TEAM_1 use
				  sendCommand(CMD.ROTATE_Y,{angle:0});	
				  sendCommand(CMD.MOVE_STOP,{});
				break;
				case 12://--TEAM_1  use		
				  sendCommand(CMD.ROTATE_Y,{angle:0});	
				  sendCommand(CMD.MOVE_STOP,{});
				break;
			}
			if (body_obj.time_state >=2) {
				sendCommand(CMD.MOVE_STOP,{});
			}
			/*if (s_conf.main.shayba.follow_man_n == 6) {//--прилипла к вратарю А к Нашему?---
				var katok_point:Object = {x:0,z:0};//{x:(s_conf.main.vorota_1.model.x+dx),z:s_conf.main.vorota_1.model.z};
				katok_point.x=MyF.random(5,s_conf.main.kt.ice_W);
				katok_point.z=MyF.random(body_obj.model.z,s_conf.main.kt.ice_L);
				sendCommand(CMD.SHOOT_TO_POINT,{point:katok_point});
				trace("AI_vratar SHOOT_TO_POINT katok_point.x="+katok_point.x+" katok_point.z="+katok_point.z);
			}
			*/
			
		}
		private function where_is_shayba():void  {//---вычислить в какой зоне шайба
		  if ((cur_state != STATE.STOP)&&(s_conf.main.shayba.model != null)) {
				shayba_zone=s_conf.main.shayba.getZone();
		  }
		}
		//-----------------------Events-------------------


	}
	
}
