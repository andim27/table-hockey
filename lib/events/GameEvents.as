package events {

import flash.events.Event;

public class GameEvents extends Event {
 public static const GAME_START:String = "game_start";
 public static const GAME_OVER:String  = "game_over";
 public static const GAME_STOP:String  = "game_stop";
 public static const TEAM_FIRST:String = "team_first";
 public static const SHOOT:String      = "shoot"; //--когда ударили по шайбе - это бросок
 public static const GOAL:String       = "goal";

 private var param_event:Array = new Array();
 public var event_arr:Array = new Array();
 public var event_str:String;
 public var event_obj:Object;
 public var event_label:String;
 public var event_value:String;
 public function GameEvents (type:String, bubbles:Boolean=true, cancelable:Boolean=false){
     super(type, bubbles, cancelable);
	 //param_event_arr=param;     
	 //trace("ControlPanelEvents="+param);
 }
 public function get paramEvent():Array {
             return param_event;
 }
 public override function clone():Event 
 { 
	return new GameEvents(type, bubbles, cancelable);
 }
 public override function toString():String { 
         // return formatToString("ControlPanelEvents");
  	return formatToString("GameEvents", "type", "bubbles", "cancelable", "eventPhase");
 }


}
}