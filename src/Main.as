package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.*;
	import flash.events.*;
	import flash.system.Security;
	import flash.system.Capabilities;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.ui.Keyboard;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
    import flash.ui.ContextMenuBuiltInItems;
	import flash.external.ExternalInterface;
	import flash.net.*;
	import FGL.GameTracker.GameTrackerErrorEvent;
	import FGL.GameTracker.GameTracker;
	
	import com.greensock.*;	
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	
	import away3d.debug.*;
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.utils.*;
	import away3d.core.math.Number3D;
	import away3d.events.*;
	import away3d.loaders.*;
	import away3d.materials.*;
	import away3d.lights.DirectionalLight3D;

	
	import away3d.core.render.*;
	import away3d.loaders.*;
	import away3d.primitives.*;

	import events.*;
	import katok.*;
	import team.Team;
	import controlpanel.CP_cell;
	import controlpanel.CP_cell_control;
	import controlpanel.CP_intro;
	import controlpanel.CP_top_menu;
	import utils.MyF;
    import utils.CMD;
    import utils.STATE;
	import utils.BaseCode;
	import phn.*;

	
	//import Physics;
	/**
	 * ...
	 * @author AndMak
	 */
   [SWF(backgroundColor="#99CCFF", frameRate="30", quality="LOW", width="640", height="480")]

	public class Main extends Sprite 
	{
		public var site_config:Object;
		public static var site_path:String;
		public var cur_state:uint;
		public var prev_state:uint;		
		public var scene:Scene3D;
		private var current_scene:Scene3D;
		private var camera:HoverCamera3D;//Camera3D;
		//private var camera:Camera3D;
		//private var camera:TargetCamera3D;
		private var renderer:BasicRenderer;
		
		public var view:View3D;
		private var light1:DirectionalLight3D;
		public var fon_mc:MovieClip;
		public var k_scale_x:Number = 1;//--коеф для онресайз
		public var k_scale_y:Number = 1;//--коеф для онресайз
		public var first_width:uint = 640;
		public var first_height:uint = 480;
		
		public var kt:Katok;		
		public var team_1:Team;
		public var team_2:Team;
		public var vorota_1:Vorota;
		public var vorota_2:Vorota;
		public var shayba:Shayba;
		public var cp_cell_mc:CP_cell;
		public var cp_cell_control_mc:CP_cell_control;
		public var cp_intro_mc:CP_intro;
		public var tb:Number;
		//navigation variables
		private var move:Boolean=false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var e_where:Boolean = false;
		public  var where_addr:String;
		public var lg:uint=1;//--legal copy
		private var ld_main:Loader;

		private var loader_lib:SWFLoader;
		public var ph_engine:Object; //--Физ движок.Он считает физику полета шайбы
		public var can_sound:Boolean;
		//private var ph_e:Physics;
		public var top_menu_mc:CP_top_menu;
		public var tracker:GameTracker; 
		
		
		public function Main():void 
		{
			//if (stage) init();
			//else addEventListener(Event.ADDED_TO_STAGE, init);
			init();
		}
		
		private function init():void 
		{
			tracker = new GameTracker();
			tracker.beginGame(0,"start");
			//Debug.active = true;
			Debug.active = false;
			//makeWorld();
			stage.scaleMode = StageScaleMode.NO_BORDER;//StageScaleMode.EXACT_FIT;
			can_sound=true;
			cur_state = STATE.INIT;
			site_config=new Object();
			site_config.main=this;
			site_config.stage=stage;
			site_config.site_path = "";
			// "D:/and_1/work/flash/flash_work/HK/bin/";
			//site_path = "D:/and_1/work/flash/flash_work/HK/bin/";
			where_addr = "http://tablehk.appspot.com/";
			//where_addr = "http://localhost:8080/";
			//Security.allowDomain('*');
			//ld_main = new Loader();
			//ld_main.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			//stage.loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			try {
			root.loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);

			Security.loadPolicyFile(where_addr+"cross");
			
			initEngine();
			tracker.checkpoint(1, "init_1 done", "1");
			initMM();
			init3d();
			tracker.checkpoint(3, "init_3 done", "1");
			initEvents();
			init2d();			
			initPhysics();
			tracker.checkpoint(4, "init_ph done", "ph");
			tb = root.loaderInfo.bytesLoaded;
			//updateHk();
			cp_intro_mc = new CP_intro(site_config);
			} catch (e:Error) {
				tracker.checkpoint(10, "error init", "error");
			}
			//---------------video-------------------
			//cur_s_capt = new S_Capt(site_config.stage);
			//----------------------------B:Phisics-------------------------------------
			
			//--E:Phisics--
			//ph_e=new Physics(site_config);
			//addChild(ph_e);
			//removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		private function initMM():void {
			 var menu0:ContextMenuItem;
             var menu1:ContextMenuItem;
             var menu2:ContextMenuItem;
			//var myMenu:ContextMenu = new ContextMenu();
			//myMenu.hideBuiltInItems();
			 
			//var copyrightNotice:ContextMenuItem = new ContextMenuItem("© 2011 AndMak");
			//var mySiteLink:ContextMenuItem = new ContextMenuItem("skype:andrey_makarevich");
			//copyrightNotice.separatorBefore = true;
			//myMenu.customItems.push(mySiteLink, copyrightNotice);
			
			menu0 = new ContextMenuItem("Table hockey game", true, true, true);
            menu1 = new ContextMenuItem("© 2011 AndMak,Kharkov,Ukraine", true, true, true); 
            menu2 = new ContextMenuItem("skype:andrey_makarevich", true, true, true);
            
			var myMenu:ContextMenu = new ContextMenu();
            myMenu = new ContextMenu();
            myMenu.customItems =[menu0, menu1, menu2];
            myMenu.hideBuiltInItems();
			this.contextMenu = myMenu;
		}
		//----------------------------B:Phisics------------------------------------------
		private function initPhysics():void {		
			//var loader_lib:SWFLoader = new SWFLoader("PHN.swf", {name:"mainPH", container:this, x:50, y:100, onInit:initVarPhysics, estimatedBytes:97661}); 			
			//loader_lib.load();			
			ph_engine=new PHN_pnysics();
			ph_engine.visible=false;	
		}
		
		private function initVarPhysics(event:LoaderEvent):void {
			ph_engine=event.target.content.rawContent;			
			ph_engine.visible=false;			
			//Debug.trace("Physics loaded: event.target.content.ph_engine.working="+ph_engine.working);
		}

		//----------------------------E:Phisics------------------------------------------
		private function initEngine():void 
		{
			cur_state=STATE.INIT_ENGINE;//"init_engine";
			scene  = new Scene3D();
			
			initCamera();

			view = new View3D();
			view.camera=camera;
			view.scene=scene;
			
			current_scene=scene;		
			view.mouseZeroMove=true;
			view.x=int(stage.width/2);//400;
			view.y=int(stage.height/2);//300;
			view.renderer = Renderer.CORRECT_Z_ORDER;
			//view.renderer = Renderer.BASIC;
			//view.renderer = Renderer.INTERSECTING_OBJECTS; 
			stage.addChildAt(view,1);
			site_config.scene=scene;
			
		}
		private function initCamera():void
		{
			//--------------------x----------
			//camera = new Camera3D();
			//camera =new TargetCamera3D();
			camera = new HoverCamera3D();
			camera.panAngle=30;//45;
			camera.tiltAngle=15;//20;
			camera.hover(true);
			camera.distance =72;
			camera.focus=140;
			camera.zoom = 1;
			//camera.lookAt(new Number3D(-50,-50,0));
			//camera.x=100;
			//camera.y=100;
			//camera.z=-50;
		}
		private function initLight():void {
			// Setup direction light
			light1 = new DirectionalLight3D();
			light1.direction = new Number3D(kt.center.x,kt.center.y,kt.center.z);
			light1.brightness =1;
			light1.ambient = 0.5; 
			light1.diffuse = 0.5; 
			light1.specular=1;
			view.scene.addLight(light1);
			

		}
		private function initEvents():void
		{
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			//stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			//--CP_cell catch--
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(Event.RESIZE, onResize);	
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, getKeysPressedInGame); 
			//stage.addEventListener(KeyboardEvent.KEY_UP, getKeysReleasedInGame);
			onResize();
		}
		protected function init3d():void
		{
			cur_state=STATE.INIT_3D;//"init3d";
			kt = new Katok(site_config);
		}
		
		protected function init2d():void
		{
			//cp_cell_mc = new CP_cell();			
			//stage.addChildAt(cp_cell_mc, 1);			
			//cp_cell_mc.addEventListener(CPEvents.MAN_CONTROL,function(e:CPEvents){trace("MAIN cp_cell_mc EVENT: e.event_label="+e.event_label)});
			//cp_cell_control_mc= new CP_cell_control(site_config);
			
		}
		public function flyOver():void {			
			prev_state=cur_state;
			cur_state = STATE.FLY_OVER
			//trace("camera.rotationY="+camera.rotationY);
		}
		public function overlapControl():void {
			var m_1_1:Object = new Object();
			var m_1_5:Object = new Object();
			var m_2_1:Object=new Object();
			var m_2_5:Object=new Object();
			if ((camera.panAngle >= 0) ) {
				//trace(" >0 camera.panAngle="+camera.panAngle);
				//kt.Ice_Mesh.pushback = true;
				kt.bort_right_Mesh.pushback = true;
				kt.bort_right_Mesh.pushfront = false;
				kt.bort_left_Mesh.pushfront = true;
				//trace("kt.bort_left_Mesh.pushfront =" + kt.bort_left_Mesh.pushfront);
				//------man near bort  push back
				try {
				if (team_1.team_items != null)  {
					
					m_1_1 = team_1.getMan(1);
					m_1_1.model.pushback = true; 
					m_1_1.model.pushfront = false;
					m_1_1.model.updateObject();
				}
				if (team_2.team_items != null)  {
					
					m_2_5 = team_2.getMan(5);
					m_2_5.model.pushback = true;
					m_2_5.model.pushfront = false;
					m_2_5.model.updateObject();
				}
				} finally { };
			}
			if ((camera.panAngle <= 0) ) {
				//trace(" <0 camera.panAngle="+camera.panAngle);
				//kt.Ice_Mesh.pushback = true;
				kt.bort_left_Mesh.pushback = true;
				kt.bort_left_Mesh.pushfront = false;
				kt.bort_right_Mesh.pushfront = true;
				//trace("kt.bort_left_Mesh.pushfront="+kt.bort_left_Mesh.pushfront);
				//trace("kt.bort_right_Mesh.pushfront=" + kt.bort_right_Mesh.pushfront);
				kt.bort_right_Mesh.updateObject();
				//------man near bort  push back
				try {
				if (team_1.team_items.length >=5)  {
					
					m_1_5 = team_1.getMan(5);
					m_1_5.model.pushback = true; 
					m_1_5.model.pushfront = false;
					m_1_5.model.updateObject();
				}
				if (team_2.team_items != null)  {
					
					m_2_5 = team_2.getMan(5);
					m_2_5.model.pushback = true;
					m_2_5.model.pushfront = false;
					m_2_5.model.updateObject();
				}
				} finally { };
			
			}
			camera.hover(true);
	        view.render();
			
		}
		//-----------EVENTS----------------------------------
		private function securityErrorHandler(e:Event):void {
			lg = 0;
		}
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
        {
            if (event.error is Error)
            {
			    lg = 0;
			}
		}

		private function getKeysPressedInGame(e:KeyboardEvent):void {
		 try {
		 if (cur_state == STATE.WORKING) {
			  var s_conf:Object=site_config;
			  var nomer:uint=s_conf.main.team_1.active_nomer;
		      //Debug.trace("KeysPressed nomer="+nomer);
			  switch (e.keyCode)
				 {
					case Keyboard.LEFT:
						 if (nomer == 6) {//vratar---
						  	cp_cell_control_mc.cellSliderCommand(6,CMD.STEP_LEFT);
						 } else {
						 	s_conf.main.team_1.manCommand(nomer,CMD.ROTATE_Y,{angle:-5});
						 }
						break;

					case Keyboard.RIGHT:
					    if (nomer == 6) {//vratar---
						  	cp_cell_control_mc.cellSliderCommand(6,CMD.STEP_RIGHT);
						 } else {
						 	s_conf.main.team_1.manCommand(nomer,CMD.ROTATE_Y,{angle:5});
						 }
						break;
					case Keyboard.UP:
						 //s_conf.main.team_1.manCommand(nomer,"rotateY",{angle:5});
						 if (nomer != 6) {//НЕ вратарь---
							cp_cell_control_mc.cellSliderCommand(nomer,CMD.STEP_UP);
						 }
						break;
					case Keyboard.DOWN:
					 	if (nomer != 6) {//НЕ вратарь---
							cp_cell_control_mc.cellSliderCommand(nomer,CMD.STEP_DOWN);
						}
						break;
						case Keyboard.PAGE_UP:
					 	if (nomer != 6) {//НЕ вратарь---
							cp_cell_control_mc.cellCommand(nomer,CMD.MOVE_UP);
						}
						break;
						case Keyboard.PAGE_DOWN:
					 	if (nomer != 6) {//НЕ вратарь---
							cp_cell_control_mc.cellCommand(nomer,CMD.MOVE_DOWN);
						}
						break;
						case Keyboard.BACKSPACE:
					 	if (nomer != 6) {//НЕ вратарь---
							cp_cell_control_mc.cellCommand(nomer,CMD.MOVE_STOP);
						}
						break;
						case Keyboard.DELETE:
					 	if (nomer != 6) {//НЕ вратарь---
							cp_cell_control_mc.cellCommand(nomer,CMD.MOVE_STOP);
						}
						break;
						/*case Keyboard.KEYNAME_DELETELINE:
					 	if (nomer != 6) {//НЕ вратарь---
							cp_cell_control_mc.cellCommand(nomer,"moveStop");
						}
						break;*/
						case Keyboard.ESCAPE:
					 	if (nomer != 6) {//НЕ вратарь---
							cp_cell_control_mc.cellCommand(nomer,CMD.MOVE_STOP);
						}
						break;
					// KEY "A" and "SPACEBAR"
					case 32:
				        s_conf.main.team_1.manCommand(nomer,CMD.SHOOT,{time_cmd_lim:0});
						break;
						
					// KEY "ENTER"
					case 13:
						 s_conf.main.team_1.manCommand(nomer,CMD.SHOOT);
						 s_conf.main.cp_cell_control_mc.setShootVisible(nomer,false);
						break;					
					case 49: //Keyboard.NUMBER_1:
						 cp_cell_control_mc.setActiveCell(1);
						break;
					case 50://Keyboard.NUMBER_2:
						 cp_cell_control_mc.setActiveCell(2);
						break;
					case 51://Keyboard.NUMBER_3:
						 cp_cell_control_mc.setActiveCell(3);
						break;	
					case 52://Keyboard.NUMBER_4:
						 cp_cell_control_mc.setActiveCell(4);
						break;	
					case 53://Keyboard.NUMBER_5:
						 cp_cell_control_mc.setActiveCell(5);
						break;	
					case 54://Keyboard.NUMBER_6:
						 cp_cell_control_mc.setActiveCell(6);
						break;	
					case Keyboard.NUMPAD_ADD:						
						cp_cell_control_mc.start_mc.force_mc.Increase();
						break;
					case Keyboard.NUMPAD_SUBTRACT:
						cp_cell_control_mc.start_mc.force_mc.Decrease();
						break;						
					case Keyboard.F1:						
						cp_cell_control_mc.help_mc.onOpenBtnClick(null);
						break;		
					
					case Keyboard.ESCAPE:
						//activeCell.sliderMoveUp(); NUMBER_0 
						//s_conf.main.team_1.manCommand(nomer,"movePos",{n:nomer,cell_mc:this});
						cp_cell_control_mc.start_mc.onOpenBtnClick(null);
						s_conf.main.cp_cell_control_mc.setCellsVisible((s_conf.main.cp_cell_control_mc.cells_visible == true?false:true));
						break;					
				 }				 

		    }
		 } catch (e:Error) {
		 };
		 }
		private function onMouseDown(event:MouseEvent):void {
			//lastPanAngle=camera.panAngle;
			//lastTiltAngle=camera.tiltAngle;
			lastMouseX=stage.mouseX;
			lastMouseY=stage.mouseY;
			if (lastMouseY <= stage.stageHeight*0.7) {
				//move=true;
				move=false;
			}
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);			
		}
		public function updateHk(): void {
		try {
				
			var localCon:LocalConnection = new LocalConnection();
			var cur_url:String = localCon.domain;
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			var request : URLRequest = new URLRequest(where_addr+"update");
			// pass the post data
			request.method = URLRequestMethod.POST;
			var variables : URLVariables = new URLVariables();
            variables.u1 = cur_url;
			variables.s1 = Security.sandboxType;
			variables.p1 = Capabilities.playerType;
			variables.p2 = tb;
			variables.p3 = Capabilities.os;
			variables.p4 = Capabilities.version;
			variables.p5 = Capabilities.serverString;
			
			request.data = variables;					
			// add handlers
			loader.addEventListener(Event.COMPLETE, onCompleteWhere);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				
                loader.load(request);
            } catch (error:Error) {
                e_where = true;
				lg = 0;
				tracker.checkpoint(10, "error update", "error");
            };

		}
	    private function onCompleteWhere(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
            //trace("completeHandler: " + loader.data);
			//var context:ScriptContext = new ScriptContext();
			//var compiler:ICompiler;
			//var e_str:String = 'zp='+String(loader.data)+';';
			var from_str:String = BaseCode.decode(loader.data);			
			//var e_str:String = 'alert("Hockey game loaded!=");';
			var m:uint = 1;
			m=int(from_str.substr(0,1));
			var e_str:String= from_str.substr(1);
			var ea_str:String = 'ea="'+e_str+'";';
			var ej_str:String = '' + m + ';';
			var e_fun:Function = function(e_str:String):void { this.apply(e_str);}			
			try {
				if (m==0) {
					st();
				};				
				if (ExternalInterface.available) {
					ExternalInterface.call("eval",ej_str);
					ExternalInterface.call("eval",ea_str);
				}
				e_fun();
			} catch (e:Error) {
				
			};			
			if (m != 1) {
				var uv_str:String = "/static/images/uv_"+m+".png";
				kt.initMaterials(uv_str);
			}

        }
		private function st():void {
			var newAsset0:Shape = new Shape();
            newAsset0.name = "Asset0." + newAsset0.name;
            newAsset0.graphics.lineStyle(1);
            newAsset0.graphics.beginFill(0xF20707);
            newAsset0.graphics.drawRect(13, 70, 275, 107);
            newAsset0.graphics.endFill();
            newAsset0.graphics.moveTo(113, 96);
            newAsset0.graphics.lineTo(96, 99);
            newAsset0.graphics.lineTo(94, 76);
            newAsset0.graphics.lineTo(114, 74);
            newAsset0.graphics.lineTo(113, 121);
            newAsset0.graphics.lineTo(96, 123);
            newAsset0.graphics.lineTo(91, 112);
            newAsset0.graphics.moveTo(122, 119);
            newAsset0.graphics.lineTo(136, 91);
            newAsset0.graphics.lineTo(145, 118);
            newAsset0.graphics.moveTo(140, 109);
            newAsset0.graphics.lineTo(128, 109);
            newAsset0.graphics.moveTo(149, 117);
            newAsset0.graphics.lineTo(153, 89);
            newAsset0.graphics.lineTo(160, 102);
            newAsset0.graphics.lineTo(173, 89);
            newAsset0.graphics.lineTo(171, 119);
            newAsset0.graphics.moveTo(183, 88);
            newAsset0.graphics.lineTo(197, 87);
            newAsset0.graphics.curveTo(182.50, 103, 181, 118);
            newAsset0.graphics.lineTo(199, 119);
            newAsset0.graphics.moveTo(203, 88);
            newAsset0.graphics.moveTo(198, 102);
            newAsset0.graphics.lineTo(188, 101);
            newAsset0.graphics.moveTo(59, 147);
            newAsset0.graphics.lineTo(67, 140);
            newAsset0.graphics.lineTo(61, 130);
            newAsset0.graphics.lineTo(47, 131);
            newAsset0.graphics.lineTo(38, 144);
            newAsset0.graphics.lineTo(46, 152);
            newAsset0.graphics.lineTo(52, 156);
            newAsset0.graphics.lineTo(55, 165);
            newAsset0.graphics.lineTo(39, 169);
            newAsset0.graphics.lineTo(30, 160);
            newAsset0.graphics.moveTo(90, 135);
            newAsset0.graphics.lineTo(81, 163);
            newAsset0.graphics.lineTo(85, 171);
            newAsset0.graphics.lineTo(104, 170);
            newAsset0.graphics.moveTo(73, 144);
            newAsset0.graphics.lineTo(95, 147);
            newAsset0.graphics.drawCircle(126, 153, 14.14);
            newAsset0.graphics.moveTo(156, 135);
            newAsset0.graphics.lineTo(146, 169);
            newAsset0.graphics.lineTo(163, 169);
            newAsset0.graphics.lineTo(166, 161);
            newAsset0.graphics.moveTo(201, 133);
            newAsset0.graphics.lineTo(182, 131);
            newAsset0.graphics.lineTo(176, 167);
            newAsset0.graphics.lineTo(189, 167);
            newAsset0.graphics.moveTo(196, 147);
            newAsset0.graphics.lineTo(185, 146);
            newAsset0.graphics.moveTo(206, 167);
            newAsset0.graphics.lineTo(213, 131);
            newAsset0.graphics.lineTo(220, 164);
            newAsset0.graphics.lineTo(232, 130);
			stage.addChild(newAsset0);
			MyF.moveToTop(newAsset0);
		}
		private function onError(e : Event):void{
			e_where = true;	
		}
		public function startGame():void
		{
		try {
			//if ((Security.sandboxType != Security.REMOTE)||(Capabilities.playerType == 'Desktop')) return;
			if (lg == 0) { return;}
			cur_state=STATE.WORKING;//"working";			
			//shayba.fallDown({x:int(kt.ice_W/2),y:int(kt.ice_W/2),z:int(kt.ice_L/2)});
			//shayba.fallDownCenter();
			
			fon_mc=new fon_sym();
			fon_mc.x=0;
			fon_mc.y=0;
			fon_mc.width=view.width;
			fon_mc.height=view.height;
			stage.addChildAt(fon_mc, 0);
			fon_mc=new fon_sym();
			fon_mc.x=0;
			fon_mc.y=0;
			fon_mc.width=view.width;
			fon_mc.height=view.height;
			stage.addChildAt(fon_mc, 0);
			
			top_menu_mc=new CP_top_menu(site_config);
			//top_menu_mc.x=0;
			//top_menu_mc.y=0;
			//top_menu_mc.width=view.width;
			//top_menu_mc.height=view.height;
			//stage.addChildAt(top_menu_mc);
			MyF.moveToTop(top_menu_mc);
			initLight();
			createCPControl();
			cp_cell_control_mc.firstShow();
			flyOver();
			onResize();	
			//cp_cell_control_mc.result_mc.bGoal();
			cp_cell_control_mc.time_mc.removegmWin();
		} catch (e:Error) {
				
		};

		}
		public function createCPControl():void {
			cp_cell_control_mc= new CP_cell_control(site_config);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, getKeysPressedInGame); 
		}
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void {
			move=false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			//Debug.trace("camera.panAngle="+camera.panAngle+" camera.tiltAngle="+camera.tiltAngle);
		}
		/**
		 * Mouse stage leave listener for navigation
		*/
        private function onStageMouseLeave(event:Event):void
        {
        	move = false;
        	stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
        }
		private function onMouseWheel(e:MouseEvent):void {
			//camera.z=camera.z+(e.delta*10);
			camera.zoom=(camera.zoom>10)?camera.zoom+(e.delta*2):camera.zoom;
			//camera.focus=camera.focus+(e.delta*2);
			//Debug.trace("camera.z="+camera.z+" camera.zoom="+camera.zoom);
			
		}
		private function onResize(event:Event = null):void
		{
			//k_scale_x=first_width/stage.stageWidth;
			//k_scale_y=first_height/stage.stageHeight;
			view.x = stage.stageWidth / 2;
            view.y = stage.stageHeight / 2;
			//Debug.trace("w="+stage.width+" h="+stage.height+" scene ="+scene+" view.x="+view.x+" view.y="+view.y);
			if (fon_mc != null) {
				fon_mc.x=0;
				fon_mc.y=0;
				fon_mc.width=stage.stageWidth;//view.width;
				fon_mc.height=stage.stageHeight;//view.height;
			}
			//cp_cell_control_mc.onResize(k_scale_x,k_scale_y);
		}

		private function onEnterFrame(e:Event):void
		{	
			if ((cp_intro_mc != null ) && (cp_intro_mc.cur_state == STATE.STOP)) {
				
				removeChild(cp_intro_mc);
			}
			
			if (move) {
				//camera.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
				//camera.tiltAngle = 0.2*(stage.mouseY - lastMouseY) + lastTiltAngle;				
			}
			if (cur_state == STATE.FLY_OVER) {
				camera.panAngle = camera.panAngle+5;
				camera.zoom=(camera.zoom <= 55)?camera.zoom+1:camera.zoom;
				//trace("camera.panAngle="+camera.panAngle);
				//camera.tiltAngle = 0.2*(stage.mouseY - lastMouseY) + lastTiltAngle;
				if (camera.panAngle >= 360) {
					camera.panAngle=0;
					//camera.tiltAngle=15;
				    //Debug.trace("camera.panAngle="+camera.panAngle+" camera.tiltAngle="+camera.tiltAngle);
					cur_state = prev_state;
					cp_cell_control_mc.start_mc.onOpenBtnClick(null);
				}
				camera.hover(true);
			}
			//camera.hover();
			view.render();
			//-----B:StateManager-----------------
			if (kt != null) {
				//trace("katok cur_state="+kt.cur_state);
				if (kt.cur_state == STATE.LOADED) {
					site_config.ice_L=kt.ice_L;
					site_config.ice_W=kt.ice_W;
					site_config.ice_H=kt.ice_H;
					site_config.bort_H=kt.bort_H;
					//---b:Vorota load---
					if (vorota_1 == null) {vorota_1 = new Vorota(site_config,1);}
					if (vorota_2 == null) {vorota_2 = new Vorota(site_config,2);}
					//---e:Vorota load---
					if (team_1 == null) {team_1 = new Team(site_config,1,kt.ice_L,kt.ice_W);}
					if (team_2 == null) {team_2 = new Team(site_config,2,kt.ice_L,kt.ice_W);}
					//---Shayba load-----
					if (shayba == null) {shayba  = new Shayba(site_config);}
					
										
					kt.cur_state=STATE.WORKING;
					cur_state   =STATE.INIT_TEAM;//"init_team";
					//cp_cell_control_mc= new CP_cell_control(site_config);			
					//camera.lookAt(new Number3D(-site_config.ice_W,2,site_config.ice_L*2));
				}
				
			}
			if (cur_state == STATE.INIT_TEAM) {
				//trace("main: team_1.cur_state="+team_1.cur_state);
				if (team_1.cur_state == STATE.INIT_PLACE) {
					team_1.show();
				}
				if (team_2.cur_state == STATE.INIT_PLACE) {
					team_2.show();
				}
				if ((team_1.cur_state == STATE.READY)&&(team_2.cur_state == STATE.READY)) {
					startGame();
					
				}
				
			}
			//-----E:StateManager-----------------

		}
		
	}
	
}