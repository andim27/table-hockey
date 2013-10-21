package  ai {

import flash.display.*;
import flash.events.Event;
import ai.*;
import utils.MyF;
	
	public class AI_man extends AI {
	
	//зона нахождения шайбы
	//команда-владелец шайбы
	private static const OWNER_TEAM_1:uint = 1; 
	private static const OWNER_TEAM_2:uint = 2; 
	
	private var shayba_owner:uint;
	private var shayba_dx:int;//--расстояние от игрока до шайбы 
		public function AI_man(s_c:Object,parent_mc:Object):void {
			// constructor code
			super(s_c,parent_mc);			 
		}

		override public function getExternalInfo():void  {
			// code
			super.getExternalInfo();
			who_has_shayba();	
		}

		override public function analyze():void  {
			// code
			super.analyze();
			analize_1();			
		}
		private function analize_1():void {//--simple think
			var r_val=MyF.random(1,100);
			switch (shayba_owner) {
				case OWNER_TEAM_2:				
				  //var cur_cmd = s_conf.main.team_2.getCmdFromStrategy()
				  //sendCommand("moveLeft");
				break;
				case OWNER_TEAM_1: //--- USER OWNE SHAYBA 
				  if (r_val <= 10) {
					// sendCommand("moveUp"); 
				  }
				  if ((r_val >= 95)&&(body_obj.time_state >=0.2)) {
					// sendCommand("moveDown"); 
				  }
				  if ((r_val >= 25)&&(r_val <= 75)) {
					 sendCommand("moveStop");					 
				  }
				  if ((r_val >= 50)&&(r_val <= 52)) {
					 sendCommand("rotateY",{angle:5});					 
				  }
				  if ((r_val >= 55)&&(r_val <= 58)) {
					 sendCommand("rotateY",{angle:-5});
					 sendCommand("moveUp"); 
				  }
				break;
				
			}
		}
		private function analize_2():void {//--middle think
		}
		private function analize_3():void {//--profi think
		}
		override public function sendCommand(cmd:String="",param:Object=null):void  {
			super.sendCommand(cmd,param);			
			body_obj.command(cmd,param);
		}
		private function who_has_shayba():void  {//---вычислить в какой зоне шайба
			if (s_conf.main.shayba.follow_team_n ==2) {//--computer has
				shayba_owner=OWNER_TEAM_2;
			} else {
				shayba_owner=OWNER_TEAM_1;
			}
		}
		//-----------------------Events-------------------


	}
	
}
