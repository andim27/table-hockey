package  ai {

import flash.display.*;
import flash.events.Event;
import ai.*;
import utils.MyF;
import utils.STATE;
import utils.CMD;
	public class AI_man extends AI {
	
	//зона нахождения шайбы
	//команда-владелец шайбы
	private static const OWNER_TEAM_FREE:uint = 0; 
	private static const OWNER_TEAM_1:uint = 1; 
	private static const OWNER_TEAM_2:uint = 2; 
	
	
	private var shayba_owner:uint=0;
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
		   // trace("AI_man analize_1 body_obj.nomer="+body_obj.nomer);
		try {
		   who_has_shayba();
			var r_val:uint=MyF.random(1,100);
			//trace("AI_man analize_1 shayba.time_state="+s_conf.main.shayba.time_state+" s_conf.main.shayba.is_free="+s_conf.main.shayba.is_free);
		    if ((s_conf.main.shayba.time_state >= 3)&&(shaybaInMyZone() == true)&&(s_conf.main.shayba.is_free == true)){	//(shaybaInMyZone() == true)&&					
					moveToShayba();
			}			
			//--для того укого шайба---
			if ((shayba_owner == OWNER_TEAM_2)&&(s_conf.main.shayba.follow_man_n == body_obj.nomer)) {
				//var vorota_point:Object = findVorotaPoint(1);//{x:(s_conf.main.vorota_1.model.x+dx),z:s_conf.main.vorota_1.model.z};					  
				 
				 if (r_val < 10) {
					 //trace("r_val < 10");
					 //--random shoot---------
					 var r_p:Object;
					 r_p.x=int(MyF.random(1,s_conf.main.kt.ice_W));
					 r_p.z=int(MyF.random(1,s_conf.main.kt.ice_L));
					trace("AI_man analize_1 in if follow_man_n="+s_conf.main.shayba.follow_man_n+" r_p.x="+r_p.x+" ");
					sendCommand(CMD.SHOOT_TO_POINT,{point:r_p});
					//trace("AI_man("+body_obj.nomer+")  random SHOOT_TO_POINT x="+r_p.x+" r_p.z="+r_p.z);
				 }
				 //trace("r_val < 10&&(r_val <= 30)");
				 if ((r_val >= 10)&&(r_val <= 30)) {
					   //trace("AI_MAN better_man in=");
					   var better_man:Object = findBetterMan();
					  
					   //trace("AI_MAN better_man.nomer="+better_man.nomer+" cur_pass_cnt="+cur_pass_cnt);
					  
					   if (cur_pass_cnt <= 3) {
						    //trace("AI_man("+body_obj.nomer+") passToMan="+better_man.nomer);
					   		passToMan(better_man);
					   }
					    if (r_val <= 15) {
					   		sendCommand(CMD.MOVE_UP,{time_cmd_lim:2});
						} else {
							sendCommand(CMD.MOVE_DOWN,{time_cmd_lim:2});
						}
					   return;
				 } else {
					//--держать шайбу 2 сек если не стреляем					
					  //trace("else"); 
					  if ((body_obj.cur_state != STATE.SHOOT_TO_POINT)) {
						//trace("AI_man analize_1 in if body_obj.cur_state="+body_obj.cur_state);  
						sendCommand(CMD.MOVE_UP,{time_cmd_lim:1});
						//trace("AI_man analize_1 CMD.MOVE_UP ");
						sendCommand(CMD.MOVE_DOWN,{time_cmd_lim:1});
						prev_cmd=CMD.MOVE_DOWN;
						//trace("AI_man analize_1 CMD.MOVE_DOWN ");
						if ((s_conf.main.shayba.follow_man_n == body_obj.nomer)) {
						    //trace("AI_man("+body_obj.nomer+") SHOOT_TO_VOROTA ");
							sendCommand(CMD.SHOOT_TO_GOAL,{point:findVorotaPoint(1)});
							prev_cmd=CMD.SHOOT_TO_GOAL;
							cur_pass_cnt=0;
						}
					  }
				 }//--else-
  
			}
			//--для остальных членов команды
			//trace("для остальных членов команды");
			if ((shayba_owner == OWNER_TEAM_2)&&(s_conf.main.shayba.follow_man_n != body_obj.nomer)) {
			     //---find better position for shoot
			    if (r_val >= 80) {//--simple move
					sendCommand(CMD.MOVE_DOWN,{time_cmd_lim:1}); 
					sendCommand(CMD.MOVE_UP,{time_cmd_lim:1});
					prev_cmd=CMD.MOVE_UP;
				}						
			}
		
		

		} catch (err:Error) {
		}
		
		finally {
		}
			return;						
		}
		private function shaybaInMyZone():Boolean {//--находится ли шайба в моей зоне?
			if (s_conf.main.shayba.zone_man_n == body_obj.nomer ) {
				return true;
			} else {
				return false;
			}
		}
		private function moveToShayba():void {								
			//trace("AI_MAN moveToShayba body_obj.nomer="+body_obj.nomer);
			sendCommand(CMD.MOVE_TO_POINT,{x:s_conf.main.shayba.model.x,z:s_conf.main.shayba.model.z}); //--двигатся по направлению к шайбе
									
		}

		private function analize_2():void {//--middle think
		}
		private function analize_3():void {//--profi think
		}

		private function who_has_shayba():void  {//---вычислить в какой зоне шайба
			if (s_conf.main.shayba.follow_team_n ==2) {//--computer has
				shayba_owner=OWNER_TEAM_2;
			}
			if (s_conf.main.shayba.follow_team_n ==1) {
				shayba_owner=OWNER_TEAM_1;
			}
			if ((s_conf.main.shayba.follow_team_n != 1)&& (s_conf.main.shayba.follow_team_n != 2)){
				shayba_owner=OWNER_TEAM_FREE;
			}
		}
		//-----------------------Events-------------------


	}
	
}
