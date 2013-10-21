package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField;

	/**
	 * ...
	 * @author AndMak
	 */
	public class Preloader extends MovieClip 
	{
		private var ppp:TextField;
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
			ppp = new TextField();
			ppp.x = 100;
			ppp.y = 100;
			addChild(ppp);

		}
		
		private function progress(e:ProgressEvent):void 
		{
			// update loader
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			} else
			{
				ppp.text = loaderInfo.bytesLoaded.toString() + " / " + loaderInfo.bytesTotal.toString();
			}

		}
		
		private function startup():void 
		{
			// hide loader
			trace("PPPPPPPP sssssssssss");
			stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}