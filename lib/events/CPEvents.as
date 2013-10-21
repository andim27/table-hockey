package events {

import flash.events.Event;

public class CPEvents extends Event {
 public static const CP_OPEN:String         = "cp_open";
 public static const CAMERA_CONTROL:String  = "camera_control";
 public static const MAN_CONTROL:String     = "man_control";
 public static const MAN_SELECT:String      = "man_select";
 public static const SHAYBA_CONTROL:String  = "shayba_control";
 public static const VRATAR_CONTROL:String  = "vratar_control";
 public static const SHOT_CONTROL:String    = "shot_control";

 private var param_event:Array = new Array();
 public var event_arr:Array = new Array();
 public var event_obj:Object;
 public var event_str:String;
 public var event_label:String;
 public var event_value:String;
 public function CPEvents (type:String, bubbles:Boolean=true, cancelable:Boolean=false){
     super(type, bubbles, cancelable);
	 //param_event_arr=param;     
	 //trace("ControlPanelEvents="+param);
 }
 public function get paramEvent():Array {
             return param_event;
 }
 public override function clone():Event 
 { 
	return new CPEvents(type, bubbles, cancelable);
 }
 public override function toString():String { 
         // return formatToString("ControlPanelEvents");
  	return formatToString("CPEvents", "type", "bubbles", "cancelable", "eventPhase");
 }


}
}