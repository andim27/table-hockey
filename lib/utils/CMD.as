package utils {
	
	public class CMD {
	  //--Stop
	  public static var CMD_STOP:uint = 0;//----!!!! Номер обязательно 0 !!!!
	  //--Shoot 
	  public static var SHOOT:uint = 1;
	  public static var SHOOT_TO_POINT:uint = 2;
	  public static var SHOOT_TO_GOAL:uint = 3;
	  //---Move	
	  public static var MOVE_TO_POINT:uint = 4;	 
	  public static var MOVE_POINT:uint = 5;
	  public static var MOVE_STOP:uint = 6;
	  public static var MOVE_POS:uint = 7;
	  
	  public static var MOVE_UP:uint = 8;
	  public static var MOVE_DOWN:uint = 9;
	  public static var MOVE_LEFT:uint = 10;
	  
	  public static var MOVE_LEFT_LIMIT:uint = 11;
	  public static var MOVE_RIGHT:uint = 12;
	  public static var MOVE_RIGHT_LIMIT:uint = 13;
	
	   //---Rotate
	  public static var ROTATE_LEFT:uint = 14;
	  public static var ROTATE_RIGHT:uint = 15;
	  public static var ROTATE_Y:uint = 16;
	  //----Show
	  public static var SHOW_ACTIVE:uint = 17;
	  //---Step
	  public static var STEP_UP:uint = 18;
	  public static var STEP_DOWN:uint = 19;
	  public static var STEP_LEFT:uint = 20;
	  public static var STEP_RIGHT:uint = 21;
	  
	}
	
}
