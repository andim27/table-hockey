package 
{
import flash.display.*;
import flash.events.*;
//import events.CPEvents;
//import events.GameEvents;

import Box2D.Dynamics.*;
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Dynamics.Joints.*;
import Box2D.Dynamics.Contacts.*;
import Box2D.Common.Math.*;

public class Physics extends Sprite {
		public var s_conf:Object;
		public var WIDTH:Number = 640;// stage.width
		public var HEIGHT:Number = 400;
		public var REAL_WIDTH:Number;//--берется из модели реального 3D мира
		public var REAL_HEIGHT:Number;
		public var k_real_w:Number = 1;//--коеф пересчета для движения реальной модели = (real_w /WIDTH)
		public var k_real_h:Number = 1;//--коеф пересчета для движения реальной модели = (real_w /HEIGHT)
		public var world:b2World;
		public var timestep:Number;
		public var iterations:uint;
		public var pixelsPerMeter:Number = 30;
		public var ballbody:b2Body;
		public var stoykaLeft_1:b2Body;
		public var stoykaLeft_2:b2Body;
		public var stoykaRight_1:b2Body;
		public var stoykaRight_2:b2Body;
		public var vorota_h:int;
		public var vorota_w:int;
		public var my_model_obj:Sprite;//Object;
		public var angle_obj:Number; //--угол поворота обьекта что движется
		public  var working:Boolean = false;//--Запускается по импульсу - останавливается когда гол
		public var k_real_calc_x:Number = 1;//--масштабных коэф для соответствия координад ball obj
		public var k_real_calc_y:Number = 1;
		//public var physics_mc:Sprite = new Sprite();
		public function Physics() {						
			//my_model_obj=my_ball_model;			
			init();
			initWorld(340,400);			
		}
		public function initWorld(w:Number,h:Number):void
		{
			WIDTH =w;
			HEIGHT=h;
			k_real_calc_x = (w/WIDTH)*30;
			k_real_calc_y = (h/HEIGHT )*30;
			trace("Physics initWorld WIDTH ="+WIDTH+" HEIGHT="+HEIGHT);
			makeWorld();
			makeWalls();
			makeVorota();
			makeDebugDraw();
			
			setDebugBall();
			setBall(my_model_obj,-30);
			//makeABunchOfDynamicBodies();
			//my_model_obj = new MovieClip();
			update();
			working=false;
			//working=true;
		}
		private function init(e:Event = null):void 
		{
			
			update();
			addEventListener(Event.ENTER_FRAME, update);
			//addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		public function setDebugBall():void
		{
			my_model_obj=new Sprite();
			my_model_obj.graphics.beginFill(0xFF794B);
         	my_model_obj.graphics.drawCircle(0,0, 10);
         	my_model_obj.graphics.endFill();
			my_model_obj.x=stage.stageWidth/2;
			my_model_obj.y=stage.stageHeight/2;
			my_model_obj.graphics.endFill();
			my_model_obj.width=20;
			my_model_obj.height=20;
			my_model_obj.visible=true;
         	addChild(my_model_obj);
			trace("setDebugBall my_model_obj="+my_model_obj);

			my_model_obj.addEventListener(MouseEvent.CLICK,onDebugModelClick);

		}
		private function onDebugModelClick(e:MouseEvent):void 
		{
			impulse(2,angle_obj);
		}
		public function work() {
		 trace("METHOD Working is TRUE");
		 working=true;
		}
		public function stop() {
		 trace("METHOD Working is FALSE");
		 working=false;
		}

		public function setBoundary(w:int,h:int):void
		{
			WIDTH  = w;
			HEIGHT = h;
		}
		public function setBoundaryReal(w:int,h:int):void
		{
			REAL_WIDTH  = w;
			REAL_HEIGHT = h;
			k_real_w = REAL_WIDTH / WIDTH;
			k_real_h = REAL_HEIGHT / HEIGHT;
		}
		public function setBall(obj:*,ang:int=0):void
		{
			//ballbody.SetUserData(obj);
			angle_obj=ang;
			makeMyBall(obj,ang);
		}
		public function calcBallByRealPos(mc_x:int, mc_y:int):void //---Расчет физ.координат по реальным модели
		{
			
		}
		private function makeDebugDraw():void
		{
			// set debug draw
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			debugSprite.addEventListener(MouseEvent.CLICK,onDebugModelClick);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(30.0);
			debugDraw.SetFillAlpha(0.3);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			world.SetDebugDraw(debugDraw);
		}
		
		
		/*
		public function onImpulse(e:GameEvents):void
		{
			working=true;
			//trace("Физ.Двиг:Удар по шайбе nomer="+e.event_obj.nomer);
			impulse(e.event_obj.k_force);
		}
		*/
		public function impulse(k_force:int = 1,ang:int=0):void
		{
			//var angle_grad:int = int(ballbody.GetUserData().rotation);
			
			working = true; //---Запустить  расчет физики движения--
			angle_obj = ang;//ballbody.GetUserData().rotationY;
			var angle_grad:int = angle_obj;
			if ((angle_grad < 0 ) && (angle_grad > -360)) { angle_grad = 360 + angle_grad; }
			ApplyImpulseByAngel(ballbody,angle_grad,1);
		}
		private function ApplyImpulseByAngel(body:b2Body,angle:Number = 0,k_force:int =1):void
		{
			var x_i:Number = -60;// --- to --
			var y_i:Number = -80;
			var x_0:Number = body.GetPosition().x;      // -- from --
			var y_0:Number = body.GetPosition().y;
			var step_force:int = HEIGHT / 100; // ---шаг силы (гипотенуза)
			var k1:Number;//-- катет 1
			var k2:Number;//-- катет 2
			var betta:int;//--angel when >180 gradusov
			trace("ANGLE grad="+angle);
			if ((angle >= 0)&&(angle <=90)) 
			{
				angle = (Math.PI / 180) * angle;//--в радианы---
				k1  = k_force*step_force * Math.sin(angle);
				k2  = k_force*step_force * Math.cos(angle);
				x_i = x_0 + k1;
				y_i = y_0 - k2;
				trace("1)0-90 START Impulse angle=" + angle +" x_0="+x_0+" y_0="+y_0+" x_i="+x_i+" y_i="+y_i);
				body.ApplyImpulse(new b2Vec2( x_i, -y_i), body.GetPosition());
				return;
			}
			if ((angle > 90)&&(angle <=180)) 
			{
				angle = (Math.PI / 180) * angle;//--в радианы---
				k1  = k_force*step_force * Math.cos(angle);
				k2  = k_force*step_force * Math.sin(angle);
				x_i = x_0 + k1;
				y_i = y_0 + k2;
				trace("2)90-180 START Impulse angle=" + angle +" x_0="+x_0+" y_0="+y_0+" x_i="+x_i+" y_i="+y_i);
				body.ApplyImpulse(new b2Vec2( x_i, y_i), body.GetPosition());
				return;
			}
			if ((angle > 180)&&(angle <= 270)) 
			{				
				betta = 270 - angle;
				betta = (Math.PI / 180) * betta;//--в радианы---
				k1  = k_force*step_force * Math.cos(betta);
				k2  = k_force*step_force * Math.sin(betta);
				x_i = x_0 - k1;
				y_i = y_0 + k2;
				trace("3)180-270 START Impulse angle=" + angle +" x_0="+x_0+" y_0="+y_0+" x_i="+x_i+" y_i="+y_i);
				body.ApplyImpulse(new b2Vec2( -x_i, y_i), body.GetPosition());
				return;
			}
			if ((angle > 270)&&(angle <= 360)) 
			{
				betta = 360 - angle;
				betta = (Math.PI / 180) * betta;//--в радианы---
				k1  = k_force*step_force * Math.sin(angle);
				k2  = k_force*step_force * Math.cos(angle);
				x_i = x_0 - k1;
				y_i = y_0 - k2;
			    trace("4)270-360 START Impulse angle=" + angle +" x_0="+x_0+" y_0="+y_0+" x_i="+x_i+" y_i="+y_i);
				body.ApplyImpulse(new b2Vec2( -x_i, -y_i), body.GetPosition());
				return;
			}
			
		}
		//-------------------MAKE FUNC----------------------------------
		private function makeWorld():void
		{
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 0.0);	
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			// Construct a world object
			world = new b2World(gravity, doSleep);
			world.SetWarmStarting(true);
			timestep = 1.0 / 30.0;
			iterations = 10;
			trace("makeWorld "+world);
		}
		private function makeWalls():void
		{
			var wall:b2PolygonShape= new b2PolygonShape();
			var wallBd:b2BodyDef = new b2BodyDef();
			var wallB:b2Body;			
			// Left
			wallBd.position.Set( -(2) / pixelsPerMeter, HEIGHT / pixelsPerMeter / 2);
			wall.SetAsBox((2)/pixelsPerMeter, HEIGHT/pixelsPerMeter/2);
			wallB = world.CreateBody(wallBd); // Box2D handles the creation of a new b2Body for us.
			wallB.CreateFixture2(wall);
			var fixtLeft:b2Fixture = wallB.CreateFixture2(wall);
			fixtLeft.SetRestitution(1);
			// Right
			wallBd.position.Set((WIDTH + 2) / pixelsPerMeter, HEIGHT / pixelsPerMeter / 2);
			wallB = world.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			// Top
			wallBd.position.Set(WIDTH / pixelsPerMeter / 2, -2/ pixelsPerMeter);
			wall.SetAsBox(WIDTH/pixelsPerMeter/2, 2/pixelsPerMeter);
			wallB = world.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			// Bottom
			wallBd.position.Set(WIDTH / pixelsPerMeter / 2, (HEIGHT + 2) / pixelsPerMeter);
			wallB = world.CreateBody(wallBd);
			var fixtBottom:b2Fixture = wallB.CreateFixture2(wall);
			fixtBottom.SetRestitution(1);
			trace(makeWalls);
		}
		private function makeVorota():void
		{
			var x1:int = 3*(WIDTH/8);
			var y1:int = 2 * (HEIGHT / 16);
			var x2:int = x1;
			var y2:int = HEIGHT - y1;
			vorota_h =(HEIGHT/16);
			vorota_w =2*(WIDTH/8);			
			//--------TOP VOROTA---------------------------------------------------------------------------
			// left stoyka
			var stoykaSh:b2PolygonShape= new b2PolygonShape();
			var stoykaBd:b2BodyDef = new b2BodyDef();
			var stoykaB:b2Body;
			var fixtLeft:b2Fixture;
			
			stoykaBd.position.Set( x1/pixelsPerMeter,  y1/pixelsPerMeter);
			stoykaSh.SetAsBox(2/pixelsPerMeter, (y1-vorota_h)/pixelsPerMeter);
			stoykaB = world.CreateBody(stoykaBd); // Box2D handles the creation of a new b2Body for us.
			stoykaB.CreateFixture2(stoykaSh);
			fixtLeft = stoykaB.CreateFixture2(stoykaSh);
			fixtLeft.SetRestitution(1);
			stoykaLeft_2 = stoykaB;
			// top stoyka
			stoykaBd.position.Set( (x1+(vorota_w/2))/pixelsPerMeter,  (y1-vorota_h)/pixelsPerMeter);
			stoykaSh.SetAsBox((vorota_w/2)/pixelsPerMeter, 2/pixelsPerMeter);
			stoykaB = world.CreateBody(stoykaBd); // Box2D handles the creation of a new b2Body for us.
			stoykaB.CreateFixture2(stoykaSh);
			// right stoyka
			stoykaBd.position.Set( (x1+vorota_w)/pixelsPerMeter,  y1/pixelsPerMeter);
			stoykaSh.SetAsBox(2/pixelsPerMeter, (y1-vorota_h)/pixelsPerMeter);
			stoykaB = world.CreateBody(stoykaBd); // Box2D handles the creation of a new b2Body for us.
			stoykaB.CreateFixture2(stoykaSh);
			stoykaRight_2 = stoykaB;
			//--------BOTTOM VOROTA---------------------------------------------------------------------------
			// left stoyka
			stoykaBd.position.Set( x2/pixelsPerMeter,  y2/pixelsPerMeter);
			stoykaSh.SetAsBox(2/pixelsPerMeter, (vorota_h)/pixelsPerMeter);
			stoykaB = world.CreateBody(stoykaBd); // Box2D handles the creation of a new b2Body for us.
			stoykaB.CreateFixture2(stoykaSh);
			stoykaLeft_1 = stoykaB;
			//fixtLeft = stoykaB.CreateFixture2(stoykaSh);
			//fixtLeft.SetRestitution(1);
			// bottom stoyka
			stoykaBd.position.Set( (x2+(vorota_w/2))/pixelsPerMeter,  (y2+vorota_h)/pixelsPerMeter);
			stoykaSh.SetAsBox((vorota_w/2)/pixelsPerMeter, 2/pixelsPerMeter);
			stoykaB = world.CreateBody(stoykaBd); // Box2D handles the creation of a new b2Body for us.
			stoykaB.CreateFixture2(stoykaSh);
			// right stoyka
			stoykaBd.position.Set( (x2+vorota_w)/pixelsPerMeter,  y2/pixelsPerMeter);
			stoykaSh.SetAsBox(2/pixelsPerMeter, (vorota_h)/pixelsPerMeter);
			stoykaB = world.CreateBody(stoykaBd); // Box2D handles the creation of a new b2Body for us.
			stoykaB.CreateFixture2(stoykaSh);
			stoykaRight_1 = stoykaB;
			trace(makeVorota);
		}
		private function makeMyBall(my_ball_model:Object,ang:int):void
		{
			var body:b2Body;
			var mybodyDefC:b2BodyDef;
			var fd:b2FixtureDef;
			var mycircDef:b2CircleShape;
			// add my ball
				mybodyDefC = new b2BodyDef();
				mybodyDefC.type = b2Body.b2_dynamicBody;
				mycircDef = new b2CircleShape((20) / pixelsPerMeter);
				fd = new b2FixtureDef();
				fd.shape = mycircDef;
				fd.density = 1.0;
				// Override the default friction.
				fd.friction = 0.3;
				fd.restitution = 1;
				// ---Ball по центру ????
				mybodyDefC.position.Set((WIDTH/2) / pixelsPerMeter, (HEIGHT/2) / pixelsPerMeter);
				mybodyDefC.angle = ang*(Math.PI/180) ;//Math.random() * Math.PI;
				ballbody = world.CreateBody(mybodyDefC);
				ballbody.CreateFixture(fd);
				ballbody.SetLinearDamping(0.1);
				/*
				circle = new PhysCircle();
				circle.x = (WIDTH/2);
				circle.y = 10;
				circle.width = 40;
				circle.height = 30;
				circle.name="circle";
				addChild(circle);
				circle.addEventListener(MouseEvent.CLICK, onClick);
				*/
				ballbody.SetUserData(my_ball_model);//---Shayba model---
		}
		private function checkGoal(n:int):void
		{
			var x_0:Number = ballbody.GetPosition().x;
			var y_0:Number = ballbody.GetPosition().y;
			var st_l_x:Number;
			var st_l_y:Number;
			var st_r_x:Number
			var dy:Number 
			var line_h:Number = vorota_h / 6;
			if (n == 1) {
				st_l_x = stoykaLeft_1.GetPosition().x;
				st_l_y = stoykaLeft_1.GetPosition().y;
				st_r_x = stoykaRight_1.GetPosition().x;
				dy = y_0 - st_l_y;
				if ((x_0 > st_l_x) && (x_0 < st_r_x) && (y_0 >= st_l_y ) ) {
					//ballbody.SetLinearDamping(1000);
					ballbody.SetLinearVelocity(new b2Vec2());
					trace("GOAL 1 !!!!!!!!!");
					working = false; //---Остановить расчет физики--
					//ballbody.SetPosition(stoykaLeft_1.GetPosition());
					
				}
			}
			if (n == 2) {
				
				st_l_x = stoykaLeft_2.GetPosition().x;
				st_l_y = stoykaLeft_2.GetPosition().y;
				st_r_x = stoykaRight_2.GetPosition().x;
				
				dy = Math.abs(st_l_y - y_0);
				//trace("x_0=" + x_0 + " y_0=" + y_0 );
				if ((x_0 > st_l_x) && (x_0 < st_r_x) && (y_0 < st_l_y ) ) {
					ballbody.SetLinearVelocity(new b2Vec2());
					trace("GOAL 2 !!!!!!!!!");
					working = false; //---Остановить расчет физики--
					//ballbody.SetPosition(stoykaLeft_2.GetPosition());
					
				}
			}//---n=2--
		}//--check goal---
		private function update(e:Event = null):void
		{
			if (working) {
				//trace("Physics working this="+this);
				world.Step(timestep, iterations, iterations);
				world.ClearForces();
				world.DrawDebugData();
				myBallSetPos();
				checkGoal(1);
				checkGoal(2);
			}
		}
		private function myBallSetPos():void //---Выставить модель согласно движению из физ. движка
		{
			var bodiesList:b2Body = world.GetBodyList();
			for (var cur_body:b2Body = world.GetBodyList(); cur_body; cur_body = cur_body.GetNext())
			{
				
				if (! cur_body.GetUserData()  ) { continue; }
				
				var tVector:b2Vec2 = cur_body.GetPosition();      				
				cur_body.GetUserData().x = k_real_w*tVector.x * (30*k_real_calc_x);
				cur_body.GetUserData().y = k_real_h*tVector.y * (30*k_real_calc_y);//----!!! z вместо y !!!!
				cur_body.GetUserData().rotation = cur_body.GetAngle() * 180 / Math.PI;			
				//x_ball=
				angle_obj=cur_body.GetUserData().rotation;				
				trace("PHYSICS model.x="+cur_body.GetUserData().x+" model.y="+cur_body.GetUserData().y+" cur_body.GetUserData().rotation ="+cur_body.GetUserData().rotation );
			}
		}
		
	}
}