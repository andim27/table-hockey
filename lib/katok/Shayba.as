package katok {

	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	
	import events.CPEvents;
	import events.GameEvents;
	import utils.MyF;
	import utils.STATE;
	import com.greensock.*;
	import com.greensock.easing.*;

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

	public class Shayba extends Sprite {
		public var cur_state:uint;
		public var model:Cylinder;
		public var s_conf:Object;
		private var kuda:int; //--- вверх двигаемся или вниз--
		private var min_x:int;
		private var max_x:int;
		private var min_z:int;
		private var max_z:int;
		private var force:int; //---force kick
		private var angle:int;//---angel rotate
		private var path_len:int;//---длина пройденного пути--
		private var katok_x0:int;//--отсчет катка
		private var katok_y0:int;//--
		private var katok_z0:int;//--
		private var dx_zone_man:Number;//---габариты зоны игрока
		private var dz_zone_man:Number;//---габариты зоны игрока
		public var zone_man_n:uint;//--номер man в которой находится шайба
		private var dtik_step:Number;//--шаг тика чтобы убрать повторения операций
		public var zone_team_n:uint;//--номер team в которой находится шайба
		public var  radius:Number;		
		
		public var is_free:Boolean=false;//--если шайба свободна и никто к ней не бежит
		public var time_state:Number;//--время нахождения в состоянии в сек
		public var follow_man_n:int; //--к кому привязана при движении
		public var follow_team_n:int;//--к какой команде
		public var follow_man:Object;
		private var s_k:Sound;
		
		public function Shayba(s_c:Object) {	
			s_conf=s_c;
			initVars(s_c);
			initEvents();
			loadModel();
		}
	    private function initVars(s_c:Object):void {
			force=2;
			angle=0;
			time_state=0;
			dtik_step=3/s_conf.stage.frameRate;
			min_z = - s_conf.main.kt.ice_L/2;
			max_z = s_conf.main.kt.ice_L/2;
			min_x = - s_conf.main.kt.ice_W/2;
			max_x =  s_conf.main.kt.ice_W/2;
			katok_x0=s_conf.main.kt.model.x;
			katok_y0=s_conf.main.kt.model.y;
			katok_z0=s_conf.main.kt.model.z;
			follow_team_n=0; //----
			follow_man_n=0;
			zone_man_n=0;
			zone_team_n=0;
			dx_zone_man=s_conf.main.kt.ice_W*0.12;
			dz_zone_man = s_conf.main.kt.ice_L * 0.5;
			s_k = new stick_kick();
		}

		public function loadModel():void {
			cur_state=STATE.LOAD_MODEL;
			model = new Cylinder({material:"black",segmentsH:1,segmentsW:6,height:1,radius:1,x:0,y:s_conf.ice_H-3,z:0,bothsides:false});
			model.visible=false; // --visible when fall down only!!!
			//model.addEventListener(MouseEvent3D.MOUSE_DOWN,doClick);
			model.ownCanvas=true;
			s_conf.scene.addChild(model);
			model.addEventListener(MouseEvent3D.MOUSE_DOWN,doClick);
			//trace("Shayba onSuccess!");
		}
		private function calcTimeState():void {
	 		time_state=time_state+(1/s_conf.stage.frameRate);
			//if (time_state >=2) {trace("SHAYBA time_state="+time_state+" cur_state="+cur_state);}
			
 		}
		private function calc_is_shayba_free():void {//--данное понятие индивидуально и зависит от AI а не от шайбы
			if ((cur_state == STATE.MOVE)&&(time_state >= 2)&&(follow_man_n == 0)) {
				is_free=true;
				//trace("Shayba is FREE!");
			} else {
				is_free=false;
			}
		}
		public function fallDownCenter():void {
			fallDown({x:int(s_conf.main.kt.ice_W/2),y:int(s_conf.main.kt.ice_W/2),z:int(s_conf.main.kt.ice_L/2)});
		}
		public function fallDown(p:Object):void {			
		    var timeline:TimelineLite = new TimelineLite();
			var y_to:int=model.y;
			model.x=p.x;
			model.y=p.y;
			model.z=p.z;
			model.visible=true;
			//trace("Shayba call fallDown:start");
		    timeline.append( new TweenLite(model, 1, {y:katok_y0+y_to}) );
	  		timeline.append( new TweenLite(model, 0.2, {y:katok_y0+y_to-10,rotationZ:90}) );
			timeline.append( new TweenLite(model, 0.2, {y:katok_y0+y_to,rotationZ:130}) );
			timeline.append( new TweenLite(model, 0.2, {y:katok_y0+y_to-7,rotationZ:180}) );
			timeline.append( new TweenLite(model, 0.2, {y:katok_y0+y_to,rotationZ:0, onComplete:throwImpulse}) );
		}
		private function throwImpulse():void {//--случайное движение после вбрасывания
		
		  s_conf.main.ph_engine.startWork();
		  s_conf.main.ph_engine.ballToCenter();
		  //trace("Shayba s_conf.main.ph_engine:startWork");
		  s_conf.main.team_2.startThink();//---включить ИИ для команды компьютера
		  //var myF:MyF=new MyF();
		  var force:int=MyF.random(2,7);//s_conf.main.cp_cell_control_mc.force_cur;
		  var kuda:uint=MyF.random(1,100);
		  kuda=(kuda >50)?1:-1;
		  var ang:int=MyF.random(30,150);
		  //trace("MY random!!!force="+force+" ang="+ang);
	      cur_state=STATE.MOVE;
		  time_state=0;
		  follow_team_n=0;//--не за кем следить до прилипания
		  follow_man_n=0;
		  follow_man=null;//--не за кем следить до прилипания
		  //trace("Shayba call fallDown:throwImpulse force="+force+" kuda*ang="+kuda*ang);
		  if (s_conf.main.can_sound == true) {
			  s_k.play();		  	
		  }
		  s_conf.main.ph_engine.impulse(force,kuda*ang);
		
		
		}
		public function checkNearMan():void { //--проверить кто рядом к кому привязатся--
		try {	
			
			if (time_state <= (dtik_step)){return;}//---СРАЗУ ПРОВЕРЯТЬ НЕЛЬЗЯ ШАЙБА ДОЛЖНА ПРОЙТИ МИН РАССТОЯНИЕ
			var place:Object={x:model.x,y:model.y,z:model.z};
			var ch_1:Object = s_conf.main.team_1.checkShaybaNearMan(place);
			if (ch_1 != null) { //--шайба возле члена 1-й команды
				follow_man=ch_1.man;
			    follow_man_n  = ch_1.nomer;
				follow_team_n = ch_1.team_nomer;
				s_conf.main.team_1.active_nomer = ch_1.nomer;
				s_conf.main.cp_cell_control_mc.kick_mc.setActiveNomerRotation(ch_1.man.model.rotationY);
				//trace("SHAYBA follow_to n="+ follow_man_n+" n_team="+follow_team_n);
				cur_state=STATE.FOLLOW_TO;
				time_state=0;
				s_conf.main.cp_cell_control_mc.setShootVisible(follow_man_n,true);//--Show cell shoot_btn--
				return;
			}
			//return;//-!!!! ПОКА ТОЛЬКО К СВОИМ !!!--
			var ch_2:Object = s_conf.main.team_2.checkShaybaNearMan(place);
			if (ch_2 != null) { //--шайба возле члена 2-й команды
				follow_man    = ch_2.man;
			    follow_man_n  = ch_2.nomer;
				follow_team_n = ch_2.team_nomer;
				s_conf.main.team_2.active_nomer=ch_2.nomer;
				//trace("SHAYBA follow_to n="+ follow_man_n+" n_team="+follow_team_n);
				cur_state=STATE.FOLLOW_TO;
				time_state=0;
				return;
			}
			follow_man_n=0;
		    follow_team_n=0;
		} catch (err:Error) {
		}
			return;
		}
		private function checkGoal():void {
		var e:GameEvents;
		try {	
			if (s_conf.main.ph_engine.cur_state == STATE.GOAL_1) {
			  	cur_state=STATE.GOAL_1;
				time_state=0;
				e=new GameEvents(GameEvents.GOAL);		
				e.event_obj={nomer:1};
				dispatchEvent(e);
				//trace("GOAL 1 !!!!!!!!");
				s_conf.main.cp_cell_control_mc.result_mc.setGoal(1);
				return;
			}
			if (s_conf.main.ph_engine.cur_state == STATE.GOAL_2) {
			  	cur_state=STATE.GOAL_2;
				time_state=0;
				e=new GameEvents(GameEvents.GOAL);		
				e.event_obj={nomer:2};
				dispatchEvent(e);
				//trace("GOAL 2 !!!!!!!!");
				s_conf.main.cp_cell_control_mc.result_mc.setGoal(2);
			}
		} catch (err:Error) {
		}
		return;
		}
		private function checkLimit():Boolean {
			if ((model.x > min_x)&&(model.x < max_x) && (model.z > min_z) && (model.z < max_z) ){
				//trace("checkLimit TRUE");
				return true;
			} else {
				//trace("checkLimit FALSE x="+model.x+" z="+model.z+" min_x="+min_x+" max_x="+max_x+" min_z="+min_z+" max_z="+max_z);
				return false;
			}
		}
		public function calcNewPos():void {
			//trace("calcNewPos Before: x="+model.x+" z="+model.z+" ball.px="+s_conf.main.ph_engine.ball.px+" ball.py="+s_conf.main.ph_engine.ball.py);
			if ((s_conf.main.ph_engine.ball.px >= 0)&&(s_conf.main.ph_engine.ball.py >= 0)) {
				model.x=katok_x0+(s_conf.main.ph_engine.ball.px/5);//-s_conf.main.kt.ice_W;
				model.z=katok_z0+s_conf.main.ph_engine.ball.py/5;// --5 becouse katok.firstscace=2
			}
			
		}
		public function setForce(f:int):void {
			force=f;			
		}
		private function calcFollowPos():void  {
			if (follow_man != null) {
				//model.x=follow_man.x+1;
				//model.z=follow_man.z-3;
				//trace("SHAYBA calcFollowPos");
				model.x=follow_man.klushka.x;
				model.z=follow_man.klushka.z;

			}
		}
		private function calcZoneManNomer():void {//--ВЫЧИСЛИТЬ ИГРОКА В ЧЬЕЙ ЗОНЕ НАХОДИТСЯ ШАЙБА
			if (s_conf.main.team_2.team_items == null){return;}
			var dx_to_man:Number;
			var cur_man:Object;
			for (var i:int=1; i <= 6; i++) {//--для команды противника
				cur_man=s_conf.main.team_2.team_items[i-1];
				if (cur_man.nomer != 6 ) {//--ДЛЯ ИГРОКОВ 
					dx_to_man=Math.abs(model.x-cur_man.model.x);
					//dz_to_man=Math.abs(model.x-cur_man.model.z);
					if ((dx_to_man <= dx_zone_man)&&(model.z >=cur_man.min_z)&&(model.z <= cur_man.max_z))  {
						zone_team_n=2;
						zone_man_n=cur_man.nomer;
						//trace("SHAYBA team_2 zone_man_n="+zone_man_n+" dx_to_man="+dx_to_man);
						return;
					}
				}
			}//--для команды противника
			//--не в зоне команды противника
			zone_team_n=0;
			zone_man_n=0;
			//trace("SHAYBA team_2 zone_man_n=0(free) time_state="+time_state);
		}
		public function getZone():int {//--определить в какой зоне нахожусь < 20 user;; >20 computer
		 var zone:int=0;
		 var half_ice_L:Number=s_conf.main.kt.ice_L*0.5;
		 var half_ice_W:Number=s_conf.main.kt.ice_W*0.5;
		 var center_ice_left:Number =s_conf.main.kt.ice_W*0.7;
		 var center_ice_right:Number=s_conf.main.kt.ice_W*0.3;
		 //----USER ZONE----------
		 if (model.z > half_ice_L) { 
			  if (model.x > center_ice_left) {
				  zone=10;//ZONE_1_LEFT;//--user 
			  }
			  if ((model.x > center_ice_left)&&(model.x < center_ice_right)) {
				  zone=11;//ZONE_1_CENTER;//--user 
			  }
			  if (model.x < center_ice_right) {
				  zone=12;//ZONE_1_RIGHT;//--user 
			  }
		 }
		 //---COMPUTER ZONE--------
		 if (model.z < half_ice_L ) { 
			  if (model.x > center_ice_left) {
				  zone=20;//ZONE_2_LEFT;//--user 
			  }
			  if ((model.x > center_ice_left)&&(model.x < center_ice_right)) {
				  zone=21;//ZONE_2_CENTER;//--user 
			  }
			  if (model.x < center_ice_right) {
				  zone=22;//ZONE_2_RIGHT;//--user 
			  }
		 }
		return zone;	
		}
		//------------------EVENTS------------------------
		private function doClick(e:MouseEvent3D):void {
			//model.z=model.z-0.5;
        	//Debug.trace("CLICK Shayba: model x="+model.x+" y="+model.y+" z="+model.z+" follow_man_n="+follow_man_n+" follow_team_n="+follow_team_n+" zone_man_n="+zone_man_n);
			//cur_state=STATE.STOP;
			if (follow_team_n == 0) {
				s_conf.main.ph_engine.startWork();
				s_conf.main.ph_engine.impulse(MyF.random(4,10),MyF.random(1,359));
			}
		}
		public function onShoot(e:GameEvents):void {
		  
		  if (s_conf.main.can_sound==true) {
		  	var s_k:Sound=new stick_kick();
		  	s_k.play();
		  }
		  force=e.event_obj.force;
		  trace("SHAYBA CATCH SHOOT! from "+e.event_obj.nomer+" e.event_obj.k_force="+force+" e.event_obj.angle="+e.event_obj.angle+"  s_conf.main.ph_engine="+ s_conf.main.ph_engine);		 
		  s_conf.main.ph_engine.startWork();
		  s_conf.main.ph_engine.impulse(force,e.event_obj.angle);
		  cur_state=STATE.MOVE;
		  time_state=0;
		  follow_man_n=0;
		  follow_team_n=0;
		}
		public function onShootToPoint(p:Object):void {
			time_state=0;
			follow_man_n=0;
			follow_team_n=0;
			s_conf.main.ph_engine.startWork();
			//trace("SHAYBA b)onShootToPoint point.x="+p.point.x+" point.z="+p.point.z);
			var x_to:Number=p.point.x*5;//---перевод в координаты физ.движка 5 - т.к каток scale =2
			var y_to:Number=p.point.z*5;//---перевод в координаты физ.движка
			s_conf.main.ph_engine.moveToPoint(x_to,y_to);			
			//s_conf.main.ph_engine.impulse(force,180);
			cur_state=STATE.MOVE;
			
			//trace("SHAYBA e)onShootToPoint x_to="+x_to+" y_to="+y_to);
		}

		//-------------------------------events-------------
		private function initEvents():void {
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			addEventListener(GameEvents.GAME_START,onShaybaGameStart);
		}
		private function onShaybaGameStart(e:GameEvents):void {
			model.visible=true;
		}
		private function onEnterFrame(e:Event):void {
			calc_is_shayba_free();
			if (cur_state == STATE.FOLLOW_TO) {
				calcZoneManNomer();
				calcTimeState();
				calcFollowPos();
				//trace("SHAYBA FOLLOW x="+model.x+" z="+model.z);
			}
			if (cur_state == STATE.GOAL_1) {
			}
			if (cur_state == STATE.GOAL_2) {
			}
			if (cur_state == STATE.MOVE) {
				calcZoneManNomer();
				calcTimeState();
				calcNewPos();
				checkNearMan();
				checkGoal();								
			}
			
		}
	}
}