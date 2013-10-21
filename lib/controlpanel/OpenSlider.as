package controlpanel {
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.*;
	 
	public class OpenSlider extends EventDispatcher {
		
	    private var _btn:Sprite;
	    private var _line:Sprite;
		private var _rect:Rectangle;
		private var _percent:Number;
		private var _scrollMode:String;
		private var _sliderName:String;
		
		private var _min:Number;
		private var _max:Number;
		
		public function OpenSlider(btn:Sprite, line:Sprite) {
			
			_btn = btn;
			_line = line;
			_min = 0;
			_max = 1;
			
			var bounds:Rectangle;
			bounds = line.getRect(line.parent);
			
			if (line.width > line.height) {
				_scrollMode = "horizontal";
				_rect = new Rectangle(bounds.left,
									 (bounds.top + bounds.bottom)/2,
									  bounds.width,
									  0);  
				_btn.x = Math.min(_rect.right, Math.max(_rect.left, _btn.x));
				_btn.y = _rect.y;
			} else {
				_scrollMode = "vertical";
				_rect = new Rectangle((bounds.left + bounds.right) / 2,
									   bounds.top,
									   0,
									   bounds.height);
				_btn.y = Math.min(_rect.bottom, Math.max(_rect.top, _btn.y));
				_btn.x = _rect.x;
			}
			
			_btn.buttonMode = true;
			_btn.mouseChildren = false;
			_btn.addEventListener(MouseEvent.MOUSE_DOWN, onBtnDown, false, 0, true);
			_btn.addEventListener(MouseEvent.MOUSE_UP, onBtnUp, false, 0, true);
			onChange(new Event(Event.CHANGE));
			
		}
		public function setLineWidth(n:Number):void {			
			_rect.width = n;
		}
		public function setLineHeight(n:Number):void {
			_rect.height = n;
		}
		private function onBtnDown(evt:MouseEvent):void {
			_btn.stage.addEventListener(MouseEvent.MOUSE_UP, onBtnUpOutside, false, 0, true);
			_btn.startDrag(false, _rect);
			_btn.addEventListener(Event.ENTER_FRAME, onChange, false, 0, true);
			_btn.stage.addEventListener(Event.MOUSE_LEAVE, onBtnUp, false, 0, true);
		}
		
		private function onBtnUp(evt:MouseEvent):void {
			_btn.stopDrag();
			_btn.removeEventListener(Event.ENTER_FRAME, onChange);
			_btn.stage.removeEventListener(Event.MOUSE_LEAVE, onBtnUp);
		    _btn.stage.removeEventListener(MouseEvent.MOUSE_UP, onBtnUpOutside);
		}
		
		private function onBtnUpOutside(evt:MouseEvent):void {
		 if (evt.target != this){
			_btn.stopDrag();
			_btn.removeEventListener(Event.ENTER_FRAME, onChange);
		 }
		 _btn.stage.removeEventListener(Event.MOUSE_LEAVE, onBtnUp);
		 _btn.stage.removeEventListener(MouseEvent.MOUSE_UP, onBtnUpOutside);
	    }
		
		public function onChange(evt:Event=null):void {
			if (_scrollMode == "horizontal") {
				_percent = (int(_btn.x) - int(_rect.left)) / int(_rect.width);
			}else{
				_percent = (int(_rect.bottom) - int(_btn.y)) / int(_rect.height);
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get percent():Number {
			return Math.max(0, Math.min(1, _percent));
		}
		
		public function set percent(p:Number):void {
			_percent = p;
			if (_scrollMode == "horizontal"){
				_btn.x = int(_rect.left) + (int(_rect.width) * _percent);
			}else{
				_btn.y = int(_rect.bottom) - (int(_rect.height) * _percent);
			}
		}
		
		public function set name(n:String):void {
			_sliderName = n;
		}
		public function get name():String {
			return _sliderName;
		}
		public function setRange(min:Number, max:Number):void {
			_min = min;
			_max = max;
		}
		public function get min():Number {
			return _min;
		}
		public function set min(min:Number):void {
			_min = min;
		}
		
		public function get max():Number {
			return _max;
		}
		public function set max(max:Number):void {
			_max = min;
		}
		public function get value():Number {
			return (_max-_min) * percent + _min;
		}
		public function set value(val:Number):void {
			val += Math.abs(_min);
			percent = val / (_max-_min);
		}
	}
}