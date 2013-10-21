package team{

	import flash.display.*;
	import flash.events.Event;

	/*import away3dlite.containers.*;
	import away3dlite.core.utils.*;
	*/
	import com.greensock.*;
	
	import away3d.debug.*;
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.utils.*;
	import away3d.events.*;
	import away3d.loaders.*;
	import away3d.materials.*;
	import away3d.core.render.*;
	import away3d.loaders.*;
	import away3d.primitives.*;
	
	import events.CPEvents;
	import man.Man;
	//import team.Team;
	import utils.STATE;

	public class Team extends Sprite {
		public var s_conf:Object;
		public var cur_state:uint;
		//public var site_path:String;
		public var team_items:Array;
		//private var scene:Scene3D;
		public var active_nomer:uint;//--активный номер
		
		private var team_nomer:uint;
		
		//private var first_x,first_y,first_z,first_step,first_scale,first_rotation,first_width,first_heights:int;
		//private var first_point:Object;
		public var place:Object;
		private var place_1:Object;
		private var place_2:Object;
		private var man_cnt:int;//--кол-во человек в команде
		public var field_L:int;//---длина поля где играет команда
		public var field_W:int;//---ширина поля где играет команда
		//private var path_team_1,path_team_2:Array;
		public function Team(s_c:Object,team_n:int,L:int,W:int) {		
			s_conf=s_c;
	
			field_L=L;
			field_W=W;	
			team_nomer=team_n;
			//first_point=p_team;
			//first_x=p_team.x;//--Point team 1 for first move to ice
			//first_y=p_team.y;
			//first_z=p_team.z;
			//first_step=50;//--расстояние между игроками---
			initVars();
			initEvents();
		}
		private function initVars():void {
			cur_state=STATE.INIT;
			man_cnt=6;//
			active_nomer=1;
			//initPathTeam(team_nomer);
			place_1 = new Object();
			/*
			1 - центральный нападающий
			2 - левый нападающий
			3 - правый нападающий
			4 - левый защитник
			5 - правый защитник
			6 - вратарь
			*/
			var h_0:int=s_conf.ice_H*2;//--высота над льдом--(минус)!!!
			var dx_0:int=0;//(s_conf.ice_w/2)*4;//--сдвиг на центр катка
			var dz_0:int=int(field_L/2);
			//---начало катка, оно поднято вверх т.к. центр в углу катка
			//---а при повороте камеры надо смотреть на центр а не на угол
			//--все от того что физ.двиг считает от лев.верхн. угла
			var dKatok_x:int=s_conf.main.kt.model.x;
			var dKatok_y:int=s_conf.main.kt.model.y;
			var dKatok_z:int=s_conf.main.kt.model.z;
			// -field_W так как модель стала с пивотом (x) - налево (z) - на нас (y) - вверх
			
			//- определить пределы движения исходя из размеров катка
			var man_min_x:int=1;
			var man_max_x:int=s_conf.main.kt.ice_W;
			var man_min_z:int=s_conf.main.kt.ice_L*0.05;
			var man_max_z:int=s_conf.main.kt.ice_L*0.98;
			
			var vratar_min_x:int=s_conf.main.kt.ice_W*0.4;
			var vratar_max_x:int=s_conf.main.kt.ice_W*0.6;
			var vratar_min_z:int=s_conf.main.kt.ice_L*0.1; //--на всякий случай
			var vratar_max_z:int=s_conf.main.kt.ice_L*0.85;
			
			//- обьект пределов для man
			var man_limits:Object={min_x:man_min_x, max_x:man_max_x,min_z:man_min_z,max_z:man_max_z};
			//- обьект пределов для vratar
			var vratar_limits:Object={min_x:vratar_min_x, max_x:vratar_max_x, min_z:vratar_min_z, max_z:vratar_max_z};			
			//--------------------------------------1-я команда------------------------------------
			//- обьект пределов для левый напад.
			var man_limits_1:Object={min_x:man_min_x, max_x:man_max_x,min_z:s_conf.main.kt.ice_L*0.1,max_z:s_conf.main.kt.ice_L*0.45};
			//- обьект пределов для левый защитник.
			var man_limits_2:Object={min_x:man_min_x, max_x:man_max_x,min_z:s_conf.main.kt.ice_L*0.55,max_z:s_conf.main.kt.ice_L*0.97};
			//- обьект пределов для центр. напад.
			var man_limits_3:Object={min_x:man_min_x, max_x:man_max_x,min_z:s_conf.main.kt.ice_L*0.25,max_z:s_conf.main.kt.ice_L*0.50};
			//- обьект пределов для прав. защитн.
			var man_limits_4:Object={min_x:man_min_x, max_x:man_max_x,min_z:s_conf.main.kt.ice_L*0.55,max_z:s_conf.main.kt.ice_L*0.97};
			//- обьект пределов для правый напад.
			var man_limits_5:Object={min_x:man_min_x, max_x:man_max_x,min_z:s_conf.main.kt.ice_L*0.1,max_z:s_conf.main.kt.ice_L*0.45};
			//--------------------------------------2-я команда------------------------------------
			//- обьект пределов для левый напад.
			var man_limits_12:Object={min_x:man_min_x, max_x:man_max_x,min_z:s_conf.main.kt.ice_L*0.55,max_z:s_conf.main.kt.ice_L};
			//- обьект пределов для левый защитник.
			var man_limits_22:Object={min_x:man_min_x, max_x:man_max_x,min_z:s_conf.main.kt.ice_L*0.15,max_z:s_conf.main.kt.ice_L*0.45};
			//- обьект пределов для центр. напад.
			var man_limits_32:Object={min_x:man_min_x, max_x:man_max_x,min_z:s_conf.main.kt.ice_L*0.55,max_z:s_conf.main.kt.ice_L*0.75};
			//- обьект пределов для прав. защитн.
			var man_limits_42:Object={min_x:man_min_x, max_x:man_max_x,min_z:s_conf.main.kt.ice_L*0.15,max_z:s_conf.main.kt.ice_L*0.45};
			//- обьект пределов для правый напад.
			var man_limits_52:Object={min_x:man_min_x, max_x:man_max_x,min_z:s_conf.main.kt.ice_L*0.55,max_z:s_conf.main.kt.ice_L};

			place_1 = {
			1: { x:dKatok_x+field_W*0.90+dx_0,   y:dKatok_y+h_0, z:dKatok_z+field_L * 0.44, limits:man_limits_1 },
			2: { x:dKatok_x+dx_0+field_W * 0.7,  y:dKatok_y+h_0, z:dKatok_z+field_L * 0.75, limits:man_limits_2 },
			3: { x:dKatok_x+dx_0+field_W * 0.5,  y:dKatok_y+h_0, z:dKatok_z+field_L * 0.45, limits:man_limits_3 },
			4: { x:dKatok_x+dx_0+field_W * 0.35, y:dKatok_y+h_0, z:dKatok_z+field_L * 0.75, limits:man_limits_4 },
			5: { x:dKatok_x+dx_0+field_W * 0.10, y:dKatok_y+h_0, z:dKatok_z+field_L * 0.45, limits:man_limits_5 },
			6: { x:dKatok_x+field_W*0.5,         y:dKatok_y+h_0, z:dKatok_z+field_L * 0.85, limits:vratar_limits}
			};
			place_2 = {
			1: { x:dKatok_x+dx_0+field_W * 0.90, y:dKatok_y+h_0, z:dKatok_z+field_L * 0.9, limits:man_limits_12 },
			2: { x:dKatok_x+dx_0+field_W * 0.8,  y:dKatok_y+h_0, z:dKatok_z+field_L * 0.25, limits:man_limits_22 },
			3: { x:dKatok_x+dx_0+field_W * 0.5,  y:dKatok_y+h_0, z:dKatok_z+field_L * 0.56, limits:man_limits_32 },
			4: { x:dKatok_x+dx_0+field_W * 0.25, y:dKatok_y+h_0, z:dKatok_z+field_L * 0.25, limits:man_limits_42 },
			5: { x:dKatok_x+dx_0+field_W * 0.10, y:dKatok_y+h_0, z:dKatok_z+field_L * 0.9, limits:man_limits_52 },
			6: { x:dKatok_x+field_W*0.5,         y:dKatok_y+h_0, z:dKatok_z+field_L * 0.22, limits:vratar_limits }
			};
			initPlaceTeam();
		}
		private function initPlaceTeam():void {
			if (team_nomer==1) {
				place=place_1;
			}
			if (team_nomer==2) {
				place=place_2;
			}
			cur_state=STATE.INIT_PLACE;
		}
		public function show():void {
			team_items=new Array();
			for (var i:uint = 1; i <= man_cnt; i++) {
				var first_point:Object = new Object();
				first_point.x=place[i].x;
				first_point.y=place[i].y;
				first_point.z=place[i].z;
				first_point.limits=place[i].limits;
				//trace("Team ("+team_nomer+") cur_state="+cur_state);
				addMan(new Man(s_conf,first_point,i,team_nomer));
			}
			cur_state=STATE.INIT_ALL;//"initall";
			//trace("Team show end +cur_state=" + cur_state);			
		}
		public function manCommand(n:int,cmd:uint,p:Object=null):void {
		  trace("TEAM manCommand "+n);
		  for ( var i:uint = 1; i <= man_cnt; i++) {
			  if (team_items[i-1].nomer == n) {
			      team_items[i-1].command(cmd,p); 
				  break;
			  }
		  }
		}
		public function allCommand(cmd:uint,p:Object=null):void {
		  //trace("TEAM manCommand "+n);
		  for ( var i:uint = 1; i <= man_cnt; i++) {			 
			    team_items[i-1].command(cmd,p); 
		  }
		}
		public function startThink():void {		  
		  for ( var i:uint = 1; i <= man_cnt; i++) {			  
			      team_items[i-1].mind.startThink(); 							  
		  }
		}
		public function stopThink():void {		
		  for ( var i:uint = 1; i <= man_cnt; i++) {			  
			      team_items[i-1].mind.stopThink(); 							  
		  }
		}
		public function getMan(n:uint):Object {
		  //trace("TEAM manCommand "+n);
		  for ( var i:uint = 1; i <= man_cnt; i++) {
			  if (team_items[i-1].nomer == n) {
			      return team_items[i-1]; 				
			  }
		  }
		  return null;
		}
		private function addMan(obj:Man):void {
			
			team_items.push(obj);
		}
		private function teamReady():Boolean {
			var res:Boolean=true;
			var l:int=team_items.length-1;
			for (var i:int=0; i<=l; i++) {
				if (team_items[i].cur_state==STATE.LOADED) {
					continue;
				} else {
					return false;
				}
			}
			return res;
		}
		public function checkShaybaNearMan(p:Object):Object {//--проверить по команде кто рядом с шайбой
		    var l:int=team_items.length-1;
			var dx:int;
			var dz:int;
			//var dShaybaX:int;
			//var dShaybaZ:int;
			var dShaybaZona:Number=team_items[i].man_w/1.5;
			for (var i:int=0; i<=l; i++) {
				if (team_items[i].nomer == 6){continue;}//Возле вратаря НЕ ПРОВЕРЯЕМ!!
				dx=Math.abs(team_items[i].model.x - p.x);
				dz=Math.abs(team_items[i].model.z - p.z);
			    //dShaybaX=Math.abs(team_items[i].klushka.x - p.x);
				//dShaybaZ=Math.abs(team_items[i].klushka.z - p.x);
				if ((dx < dShaybaZona) && (dz < dShaybaZona)) {
					return {man:team_items[i],nomer:team_items[i].nomer,team_nomer:team_items[i].team_nomer};
				}
			}
			return null;
		}
		private function initEvents():void {
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		 
		private function onEnterFrame(e:Event):void {
			if (cur_state==STATE.INIT_ALL) {
				if (teamReady()==true) {
					cur_state=STATE.READY;
				}
			}
		}
	}
}