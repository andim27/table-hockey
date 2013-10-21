package utils {
	
	public class STATE {
	  //--Main	 
	  public static var INIT:uint = 0;
	  public static var INIT_ENGINE:uint = 1;
	  public static var INIT_3D:uint = 2;	 
	  public static var INIT_ALL:uint = 3;
	  
	  public static var LOAD_MODEL:uint = 4;
	  public static var LOAD_MATERIAL:uint = 5;
	  public static var LOADED:uint = 6;
	  
	  public static var READY:uint = 7;
	  public static var WORKING:uint = 8;
	  public static var STOP:uint = 9;
	  public static var MOVE:uint = 10;
	  //---Man state	  
	  public static var MOVE_UP:uint = 11;
	  public static var MOVE_DOWN:uint = 12;
	  public static var MOVE_LEFT:uint = 13;
	  public static var MOVE_RIGHT:uint = 14;
	  public static var MOVE_LEFT_LIMIT:uint = 15;
	  public static var MOVE_RIGHT_LIMIT:uint = 16;
	  public static var MOVE_STOP:uint = 17;
	  public static var MOVE_TO_POINT:uint = 18;	
	  public static var ROTATE_Y:uint = 19;	
	  public static var SHOOT_TO_POINT:uint = 20;
	  public static var SHOOT:uint = 21;
	  public static var SHOOT_DONE:uint = 22;
	  //--Shayba state	  
	  public static var FOLLOW_TO:uint = 31;	
	  //--Katok state
	  //--Vorota
	  //----------------Team--------------
	  public static var INIT_TEAM:uint = 41;
	  public static var INIT_PLACE:uint = 42;
	 
	  //------------Phisics engine---------
	  public static var GOAL_1:uint = 51;
	  public static var GOAL_2:uint = 52;
	 
	  //------------control panel-------
	  public static var RIGHT:uint = 61;
	  public static var LEFT:uint = 62;
 	  public static var CENTER:uint = 63;
	  public static var SHOW_ALERT:uint = 64;
	  public static var POS_0:uint = 65;
	  public static var POS_1:uint = 66;
	  public static var POS_2:uint = 67;
	  public static var POS_3:uint = 68;
	  
	  //---------------Camera------------
	  public static var FLY_OVER:uint = 70;
	  
	  //----------------AI-------------
	  public static const GET_INFO:uint = 81;
	  public static const THINKING:uint= 82;
	  public static const SEND_COMMAND:uint = 83;
	}
	
}
