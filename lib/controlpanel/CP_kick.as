package controlpanel
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import controlpanel.CP_force;
import flash.events.MouseEvent;
import utils.MyF;
import utils.CMD;
import flash.filters.DropShadowFilter;
import flash.filters.BitmapFilterQuality;
import com.greensock.*;
import com.greensock.easing.*;
import com.bit101.components.*;
	/**
	 * ...
	 * @author (c)AndMak
	 */
	public class  CP_kick extends CP_kicksym 
	{
		public var s_conf:Object;
		private var first_x:int;
		private var first_y:int;
		private var kick_btn:Sprite;
		public var force_mc:CP_force;  //--индикатор силы удара
		public var round_slider_mc:Knob;// RoundSlider;  //--индикатор направления удара
		private var oldVal:int; //--for roundslider
		 
		public function  CP_kick(s_c:Object, x1:int, y1:int):void {	
			s_conf = s_c; 
			
			initVars();	
			initEvents();				
			x=first_x=x1;
			y = first_y = y1;			
			//s_conf.stage.addChild(this);
		}
		protected  function initVars():void {
			 this.filters = [new DropShadowFilter(10,45,0x000000,0.8,8,8,0.65,BitmapFilterQuality.HIGH,false,false)];			
			 createKickBtn();
			
			 visible = false;
		}
		
		private function createKickBtn():void 
		{
			kick_btn = new Sprite();
			kick_btn.graphics.beginFill(0x555555);			
			kick_btn.graphics.drawCircle(0, 0, 30);
			kick_btn.graphics.endFill();
			kick_btn.graphics.beginFill(0x000000);			
			kick_btn.graphics.drawCircle(0, 0, 24);
			kick_btn.graphics.endFill();
			kick_btn.x = this.width * 0.45;
			kick_btn.y = this.height * 0.57;
			kick_btn.width = 32;
			kick_btn.height = 32;
			kick_btn.useHandCursor = true;
			this.addChild(kick_btn);
			var _label:Label = new Label(this, kick_btn.x - 14, kick_btn.y-10, "Kick");
			_label.setTextColor(0xFFFFFF);
		}
		 
		public function firstShow():void {
			this.x=first_x;
			this.y=-200;
			this.alpha=0;
			s_conf.stage.addChild(this);		
			visible = true;
			addCPforce();
			addRoundSlider();
			TweenLite.to(this,4,{y:first_y,x:first_x,delay:0.5,alpha:100,ease:Elastic.easeOut});
		 }
		public function addCPforce():void {
			force_mc = new CP_force(s_conf, this.width * 0.76, this.height * 0.60, 2, 11, 8);

			trace("Force_mc.x=" + force_mc .x+" y="+force_mc .y);
			this.addChild(force_mc);
			force_mc.visible=true;
			//MyF.moveToTop(force_mc);
		}
		public function addRoundSlider():void {
		

			round_slider_mc = new Knob(this, this.width * 0.10, this.height * 0.12, "");
			round_slider_mc.minimum = 0;
			round_slider_mc.maximum = 360;
			round_slider_mc.value = 180;
			oldVal  = round_slider_mc.value;
			round_slider_mc.radius = 15;
			round_slider_mc.showValue=false;
			round_slider_mc.mode=Knob.ROTATE;
			this.addChild(round_slider_mc);
			round_slider_mc.addEventListener(Event.CHANGE, onSliderChange);
		}
		public function setActiveNomerRotation(n:Number):void {
			if ((n >= 0) || (n <= 360) ) {
				round_slider_mc.value = int(n);
			}
			//trace("setActiveNomerRotation n="+n+" round_slider_mc.value="+round_slider_mc.value);
			
		}
		public function onSliderChange(e:Event):void 
		{
			
			var nomer:uint = s_conf.main.team_1.active_nomer;
			var angel_rot:uint = round_slider_mc.value;
			var k:uint = 1;
			if (angel_rot < oldVal) {				
				s_conf.main.team_1.manCommand(nomer,CMD.ROTATE_LEFT,{angle:k});
			} else {
				s_conf.main.team_1.manCommand(nomer,CMD.ROTATE_RIGHT,{angle:k});				
			}
			//trace("slider angel_rot="+angel_rot+" nomer="+nomer);
			oldVal = round_slider_mc.value;
		
		}
		protected  function initEvents():void {	
			  kick_btn.addEventListener(MouseEvent.CLICK, onKickBtn);
		}
		
		private function onKickBtn(e:MouseEvent):void 
		{
			
			var nomer:uint = s_conf.main.team_1.active_nomer;
			trace("kick nomer="+nomer);
			s_conf.main.team_1.manCommand(nomer,CMD.SHOOT,{time_cmd_lim:0});
		}
	}
	
}