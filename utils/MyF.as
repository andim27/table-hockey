﻿package utils {

public class MyF {
/*
public function MyF() {
}
*/
public static function random(minNum:Number, maxNum:Number, round:Boolean = true) {

 if(minNum < 0) {
	var posMin = (minNum*-1);
	var range = posMin+maxNum;
	if(round) { return Math.floor(Math.random() * (range - 1))-posMin; }
	else { return Math.random() * (range - 1)-posMin; }
	} else {
		if(round) { return Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum; }
			else { return Math.random() * (maxNum - minNum + 1) + minNum; }
		}
	}
 }
}