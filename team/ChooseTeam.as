package team {
import flash.display.*;
import flash.text.TextField;
import flash.events.Event;
import flash.events.MouseEvent;
import lib.events.GameEvents;

public class ChooseTeam extends MovieClip {
 public var cur_state:String;
 public var nomer:int;
 private var max_cnt:int;
 private var x_start,y_start:int;
 public function ChooseTeam(type_team=1) {
	cur_state="init";
	initVars();
	initEvents();
 }
 private function initVars() {
	nomer=1;
	max_cnt=4;
	start_btn.visible=false;
	team_1_mc.gotoAndStop(2);
 }
 private function selectUserTeam(cur_n) {
 var team_mc;
 	start_btn.visible=true;
	for (var i:int=1;i<=max_cnt;i++) {
		 team_mc=this["team_"+i+"_mc"];
		 if (cur_n == i) {
			 team_mc.gotoAndStop(2);
		 } else {
			 team_mc.gotoAndStop(1);
		 }
	 }
 }
 private function showChooseTeam() {
	 this.x=x_start;
	 this.y=y_start;
 }
 private function closeChooseTeam() {
	 //removeChild(DisplayObject(this));
	 trace(this);
	 removeChild(this);
 }
 private function initEvents() {
	 start_btn.addEventListener(MouseEvent.CLICK,onClickStart);
	 team_1_mc.addEventListener(MouseEvent.CLICK,onClickItemTeam);
	 team_2_mc.addEventListener(MouseEvent.CLICK,onClickItemTeam);
	 team_3_mc.addEventListener(MouseEvent.CLICK,onClickItemTeam);
 	 team_4_mc.addEventListener(MouseEvent.CLICK,onClickItemTeam);
 }
 private function onClickStart(e:MouseEvent) {	
	 var objEvent=new GameEvents(GameEvents.GAME_START);
	 objEvent.event_obj={user_team:nomer};
	 dispatchEvent(objEvent);
	 closeChooseTeam();
	 cur_state="choosed";
 }
  private function onClickItemTeam(e:MouseEvent) {	  
	  var cur_team=e.target.name;
	  nomer = cur_team.split("_",2)[1];
	  selectUserTeam(nomer);
  }
}
}