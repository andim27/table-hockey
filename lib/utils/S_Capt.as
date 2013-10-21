package utils {

import flash.net.FileReference;
import flash.events.*;
import flash.ui.Keyboard;
import flash.events.KeyboardEvent;
import com.dd.screencapture.ScreenCapture;
import com.dd.screencapture.SimpleFlvWriter;

public class S_Capt {	 


private var screenCapture:ScreenCapture;
private var cur_stage:Object;

public function S_Capt(st:Object):void {
 cur_stage = st;
 cur_stage.addEventListener(KeyboardEvent.KEY_DOWN, getKeysControl); 
 onInit();
}	 

private function onInit():void
{
	    screenCapture = ScreenCapture.getInstance();
	    screenCapture.source = cur_stage;
	    screenCapture.fps = 12;
	    screenCapture.size(cur_stage.width, cur_stage.height);//cur_stage.width, cur_stage.height
	    screenCapture.x = cur_stage.x;
	    screenCapture.y = cur_stage.y;
	    cur_stage.addChild( screenCapture );
}
	 
private function startRecord( event:MouseEvent ):void
{
	    screenCapture.record();
}
	 
private function stopRecord( event:MouseEvent ):void
{
	    screenCapture.stop();
}
	 
private function playVideo( event:MouseEvent ):void
{
	    screenCapture.play();
}
private function getKeysControl(e:KeyboardEvent):void {
	 try {
		 switch (e.keyCode)
				 {
					case flash.ui.Keyboard.F9:
						screenCapture.record();
						break;
					case  flash.ui.Keyboard.F10:
						screenCapture.stop();
						break;
					case  flash.ui.Keyboard.F11:
						var saveFile:FileReference = new FileReference();
						saveFile.save( screenCapture.data, "video.flv" );
						break;
				 }
		 
	 } catch (e:Error) {
		 
	 }
}
}

}