/*
	Class for using instead of flash.ui.Keyboard, because original class does not have codes for some keys
    Copyright (C) 2008  Siliren

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
/*
Класс используется вместо flash.ui.Keyboard, потому что оригинальный класс не содержит кодов для некоторых клавиш
*/
package utils
{
	public final class Keyboard
	{
		public function Keyboard()
			{
			super();
		}
		public static function get CAPS_LOCK : uint 
		{
			return flash.ui.Keyboard.CAPS_LOCK;
		}
		public static function get BACKSPACE : uint 
		{
			return flash.ui.Keyboard.BACKSPACE;
		}
		public static function get CONTROL : uint 
		{
			return flash.ui.Keyboard.CONTROL;
		}
		public static function get DELETE : uint 
		{
			return flash.ui.Keyboard.DELETE;
		}
		public static function get DOWN : uint 
		{
			return flash.ui.Keyboard.DOWN;
		}
		public static function get END : uint 
		{
			return flash.ui.Keyboard.END;
		}
		public static function get ENTER : uint 
		{
			return flash.ui.Keyboard.ENTER;
		}
		public static function get ESCAPE : uint 
		{
			return flash.ui.Keyboard.ESCAPE;
		}
		public static function get F1 : uint 
		{
			return flash.ui.Keyboard.F1;
		}
		public static function get F2 : uint 
		{
			return flash.ui.Keyboard.F2;
		}
		public static function get F3 : uint 
		{
			return flash.ui.Keyboard.F3;
		}
		public static function get F4 : uint 
		{
			return flash.ui.Keyboard.F4;
		}
		public static function get F5 : uint 
		{
			return flash.ui.Keyboard.F5;
		}
		public static function get F6 : uint 
		{
			return flash.ui.Keyboard.F6;
		}
		public static function get F7 : uint 
		{
			return flash.ui.Keyboard.F7;
		}
		public static function get F8 : uint 
		{
			return flash.ui.Keyboard.F8;
		}
		public static function get F9 : uint 
		{
			return flash.ui.Keyboard.F9;
		}
		public static function get F10 : uint 
		{
			return flash.ui.Keyboard.F10;
		}
		public static function get F11 : uint 
		{
			return flash.ui.Keyboard.F11;
		}
		public static function get F12 : uint 
		{
			return flash.ui.Keyboard.F12;
		}
		public static function get F13 : uint 
		{
			return flash.ui.Keyboard.F13;
		}
		public static function get F14 : uint 
		{
			return flash.ui.Keyboard.F14;
		}
		public static function get F15 : uint 
		{
			return flash.ui.Keyboard.F15;
		}
		public static function get HOME : uint 
		{
			return flash.ui.Keyboard.HOME;
		}
		public static function get INSERT : uint 
		{
			return flash.ui.Keyboard.INSERT;
		}
		public static function get LEFT : uint 
		{
			return flash.ui.Keyboard.LEFT;
		}
		public static function get NUMPAD_0 : uint 
		{
			return flash.ui.Keyboard.NUMPAD_0;
		}
		public static function get NUMPAD_1 : uint 
		{
			return flash.ui.Keyboard.NUMPAD_1;
		}
		public static function get NUMPAD_2 : uint 
		{
			return flash.ui.Keyboard.NUMPAD_2;
		}
		public static function get NUMPAD_3 : uint 
		{
			return flash.ui.Keyboard.NUMPAD_3;
		}
		public static function get NUMPAD_4 : uint 
		{
			return flash.ui.Keyboard.NUMPAD_4;
		}
		public static function get NUMPAD_5 : uint 
		{
			return flash.ui.Keyboard.NUMPAD_5;
		}
		public static function get NUMPAD_6 : uint 
		{
			return flash.ui.Keyboard.NUMPAD_6;
		}
		public static function get NUMPAD_7 : uint 
		{
			return flash.ui.Keyboard.NUMPAD_7;
		}
		public static function get NUMPAD_8 : uint 
		{
			return flash.ui.Keyboard.NUMPAD_8;
		}
		public static function get NUMPAD_9 : uint 
		{
			return flash.ui.Keyboard.NUMPAD_9;
		}
		public static function get NUMPAD_ADD : uint 
		{
			return flash.ui.Keyboard.NUMPAD_ADD;
		}
		public static function get NUMPAD_DECIMAL : uint 
		{
			return flash.ui.Keyboard.NUMPAD_DECIMAL;
		}
		public static function get NUMPAD_DIVIDE : uint 
		{
			return flash.ui.Keyboard.NUMPAD_DIVIDE;
		}
		public static function get NUMPAD_ENTER : uint 
		{
			return flash.ui.Keyboard.NUMPAD_ENTER;
		}
		public static function get NUMPAD_MULTIPLY : uint 
		{
			return flash.ui.Keyboard.NUMPAD_MULTIPLY;
		}
		public static function get NUMPAD_SUBTRACT : uint 
		{
			return flash.ui.Keyboard.NUMPAD_SUBTRACT;
		}
		public static function get PAGE_DOWN : uint 
		{
			return flash.ui.Keyboard.PAGE_DOWN;
		}
		public static function get PAGE_UP : uint 
		{
			return flash.ui.Keyboard.PAGE_UP;
		}
		public static function get RIGHT : uint 
		{
			return flash.ui.Keyboard.RIGHT;
		}
		public static function get SHIFT : uint 
		{
			return flash.ui.Keyboard.SHIFT;
		}
		public static function get SPACE : uint 
		{
			return flash.ui.Keyboard.SPACE;
		}
		public static function get TAB : uint 
		{
			return flash.ui.Keyboard.TAB;
		}
		public static function get UP : uint 
		{
			return flash.ui.Keyboard.UP;
		}
		public static function get capsLock():Boolean 
		{
			return flash.ui.Keyboard.capsLock;
		}
		public static function get numLock():Boolean 
		{
			return flash.ui.Keyboard.numLock;
		}
		public static function isAccessible():Boolean 
		{
			return flash.ui.Keyboard.isAccessible();
		}
		public static const ALTERNATE : uint = 18;
		public static const COMMA : uint = 188;
		public static const COMMAND : uint = 15;
		public static const BACKQUOTE : uint = 192;
    	public static const BACKSLASH : uint = 220;
    	public static const EQUAL : uint = 187
    	public static const LEFTBRACKET : uint = 219;
    	public static const MINUS : uint = 189;
    	public static const NUMBER_0 : uint = 48
    	public static const NUMBER_1 : uint = 49
    	public static const NUMBER_2 : uint = 50
    	public static const NUMBER_3 : uint = 51
    	public static const NUMBER_4 : uint = 52
    	public static const NUMBER_5 : uint = 53
    	public static const NUMBER_6 : uint = 54
    	public static const NUMBER_7 : uint = 55
    	public static const NUMBER_8 : uint = 56
    	public static const NUMBER_9 : uint = 57 
    	public static const PERIOD : uint = 190;
    	public static const QUOTE : uint = 222;
    	public static const RIGHTBRACKET : uint = 221;
    	public static const SEMICOLON : uint = 186;
    	public static const SLASH : uint = 191;


		public static const A : uint = 65;
    	public static const B : uint = 66;
    	public static const C : uint = 67;
    	public static const D : uint = 68;
    	public static const E : uint = 69;
    	public static const F : uint = 70;
    	public static const G : uint = 71;
    	public static const H : uint = 72;
    	public static const I : uint = 73;
    	public static const J : uint = 74;
    	public static const K : uint = 75;
    	public static const L : uint = 76;
    	public static const M : uint = 77;
    	public static const N : uint = 78;
    	public static const O : uint = 79;
    	public static const P : uint = 80;
    	public static const Q : uint = 81;
    	public static const R : uint = 82;
    	public static const S : uint = 83;
    	public static const T : uint = 84;
    	public static const U : uint = 85;
    	public static const V : uint = 86;
    	public static const W : uint = 87;
    	public static const X : uint = 88;
    	public static const W : uint = 89;
    	public static const Z : uint = 90;

    	
	}
}