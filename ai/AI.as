package  ai {

import flash.display.*;
import flash.events.Event;
	
	public class AI extends Sprite {
	public static var cur_state:uint;
	public static const STATE_STOP:uint = 0;
	public static const STATE_GET_INFO:uint = 1;
	public static const STATE_THINKING:uint= 2;
	public static const STATE_SEND_COMMAND:uint = 3;
	
	public var s_conf:Object;
	public var body_obj:Object;
	protected var cur_cmd:String;
		public function AI(s_c:Object,parent_mc:Object):void {
			// constructor code
			s_conf=s_c;
			body_obj=parent_mc;
			trace("AI parent_mc="+body_obj);
			initVars();
			initEvents(); 
			cur_state=STATE_GET_INFO;
		}
		public function initVars():void {
			// code
			cur_state=STATE_STOP;
		}
		public function initEvents():void {
			// code
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		public function getExternalInfo():void {
			// code
			cur_state=STATE_GET_INFO;
		}
		public function getBodyInfo():void {
			// code
			cur_state=STATE_GET_INFO;
		}
		public function analyze():void {
			// code
			cur_state=STATE_THINKING;
		}
		public function sendCommand(cmd:String="",param:Object=null):void  {
			cur_state=STATE_SEND_COMMAND;
			cur_cmd=cmd;
			// code
		}
		public function startThink():void {
			cur_state=STATE_GET_INFO;
		}
		public function stopThink():void {
			cur_state=STATE_STOP;
		}
		//-----------------------Events-------------------
		private function onEnterFrame(e:Event):void {
			//trace("AI onEnterFrame ");
			if (cur_state != STATE_STOP) {
				getExternalInfo();
				getBodyInfo();
				analyze();
				sendCommand();
			}
		 }

	}
	
}
