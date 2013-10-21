package phn
{	
	import cx.CxFastAllocList_Callback;
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import nape.*;
	import nape.Const;
	import nape.Config;
	import nape.callbacks.*;
	import nape.dynamics.*;
	import nape.phys.*;
	import nape.space.*;
	import nape.geom.*;
	import nape.util.*;
	import utils.STATE;
	
	//import nape.dynamics.Arbiter;
	//import nape.phys.PhysObj;
	//import cx.CxFastAllocList_Callback;
	//import nape.space.Space;
	
	import flash.Boot;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import flash.utils.getQualifiedClassName;
	
	public class PHN_pnysics extends Sprite 
	{
		public var cur_state:uint;
		public var working:Boolean = false;//--Запускает двиг

		public var angle_obj:Number; //--угол поворота обьекта что движется
		
		public var FIELD_W:int = 300;
		public var FIELD_H:int = 600;
		public var WALL_THICKNESS:int = 300;
		private var space:Space;
        private var g:Sprite = new Sprite();
        private var timeStep:Number = 1 / 50.0;
		 
		public var vorota_obj_1:PhysObj;
        public var vorota_obj_2:PhysObj;
		//---- WALLS--------------------
		public var w_top:PhysObj;
		public var w_left:PhysObj;
		public var w_right:PhysObj;
		public var w_bottom:PhysObj;
		//---- ANGLE-WALL--------------
		public var ice:PhysObj;
		public var w_top_left:PhysObj;
		public var w_top_right:PhysObj;
		
		public var w_bottom_left:PhysObj;		
		public var w_bottom_right:PhysObj;
		private var angle_wall_w:Number;
		public var staticPlatformType:int;
		public var dynamicBallType:int;
		//--- STOYKI ------------------
		public var st_Left_1:PhysObj;
		public var st_Top_1:PhysObj;
		public var st_Right_1:PhysObj;
		
		public var st_Left_2:PhysObj;
		public var st_Top_2:PhysObj;
		public var st_Right_2:PhysObj;
		
		public var v_goal_line_1:PhysObj;
			
		public var vorota_h:int;
		public var vorota_w:int;
		public var v1_line_x:int;
		public var v2_line_x:int;
		public var v1_line_y:int;
		public var v2_line_y:int;
		public var v1_line_left_x:int;
		public var v1_line_right_x:int;
		
		public var v1_line_top_y:int;
		public var v1_line_bottom_y:int;
		
		public var v2_line_top_y:int;
		public var v2_line_bottom_y:int;
		//--VRATAR ----------------------
		public var vratar_1:PhysObj;
		public var vratar_2:PhysObj;
		public var vratar_step_x:Number;
		
        private var px:Number; 
		private var py:Number;
		private var mDwn:Boolean;
        public  var ball:PhysObj;
		public  var t_txt:TextField;
		
        public function PHN_pnysics() {
			initAll();
			t_txt = new TextField();
			t_txt.width = FIELD_W;
            addChild(t_txt);
        }
		private function initAll():void {
		    //stage.quality = StageQuality.MEDIUM;			
			cur_state = STATE.INIT;
			dynamicBallType = CbType.get(); 
			staticPlatformType = CbType.get();
			new Boot();
			createWorld();
			createWalls();
			createAngleWalls();
			createBall();
			createVorota();
			createVratar();
			initEvents();
			initCollisionEvents();
			//startWork();
		}
		private function initEvents():void
		{
			//set up events
            addEventListener(Event.ENTER_FRAME, enterFrame);
			//stage.addEventListener(MouseEvent.CLICK, mouseClICK);
		}
		public function reStartWork():void {		 
		 working = true;
		 initAll();
		}
		public function startWork():void {		 
		 working=true;
		}
		public function stopWork():void {		
		 working=false;
		}
		public function ballToCenter():void {
			ball.px = FIELD_W / 2;
			ball.py = FIELD_H / 2;
		}
		private function initCollisionEvents():void
		{
						
			ball.cbOutOfBoundsDef = ball.cbWakeDef = ball.cbSleepDef = false;
			ball.cbOutOfBounds = ball.cbWake = ball.cbSleep = true;

			space.addCbBegin(dynamicBallType, staticPlatformType);
			space.addCbEnd(dynamicBallType, staticPlatformType);
			space.addCbBegin(dynamicBallType, staticPlatformType);
			space.addCbEnd(dynamicBallType, staticPlatformType);
			space.addCbPostSolve(dynamicBallType, staticPlatformType);
								
			w_top.cbType    = staticPlatformType;
			w_right.cbType  = staticPlatformType; 
			w_bottom.cbType = staticPlatformType;
			w_left.cbType   = staticPlatformType;
			
			w_top.data    = "w_top";
			w_right.data  = "w_right";
			w_left.data   = "w_left";
			w_bottom.data = "w_bottom";
			
			ball.cbType = dynamicBallType; 
			ball.data   = "ball";
			
			space.addCbPreBegin(dynamicBallType, staticPlatformType, preBegin);
			space.addCbPreSolve(dynamicBallType, staticPlatformType, preSolve);
	
		}
		/**
		 * @param obj
		 */
		
		private function preBegin(obj:Arbiter):void
		{
			//t_trace("preBegin p1.px="+obj.p1.px+" p1.py="+obj.p1.py+" p2.px="+int(obj.p2.px)+" p2.py="+int(obj.p2.py));
		}
		
		/**
		 * @param obj
		 */
		 
		private function preSolve(obj:Arbiter):void
		{
			//t_trace("preSolve");
		}

		private function createWorld():void
		{
		     space = new UniformSleepSpace(new AABB(0, 0, FIELD_W, FIELD_H), 15, new Vec2(0, 0));			 
		}
		

		
		private function createWalls():void
		{
		    space.addObject(w_top = Tools.createBox(FIELD_W/2,  -(WALL_THICKNESS/2), FIELD_W,  WALL_THICKNESS+(FIELD_H*0.03), 0, 0, 0, true, Material.Ice));//---top
            //addChild(w_top.graphic);
           
			space.addObject(w_right = Tools.createBox(FIELD_W+(WALL_THICKNESS/2), FIELD_H/2, WALL_THICKNESS, FIELD_H, 0, 0, 0, true, Material.Ice));//--right
            //addChild(w_right.graphic);
           			
			space.addObject(w_bottom = Tools.createBox((FIELD_W/2), FIELD_H+(WALL_THICKNESS/2),  FIELD_W, WALL_THICKNESS+(FIELD_H*0.03),  0, 0, 0, true, Material.Ice));//--bottom
            //addChild(w_bottom.graphic);
            
			space.addObject(w_left = Tools.createBox(-(WALL_THICKNESS/2), FIELD_H/2, WALL_THICKNESS, FIELD_H,  0, 0, 0, true, Material.Ice));//--left
            //addChild(w_left.graphic);
						
			// Add the line defining user mouse movements
			g.graphics.lineStyle(1, 0, 1);
			addChild(g);   	
		}
		private function createAngleWalls():void
		{
		    angle_wall_w = FIELD_W / 8;
			space.addObject(w_top_left = Tools.createBox(0,  0, angle_wall_w,  angle_wall_w, 0, 0, 0, true, Material.Ice));//---top
            addChild(w_top_left.graphic);
            w_top_left.a = 45;
		    w_top_left.graphic.rotation = w_top_left.a; 
			
			space.addObject(w_top_right = Tools.createBox(FIELD_W,0, angle_wall_w, angle_wall_w, 0, 0, 0, true, Material.Ice));//--right
            addChild(w_top_right.graphic);
            w_top_right.a = -45;
		    w_top_right.graphic.rotation = w_top_right.a; 
		
			space.addObject(w_bottom_left = Tools.createBox(0, FIELD_H,  angle_wall_w, angle_wall_w,  0, 0, 0, true, Material.Ice));//--bottom
            addChild(w_bottom_left.graphic);
			w_bottom_left.a = 45;
		    w_bottom_left.graphic.rotation = w_bottom_left.a; 
            
			space.addObject(w_bottom_right = Tools.createBox(FIELD_W, FIELD_H, angle_wall_w, angle_wall_w,  0, 0, 0, true, Material.Ice));//--left
            addChild(w_bottom_right.graphic);
			w_bottom_right.a = -45;
		    w_bottom_right.graphic.rotation = w_bottom_right.a; 
			
			// Add the line defining user mouse movements
			g.graphics.lineStyle(1, 0, 1);
			addChild(g);
			
			//space.addObject(ice = Tools.createPolyCircle(FIELD_W / 2, FIELD_H / 2, FIELD_W , FIELD_H , 0, 0, 0, true, true, Material.Ice));
			//addChild(ice.graphic);
		}			  
		private function createBall():void
		{			
			ball= Tools.createCircle(FIELD_W/2, FIELD_H/2, 5, 0, 0, 1, false, false, Material.Rubber);
			space.addObject(ball);			
			addChild(ball.graphic);		
		}


		private function createVratar():void {
			//---2-----TOP-----
			var x2:int = (FIELD_W/2);
			//var y2:int = 2 * (FIELD_H / 16);
			var vratar_w:int = (FIELD_W / 24);
			vratar_step_x = 1;// vorota_w / 16;
			space.addObject(vratar_2 = Tools.createBox(x2, (st_Left_1.py+(vorota_h*0.6)), vratar_w,  0.1, 0.00, 0, 0, true, Material.Steel));//---top
            addChild(vratar_2.graphic);	
			//---1-----BOTTOM---
			var x1:int = x2;
			//var y1:int = v1_line_top_y.py;			
			//vratar_step_x = 1;// vorota_w / 16;
			space.addObject(vratar_1 = Tools.createBox(x1, (st_Left_2.py-(vorota_h*0.6)), vratar_w,  0.1, 0.00, 0, 0, true, Material.Steel));//---top
            addChild(vratar_1.graphic);	
				
		}
		private function createVorota():void
		{
			var x1:int = 3*(FIELD_W/8);
			var y1:int = 2 * (FIELD_H/ 16);
			var x2:int = x1;
			var y2:int = FIELD_H - y1;
			vorota_h =(FIELD_H/16);
			vorota_w =2*(FIELD_W/8);			
			//--------TOP VOROTA--------------------------------------------------------------------------			
		
			// left stoyka
            space.addObject(st_Left_1 = Tools.createBox(x1,  y1, 0.2,  vorota_h, 0, 0, 0, true, Material.Steel));//---top
            addChild(st_Left_1.graphic);	
			// top stoyka
			space.addObject(st_Top_1 = Tools.createBox(x1+(vorota_w/2), (y1-(vorota_h/2)), vorota_w,  0.1, 0, 0, 0, true, Material.Steel));//---top
            addChild(st_Top_1.graphic);	
			// right stoyka
			space.addObject(st_Right_1 = Tools.createBox(x1+(vorota_w), y1, 0.2,  vorota_h, 0, 0, 0, true, Material.Steel));//---top
            addChild(st_Right_1.graphic);
			//--------BOTTOM VOROTA---------------------------------------------------------------------------
			// left stoyka
            space.addObject(st_Left_2 = Tools.createBox(x2,  y2, 0.2,  vorota_h, 0, 0, 0, true, Material.Steel));//---top
            addChild(st_Left_2.graphic);	
			// top stoyka
			space.addObject(st_Top_2 = Tools.createBox(x1+(vorota_w/2), (y2+(vorota_h/2)), vorota_w,  0.2, 0, 0, 0, true, Material.Steel));//---top
            addChild(st_Top_2.graphic);	
			// right stoyka
			space.addObject(st_Right_2 = Tools.createBox(x1+(vorota_w), (y2), 0.2,  vorota_h, 0, 0, 0, true, Material.Steel));//---top
            addChild(st_Right_2.graphic);
			
			//---line goal 1-----
			v1_line_left_x = st_Left_1.px;
			v1_line_right_x = st_Right_1.px;
			v1_line_bottom_y=st_Left_1.py+(vorota_h/2);
			v1_line_top_y = v1_line_bottom_y - (vorota_h / 3);
			//---line goal 2-----
			v2_line_x = x1;
			v2_line_top_y=y2-(vorota_h/2);
			v2_line_bottom_y = v2_line_top_y + (vorota_h / 3);
		}

		private function t_trace(t:String):void
		{
			t_txt.text = t;
		}
		public function vratarMoveLeft(vratar:PhysObj):void {
			//vratar.px = vratar.px - vratar_step_x;
			vratar.setPos(vratar.px - vratar_step_x,vratar.py)
			vratar.graphic.x = vratar.px; 
			space.sync(vratar);
			
			//t_trace("vratar.px ="+vratar.px);
		}
		public function vratarMoveRight(vratar:PhysObj):void {
			vratar.px = vratar.px + vratar_step_x;
			vratar.graphic.x = vratar.px;
			space.sync(vratar);
		}
		public function moveToPoint(x:Number, y:Number):void {
			//trace("PHN moveToPoint x="+x+" y="+y);
			var k_y:int = 1;
			var k_x:int = 1;
			if (y < ball.py) {
				k_y = -1;
			} else { k_x = 1; }
			if (x < ball.px) {
				k_x = -1;
			}
			//ball.calcProperties();
			ball.setVel(0, 0);
			ball.setVel(k_x * Math.abs(ball.px - x), k_y * Math.abs(ball.py - y));
			ball.update();
			//trace("PHN moveToPoint ball.px="+ball.px+" ball.py="+ball.py);
		}
		public function impulse(k_force:int = 1,ang:int=0):void
		{
			working = true;
			cur_state = STATE.MOVE;//---Запустить  расчет физики движения--
			angle_obj = ang;//ballbody.GetUserData().rotationY;
			var angle_grad:int = angle_obj;
			if ((angle_grad < 0 ) && (angle_grad > -360)) { angle_grad = 360 + angle_grad; }
			applyImpulseByAngel(ball,angle_grad,k_force);
		}
		private function applyImpulseByAngel(body:PhysObj,angle:Number = 0,k_force:int =1):void
		{
			
			var x_i:Number = -60;// --- to --
			var y_i:Number = -80;
			var x_0:Number = body.px;      // -- from --
			var y_0:Number = body.py;
			var step_force:int = FIELD_H / 100; // ---шаг силы (гипотенуза)
			var k1:Number;//-- катет 1
			var k2:Number;//-- катет 2
			var betta:Number;//--angel when >180 gradusov
			//t_trace("ANGLE grad="+angle);
			if ((angle >= 0)&&(angle <=90)) 
			{
				angle = (Math.PI / 180) * angle;//--в радианы---
				k1  = int(k_force*step_force * Math.sin(angle));
				k2  = int(k_force*step_force * Math.cos(angle));
				x_i = x_0 + k1;
				y_i = y_0 - k2;
				//t_trace("1)0-90 angle=" + angle +" k1="+k1+" k2="+k2);
				
				ball.setVel(0, 0);
				ball.setVel(k_force * k1, -k2*k_force);
				return;
			}
			if ((angle > 90)&&(angle <=180)) 
			{
				betta = angle-90;
				angle = (Math.PI / 180) * betta;//--в радианы---
				k1  = int(k_force*step_force * Math.cos(angle));
				k2  = int(k_force*step_force * Math.sin(angle));
				x_i = x_0 + k1;
				y_i = y_0 + k2;
				//t_trace("2)90-180 angle=" + angle +" k1="+k1+" k2="+k2);
				//body.ApplyImpulse(new b2Vec2( x_i, y_i), body.GetPosition());
				ball.setVel(0, 0);
				ball.setVel(k_force * k1, k2*k_force);
				return;
			}
			if ((angle > 180)&&(angle <= 270)) 
			{				
				betta = 270-angle;
				//betta = angle-180;
				
				betta = (3.1415/180)*betta;//--в радианы---
				k1  = int(k_force*step_force * Math.cos(betta));
				k2  = int(k_force*step_force * Math.sin(betta));
				x_i = x_0 - k1;
				y_i = y_0 + k2;
				//t_trace("180-270 an=" + angle +" k1="+k1+" k2="+k2+"b="+betta+"M="+Math.sin(betta));
				
				ball.setVel(0, 0);
				ball.setVel(k_force * -k1, k2*k_force);
				return;
			}
			if ((angle > 270)&&(angle <= 360)) 
			{
				betta = 360 - angle;
				betta = (Math.PI / 180) * betta;//--в радианы---
				k1  = int(k_force*step_force * Math.sin(betta));
				k2  = int(k_force*step_force * Math.cos(betta));
				x_i = x_0 - k1;
				y_i = y_0 - k2;
			    //t_trace("4)270-360 angle=" + angle +" k1="+k1+" k2="+k2);
				ball.setVel(0, 0);
				ball.setVel(k_force * -k1, -k2*k_force);
				return;
			}
			
		}
		//---------------Events---------------------------------------------
		private function mouseClICK(e:MouseEvent):void 
		{
			//ball.setVel(200 * Math.random(), -FIELD_H / 2);			
			//impulse(9, -30);
			moveToPoint(stage.mouseX,stage.mouseY);
			
			//vratarMoveRight();
		}	
		private function enterFrame(ev:Event) : void
		{				  
			if (working) {			
				space.step(timeStep, 6, 6);
				t_txt.text="Ball.px="+int(ball.px)+" ball.py="+int(ball.py)+" vx="+int(ball.vx)+" vy="+int(ball.vy);
				//trace("PHN "+t_txt.text);
				calcCallBacks();
				checkGoal();
			  if ((ball.vx >=0.05)||(ball.vy >=0.05)) {
				if ((cur_state == STATE.GOAL_1) || (cur_state == STATE.GOAL_2)) {
					ball.setVel(ball.vx-0.05, ball.vy-0.05);
				}
			  }
		    }
		}
		private function checkGoal():void
		{
			if ((ball.px > v1_line_left_x) && (ball.px < v1_line_right_x) && (ball.py > v1_line_top_y) && (ball.py < v1_line_bottom_y)&&(ball.pre_py > ball.py)) {
				ball.setVel(ball.vx * 0.7, ball.vy * 0.6);
				cur_state = STATE.GOAL_1;
				//t_trace("PHN goal_1");
			}
			if ((ball.px >v1_line_left_x) && (ball.px <(v1_line_right_x)) && (ball.py > v2_line_top_y) && (ball.py < v2_line_bottom_y)&&(ball.pre_py < ball.py)) {
				ball.setVel(ball.vx * 0.7, ball.vy * 0.6);
				cur_state = STATE.GOAL_2;
				//t_trace("PHN goal_2");
			}
		}
		
		private function calcCallBacks():void
		{
		 if (space.callbacks != null) {
			var callbacks:CxFastAllocList_Callback = space.callbacks;			
			
		    while (!callbacks.empty())
			{
				var cb:Callback = callbacks.front();				
				//t_trace("calcCallBacks cb.type="+cb.type);
				switch(cb.type)
				{
					case Callback.BEGIN:
					{
						
						//t_trace("begin p1= " + cb.obj_arb.p1.data + " p2= " + cb.obj_arb.p2.data+" ball.px="+cb.obj_arb.p1.px);
						break;
					}
				
					case Callback.END:
					{
						
						//t_trace("end p1= " + cb.obj_arb.p1.data + " p2= " + cb.obj_arb.p2.data+" ball.py="+cb.obj_arb.p1.py);
						break;
					}

					case Callback.POST_SOLVE:
					{
						//t_trace("post_solve");
						//t_trace("p1= " + cb.obj_arb.p1.data + " p2= " + cb.obj_arb.p2.data);
						break;
					}		
						
					case Callback.PHYSOBJ_OUTOFBOUNDS:
					{
						//t_trace("phys obj OUTOFBOUNDS: pre_px="+int(cb.obj_arb.p2.pre_px)+" pre_py="+int(cb.obj_arb.p2.pre_py)+" cb.type="+cb.type);
						//t_trace("phys obj OUTOFBOUNDS: ");
						//ball.setPos(FIELD_W/2, FIELD_H/2);
						createBall();
						ball.cbType = dynamicBallType;
						initCollisionEvents();
						cur_state = STATE.STOP;
						break;
					}
						

				}
				
				callbacks.pop();
			}
	
		    }
		}
	}
}