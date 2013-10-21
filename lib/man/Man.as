package man {
import flash.display.*;
import flash.events.Event;
import flash.filters.*;

import com.greensock.*;
import com.greensock.easing.*;

import away3d.core.base.Face;
import away3d.containers.*;
import away3d.materials.*;
import away3d.events.*;
import away3d.core.base.*;
import away3d.core.utils.*;
import away3d.loaders.utils.*;
import away3d.loaders.*;
import away3d.primitives.*;
import away3d.cameras.*;
import away3d.materials.utils.SimpleShadow; 

//import caurina.transitions.Tweener;
//import caurina.transitions.properties.CurveModifiers;
import man.ManMesh;
import events.*;
import ai.*;
import utils.*;
import utils.MyF;

public class Man extends Sprite {
 public var mc:Object;
 public var s_conf:Object;
 public var cur_state:uint;
 public var prev_state:uint;
 public var cur_cmd:uint;//--выполняемая команда
 public var time_state:Number;//--время нахождения в состоянии в сек
 public var time_cmd:Number;//--время выполнения ТЕКУЩЕЙ команды в сек
 public var time_cmd_lim:Number;//--предел времени выполнения ТЕКУЩЕЙ команды в сек
 public var site_path:String;
 public var path_model:String;
 public var path_file:String;
 public var model_name:String;
 public var file_model:String;
 public var file_material:String;
 public var nomer:int =0;
 public var team_nomer:int = 0;
 public var selected:Boolean = false;
 
 private var scene:Scene3D;
 private var collada:Collada;
 private var max3ds:Max3DS;
 private var s_shadow:SimpleShadow;
 //material objects
private var materialArray:Array;
private var materialIndex:int = 0;
private var mat_file_name:BitmapFileMaterial;
private var material:BitmapMaterial;
		
 private var loader:Loader3D;
 
 public var model:Mesh;//Object3D;
 //public var model:ManMesh;
 
 private var tween_param:Object;
 private var first_x:int;
 private var first_y:int;
 private var first_scale:int;
 private var first_rotation:int;
 private var force:int;//--сила удара по шайбе
 private var angle_rot:int; //--угол поворота
 private var step_move:int; //--шаг при движении
 
 public var max_z:int; //--предел по z при движении
 public var min_z:int;
 
 public var max_x:int; //--предел по x при движении для вратаря пока
 public var min_x:int; //--предел по x при движении
 private var prev_z:Number;//--предыдущая координата
 private var ready:Boolean=false;
 private var first_point:Object;
 private var katok_cont:Object;//--контейнер-владелец для man
 public var man_h:int;
 public var man_w:int;
 
 public  var mind:Object;//--ум игрока
 public var klushka:Object;//--то к чему прилипает шайба--
 
 private var vr:Number;//--for calc pos
 private var angle_shayba_more:int;//--дельта угла отставания-опережения поз.клюшки
 private var where_move:int=1;//---коеф.движения 1-up -1 down Нужен для определения размаха и куда же бить?
 private var target_point:Object;//---целевая точка для движения
 private var cmd_list:Array;//--стек команд на выполнение {cmd:cmd_type,time_lim:sek} time_lim=0 - сразу выполнять
 //public var  tl:TimelineLite;

public function Man(s_c:Object,f_point:Object,m_nomer:int,m_n_team:int) {
	
	//Debug.trace("Man: n_nomer="+m_nomer+" n_team="+m_n_team+" mmc="+mmc);
	mc=this;
	s_conf=s_c;
	scene=s_conf.scene;
	site_path=s_conf.site_path;
	//katok_cont=katok_sp;//--владелец men каток
	first_point=f_point;
	nomer      = m_nomer;
	team_nomer = m_n_team;
	name="man_"+team_nomer+"_"+nomer;
	
	initEvents();
	initVars(s_c);
	initMaterials();
	//initCodeModel();

 }
 private function initEvents():void {
  	addEventListener(Event.ENTER_FRAME,onEnterFrame);
 }
 private function initVars(s_c:Object):void {
		
		path_model="models/";
		model_name="man_"+team_nomer+".3ds";
		file_material="man_"+team_nomer+".png";
		file_model=site_path+path_model+model_name;
		file_material=site_path+path_model+file_material;
		first_x=1400;
		first_y=500;
		target_point=new Object();
		target_point.x=0;
		target_point.z=0;
		first_scale=1;
		first_rotation=90;
		angle_rot=5;
		step_move=1;
		cur_cmd=0;//---stop
		force=0;//--сила удара нулевая
		time_state=0;
		time_cmd_lim=0;
		angle_shayba_more=15;//--угол отставание-опережения шайбой клюшки для броска(up - or down) Чтобы понять куда идет бросок
		max_z=s_c.main.kt.ice_L-1;
		min_z=1;
		max_x=400;// ---s_c.main.kt.ice_W;
		man_h=int(s_conf.bort_H*1.0);//int(s_conf.ice_H*6);//int(s_conf.bort_H*2);//
		man_w=int(s_conf.bort_H*0.8);
		klushka=new Object();
		klushka.x=0;
		klushka.z=0;
		where_move=1;//---коеф.движения 1-up -1 down
		vr = Math.PI / 180;
		cmd_list=new Array();
 }
 public function initMaterials():void{	 
		//mat_file_name = new BitmapFileMaterial(file_material);
        //mat_file_name.addEventListener(MaterialEvent.LOAD_SUCCESS, showModel)
        if (team_nomer == 1) {
			materialArray = [Cast.material(new man_mat_1())];
		} 
		if (team_nomer == 2) {
			materialArray = [Cast.material(new man_mat_2())];			
		}
		material = materialArray[materialIndex];
		material.thickness = 1;
		material.smooth = true;
		loadModel();
		//Debug.trace("Man:initMaterials "+file_material);
		
 }
 private function initAI():void {
	 if (team_nomer == 2) {//--ai only for computer!
	 	if (nomer == 6) { //--computer
	 		mind = new AI_vratar(s_conf,this);
			
	 	} else {
			mind = new AI_man(s_conf,this); 
	 	}
		mind.stopThink();//--AI включает team!!!
	 }
	 
 }
 private function initCodeModel():void {
  /*
	 if (team_nomer == 1) {
		materialArray = [Cast.material(new man_mat_1())];
	} 
	if (team_nomer == 2) {
		materialArray = [Cast.material(new man_mat_2())];			
	}
	material = materialArray[materialIndex];	
	material.smooth = true;
	model = new ManMesh(null);
	MyF.setMaterialToAllMesh(model.meshes, materialArray[materialIndex]);
	//model.width = man_w;
	//model.height = man_h;
	onSuccess(null);
	*/
 }
 public function showModel(e:MaterialEvent):void {
		//Debug.trace("Man: showModel e.target.name="+e.target.name);
		material = mat_file_name;
		loadModel();
 }
 public function loadModel():void {		
		cur_state=STATE.LOAD_MODEL;//"loadmodel";
		// Plane
		//model = new Plane(new BitmapFileMaterial("assets/earth.jpg"), 256, 128,1,1);
		model = new Plane({material:material, width:man_w, height:man_h,segmentsW:1,segmentsH:1});
		///model = new Cube({width:man_w, height:man_h, depth:man_w*0.1, material:material});
		onSuccess(null);
		/*
		max3ds = new Max3DS();
		max3ds.scaling = first_scale;
		max3ds.centerMeshes = true;
		max3ds.material =material;// materialArray[materialIndex];	
		//Debug.trace("MAN loadModel, n="+nomer+" max3ds="+max3ds);
		loader = new Loader3D();
		loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
		loader.loadGeometry(file_model, max3ds);
		*/
		
 }
 private function addShadow():void {
	var distance:Number = man_h;  
    var base:Number = 0;
	var blur:int = 16; 
	var color:uint = 0xFF0000; 
    s_shadow = new SimpleShadow(model, color, blur, base, distance); 
	s_shadow.apply(s_conf.main.view.scene);
	s_shadow.positionPlane();
 }
 private function  calcShadowPos():void {
	//s_shadow.positionPlane();	
	/*
	s_shadow.plane.x=model.x;
	s_shadow.plane.y=model.y;
	s_shadow.plane.z=model.z;
	s_shadow.plane.rotationY=model.rotationY;
	*/
 }
 private function onSuccess(event:Loader3DEvent):void
	{  
		//model = loader.handle as ObjectContainer3D;			
		//model = loader.handle;
		model.addEventListener(MouseEvent3D.MOUSE_DOWN,doClick);
		model.bothsides = true;
		model.ownCanvas=true;
		model.pushfront=true;
		model.useHandCursor=true;
		model.x = first_point.x;
		model.y = first_point.y;//-man_h;
		model.z = first_point.z;
		//trace("Man nomer="+nomer+" first_point.limits.max_x="+first_point.limits.max_x);
		min_x   = first_point.limits.min_x;
		max_x   = first_point.limits.max_x;
		min_z   = first_point.limits.min_z;
		max_z   = first_point.limits.max_z;
		
		prev_z=model.z;
		
		calcKlushkaPos(model.rotationY);
		
		model.scaleX=model.scaleY=model.scaleZ=first_scale;
		model.rotationX=first_rotation;
		
		ready=true;		
		//var g:ObjectContainer3D=scene.getChildByName('group');
		//g.addChild(model);
		s_conf.scene.addChild(model);
		//addShadow();
		initAI();
		//scene.getChildByName('group').addChild(model);
		//scene['group'].addChild(model);
		cur_state=STATE.LOADED;//"loaded";
		time_state=0;
		//Debug.trace("MAN onSuccess !!!(out) n:"+nomer+" model x="+model.x+" y="+model.y+" z="+model.z+" scaling="+model.scaleX+" objectWidth="+model.objectWidth+" objectHeight="+model.objectHeight+" objectDepth="+model.objectDepth);
 }
 private function calcKlushkaPos(a:int):void {
 	var angle:int=a;
	var betta:Number;//--angel 
	var x_0:Number=model.x;
	var y_0:Number=model.z;
	var x_i:Number;// -- point on circle
	var y_i:Number;// -- point on circle
	var r:Number=man_w/2;
	var k1:int;
	var k2:int;
	//---AX  -Y = -model.z !!!!!! Z на нас.Расчет с учетом этого!
	
	if ((a < 0 ) && (a > -360)) { angle = 360 + a; }
	if ((angle >= 0)&&(angle <=90)) 
			{
				betta = vr * angle;//--в радианы---
				k1  = (r * Math.cos(betta));
				k2  = (r * Math.sin(betta));
				x_i = x_0 + k1;
				y_i = y_0 - k2;
				//t_trace("1)0-90 angle=" + angle +" k1="+k1+" k2="+k2);				
				klushka.x=x_i;
				klushka.z=y_i;
				//trace("1) calcKlushkaPos rotationY="+model.rotationY+" a="+a+" angle="+angle+" r="+r+" k1="+k1+" k2="+k2+" klushka.x="+klushka.x+" man.x="+model.x+" klushka.z="+klushka.z+" man.z="+model.z);
				return;
			}
	if ((angle > 90)&&(angle <=180)) 
			{
				betta = angle-90;
				betta = vr * betta;//--в радианы---
				k1  = (r * Math.sin(betta));
				k2  = (r * Math.cos(betta));
				x_i = x_0 - k1;
				y_i = y_0 - k2;
				 klushka.x=x_i;
				 klushka.z=y_i;
				 //trace("2) calcKlushkaPos model.rotationY="+model.rotationY+"a="+a+" angle="+angle+" r="+r+" k1="+k1+" k2="+k2+" klushka.x="+klushka.x+" man.x="+model.x+" klushka.z="+klushka.z+" man.z="+model.z);
				return;
			}
	if ((angle > 180)&&(angle <= 270)) //--3
			{				
				betta = 270-angle;
				//betta = angle-180;
				
				betta = vr*betta;//--в радианы---
				k1  = (r * Math.sin(betta));
				k2  = (r * Math.cos(betta));
				x_i = x_0 - k1;
				y_i = y_0 + k2;
				 //t_trace("180-270 an=" + angle +" k1="+k1+" k2="+k2+"b="+betta+"M="+Math.sin(betta));
				 klushka.x=x_i;
				 klushka.z=y_i;
				//trace("3) calcKlushkaPos model.rotationY="+model.rotationY+" a="+a+" angle="+angle+" r="+r+" k1="+k1+" k2="+k2+" klushka.x="+klushka.x+" man.x="+model.x+" klushka.z="+klushka.z+" man.z="+model.z);
				return;
			}
	if ((angle > 270)&&(angle <= 360)) //-4
			{
				betta = 360 - angle;
				betta = vr * betta;//--в радианы---
				k1  = (r * Math.cos(betta));
				k2  = (r * Math.sin(betta));
				x_i = x_0 + k1;
				y_i = y_0 + k2;
			     //t_trace("4)270-360 angle=" + angle +" k1="+k1+" k2="+k2);
				 klushka.x=x_i;
				 klushka.z=y_i;
				//trace("4) calcKlushkaPos model.rotationY="+model.rotationY+" a="+a+" angle="+angle+" r="+r+" k1="+k1+" k2="+k2+" klushka.x="+klushka.x+" man.x="+model.x+" klushka.z="+klushka.z+" man.z="+model.z);
				return;
			}
	
 }
 private function calcTimeState():void {
	 time_state=time_state+(1/s_conf.stage.frameRate); 
 }
 private function execCmd():void {
	 cur_cmd      = cmd_list[0].cmd;
	 time_cmd_lim = cmd_list[0].time_cmd_lim;
	 //cur_state=cur_cmd;
	 //if (time_cmd_lim != null) {
	  if (time_cmd_lim !=0 ) {//--для тех у которых выставлен предел времени выполнения
		 time_cmd=time_cmd+(1/s_conf.stage.frameRate);		
		 if (time_cmd <= time_cmd_lim )  {//--пока есть что выполнять и в пределах выполнения
			  cur_state=cur_cmd;
		 } else {//--удаляем отработаную команду		    
			  cmd_list.shift();
			  time_cmd=0;
			  cur_state=prev_state;
		 }
	  //}
	 }
 }
 public function command(cmd:uint,p:Object=null):void {

	 //trace("Man cmd ="+cmd+" team_nomer="+team_nomer+" nomer="+nomer);
     if (cmd == CMD.SHOOT)       {shoot(p);return;}
	 if (cmd == CMD.SHOOT_TO_POINT){shootToPoint(p);return;}
	 if (cmd == CMD.SHOOT_TO_GOAL) {shootToPoint(p);return;}
	 if (cmd == CMD.MOVE_TO_POINT) {moveToPoint(p);return;}
	 if (cmd == CMD.MOVE_POINT)   {prev_z=model.z;movePoint(p);return;}
	 if (cmd == CMD.MOVE_UP)      {moveUp(p);return;}
	 if (cmd == CMD.MOVE_DOWN)    {moveDown(p);return;}
     if (cmd == CMD.MOVE_LEFT)    {moveLeft(p);return;}
	 if (cmd == CMD.MOVE_LEFT_LIMIT)    {moveLeftLimit(p);return;}
     if (cmd == CMD.MOVE_RIGHT)   {moveRight(p);return;}
	 if (cmd == CMD.MOVE_RIGHT_LIMIT)   {moveRightLimit(p);return;}
	 if (cmd == CMD.MOVE_STOP)    {moveStop(p);return;}
	 if (cmd == CMD.ROTATE_LEFT)  {rotateLeft(p);return;}
	 if (cmd == CMD.ROTATE_RIGHT) {rotateRight(p);return;}
     if (cmd == CMD.MOVE_POS)     {movePos(p);return;}
     if (cmd == CMD.ROTATE_Y)     {rotateY(p);return;}
     if (cmd == CMD.SHOW_ACTIVE)  {showActive(p);return;}
	
 }
 private function showActive(p:Object):void {
	 var colorActive:Number=0x000;//0xFFFF00--желтый 0-черный FF0000-красный 888888 -серый
	 if (nomer == p.nomer) {
		  if (p.active == true) {
			  s_conf.main.team_1.active_nomer=nomer;
			  var glow:GlowFilter = new GlowFilter(colorActive,0.9,20,20,1,1);
			  //var glow:GlowFilter = new GlowFilter(0);
			  // color,alpha,blurX,blurY,strength,quality,inner,knockout
			  //var filters:Array = [new DropShadowFilter(0, 0, 0, 1, 16, 16, 0.5, 2)];
			  var filters:Array = [glow];
			  model.filters = filters;
			  //trace("MAN "+nomer+" SET FILTER "+ model.filters);

		  } else {
			 model.filters = null;
			 //s_conf.main.team_1.active_nomer=0;
		  }
	 }
 }
 private function moveToPoint(p:Object):void {
	 target_point=p;
	 //cur_state=STATE.MOVE_TO_POINT;//"move_to_point";
	 time_state=0;
	 cmd_list.push({cmd:STATE.MOVE_TO_POINT,time_cmd_lim:(p.time_cmd_lim != null)?p.time_cmd_lim:0 });
	 
 }
 private function movePoint(p:Object):void {
	var angle:int;
	if (nomer == 6) { //--vratar--
		 model.x=p.x; //---вратарь перемещается по x
		 if (p.x >= max_x) { model.x=max_x;}
		 if (p.x <= min_x) { model.x = min_x; }
		 if (p.z >= max_z) { model.z=max_z;}
		 if (p.z <= min_z) { model.z=min_z;}
		 calcKlushkaPos(model.rotationY);
	 } else {
	    
		 model.z=p.z;
		
		 if (p.z >= max_z) { model.z=max_z;}
		 if (p.z <= min_z) { model.z=min_z;}
		 //trace("Man movePoint model.z="+model.z+" prev_z="+prev_z+" where_move="+where_move);
		 if (model.z >prev_z) {//---move DOWN : shayba k nam
			 angle=model.rotationY+getSideShayba("down");
			 where_move=-1;
		 }else {//---move UP :shayba ot nas
		  	 angle=model.rotationY+getSideShayba("up");
			 where_move=1;
		 }
		
		 calcKlushkaPos(angle);
		 s_conf.main.shayba.checkNearMan();//--если рядом шайба то прилепить ее
		 calcShadowPos();
	 }
 }
 private function rotateY(p:Object):void {
	 if (p.time_cmd_lim !=null) {
		  prev_state=STATE.STOP;//cur_state;
		  //trace("MAN CMD rotateY time_cmd_lim="+time_cmd_lim);
		  cmd_list.push({cmd:CMD.ROTATE_Y,time_cmd_lim:(p.time_cmd_lim != null)?p.time_cmd_lim:0 });
	 } else {
	 	if (nomer == 6) { //--vratar--
			 model.rotationY=model.rotationY+p.angle; //---вратарь вращатся должен с ограничениями 
	 	} else {		 
			 if ((model.rotationY >= 360)||(model.rotationY <= -360))  {model.rotationY=0;}
		 	model.rotationY=model.rotationY+p.angle;
	 	}
	 	calcKlushkaPos(model.rotationY+getSideShayba("up"));
	 	calcShadowPos();
	}
 }
 private function movePos(p:Object):void {
	// cur_state="move_pos";
	//model.material.gotoAndStop(p.n);
 }
 private function getSideShayba(kuda:String):int {
	 var k:int=1;//--up
	 if ((kuda == null)||(kuda == "")) {
		 kuda = "up";
	 }
	 //---вычислить направления.Зависит от того куда движемся и какой угол поворота  у модели
	 var a:int=model.rotationY;
	 if ((a < 0 ) && (a > -360)) { a = 360 + a; }//---если отрицат поворот
	 if (kuda =="up") {
		 //where_move=k;
	 } else { //--наоборот
		 //where_move=-k;
	 }
	
	 if ((a >= 0)&&(a <= 90)) {
			 k=k*where_move;
	 }
	 if ((a > 90)&&(a <= 180)) {
			 k=-k*where_move;
	 }
	 if ((a > 180)&&(a <= 270)) {
			 k=-k*where_move;
	 }
	 if ((a > 270)&&(a < 360)) {
			 k=k*where_move;
	 }
	 
	 return k*angle_shayba_more;
 }
 private function getSwingKoef():int {//-- опред.коеф для размаха.Размах противоположен напр.движению
	 var a:int=model.rotationY;
	 if ((a < 0 ) && (a > -360)) { a = 360 + a; }//---если отрицат поворот
	 if ((a >= 0)&&(a <= 90)) {
			 return -where_move;
	 }
	 if ((a > 90)&&(a <= 180)) {
			 return where_move;
	 }
	 if ((a > 180)&&(a <= 270)) {
			 return where_move;
	 }
	 if ((a > 270)&&(a < 360)) {
			 return -where_move;
	 }
	 return 1;
 }
 private function calcShootAngle(p:Object):int {
	 var a:int=180;//---вычислить правильное направление в виде угла
	 var dx:int;//--дельта от игрока до точки
	 var dz:int;//--дельта от игрока до точки
	 if ((klushka.x > p.point.x) && (klushka.z < p.point.z)) { //--левая часть поля
		  dx=klushka.x-p.point.x;
		  dz=p.point.z-klushka.z;
		  dx=Math.abs(dx);
	      dz=Math.abs(dz);
	      a=(180*Math.atan(dz/dx))/Math.PI;
	      a=a+90;
	 }
	 if ((klushka.x > p.point.x) && (klushka.z > p.point.z)){
		  dx=klushka.x-p.point.x;
		  dz=klushka.z-p.point.z;
		  dx=Math.abs(dx);
	      dz=Math.abs(dz);
		  a=(180*Math.atan(dx/dz))/Math.PI;
	  }
	  if ((klushka.x < p.point.x) && (klushka.z < p.point.z)) { //--левая часть поля
		  dx=p.point.x-klushka.x;
		  dz=p.point.z-klushka.z;
		  dx=Math.abs(dx);
	      dz=Math.abs(dz);
	      a=(180*Math.atan(dz/dx))/Math.PI;
	      a=270-a;
	 }
	 if ((klushka.x < p.point.x) && (klushka.z > p.point.z)) { 
		  dx=p.point.x-klushka.x;
		  dz=klushka.z-p.point.z;
		  dx=Math.abs(dx);
	      dz=Math.abs(dz);
	      a=(180*Math.atan(dx/dz))/Math.PI;
	      a=-a;
	 }
	
      return a;
 }
 private function   movePhysicVratar():void {
	 if (nomer ==6) {
		 
	 }
 }
 public function shootToPoint(p:Object):void {
    var timeline:TimelineLite;
	try {
	  if (cur_state == STATE.SHOOT_TO_POINT) {return;}
	  if (p.force != null ) {force=p.force;}
	  prev_state=cur_state;
	  cur_state=STATE.SHOOT_TO_POINT;//"shoot_to_point";
	  var k_swing:int= getSwingKoef();
	  cur_rot=model.rotationY;
	  if (p.point != null) {//--точный выстрел в точку!!!
	         timeline = new TimelineLite();	
			 timeline.append( new TweenLite(model, 0.2, {rotationY:cur_rot+k_swing*30}) );
	         timeline.append( new TweenLite(model, 0.2, {rotationY:cur_rot-k_swing*30}) );
		     //trace("MAN shootToPoint point.x="+p.point.x+" point.z="+p.point.z);
			 s_conf.main.shayba.onShootToPoint(p);
	  } else { //---выстрел по углу---!!!
	  		var cur_rot:int;		 
	  		var a:int=calcShootAngle(p);	  
	  		model.rotationY=a+90;	  		
	  		//trace("shootToPoint from="+nomer+" a="+a+" whom="+p.whom+" nomer="+p.nomer);
	  		timeline = new TimelineLite({onComplete:shootEvent,onCompleteParams:[a]});	  		
	  		timeline.append( new TweenLite(model, 0.5, {rotationY:cur_rot+k_swing*30}) );
	        timeline.append( new TweenLite(model, 0.2, {rotationY:cur_rot-k_swing*30}) );
	  }
	} catch (e:Error) {
	}
     
 }

 private function shootEvent(a:int=0):void {
  	var objEvent:GameEvents=new GameEvents(GameEvents.SHOOT);//--angle=model.rotationY
	//trace("Man shootEvent a="+a);
	if ((a < 0 ) && (a > -360)) { a = Math.abs(a-360); }//---если отрицат поворот //--было a = 360 + a;
	if (a == 0) {
		var angle:int=int(model.rotationY);
	} else {
	    angle=a;//--computer shoot
	}
	angle=angle;
	if ((angle >= 0)&&(angle < 90)) { 
		if ((where_move >=1)) {//--up
			angle=angle;
		}else {				   //--down
			angle=270-angle;
		}		
	}
	if ((angle >= 90)&&(angle < 180)) { 
		if ((where_move >=1)) {//--up
			angle=angle-180;
		}else {
			angle=angle+180;
		}		
	}
	if ((angle >= 180)&&(angle < 270)) { 
		if ((where_move >=1)) {//--up
			angle=angle-180;
		}else {				   //--down
			angle=angle+180;
		}		
	}
	if ((angle >= 270)&&(angle < 360)) { 
		if ((where_move >=1)) {//--up
			angle=-(360-angle);
		}else {				   //--down
			angle=angle-180;
		}		
	}
	if (force == 0 ) {force=s_conf.main.cp_cell_control_mc.kick_mc.force_mc.force_cur;}
	objEvent.event_obj={team_nomer:team_nomer,nomer:nomer,angle:angle,force:force};//---k_force=s_conf.stage.forceSlider_mc.value
	dispatchEvent(objEvent);
	s_conf.main.shayba.onShoot(objEvent);
	//cur_state=STATE.SHOOT_DONE;//"shoot_done";
	cur_state=prev_state;
	//trace("MAN shootEvent team="+team_nomer+" nomer="+nomer+" a="+a+" angle="+angle+" model.rotationY="+model.rotationY+" where_move="+where_move+" prev_z="+prev_z+" model.z="+model.z);
 }
  public function shoot(p:Object=null):void {
	try {
	 if (cur_state == STATE.SHOOT) {return;}
	  if (s_conf.main.lg == 0) { return;}
	  var cur_rot:int;
	  cur_rot=model.rotationY;
	
	  //var a:int=calcShootAngle(p);
	  var a:int=0;
	  //model.rotationY=a+90;
	  
	  
	  //trace("shoot BEFOR TimelineLite");
	  var timeline:TimelineLite = new TimelineLite({onComplete:this.shootEvent});//,onCompleteParams:[a]
	  var k_swing:int = getSwingKoef();
	  // trace("shoot cur_rot="+cur_rot+" nomer="+nomer+" team="+team_nomer+" k_swing="+k_swing+" cur_rot="+cur_rot);
	  timeline.append( new TweenLite(model, 0.5, {rotationY:cur_rot+k_swing*30}) );
	  timeline.append( new TweenLite(model, 0.2, {rotationY:cur_rot-k_swing*30}) );
      prev_state=cur_state;
	  cur_state = STATE.SHOOT;

	  cmd_list.push( { cmd:STATE.SHOOT, time_cmd_lim:(p.time_cmd_lim != null)?p.time_cmd_lim:0 } );
	  	 shootEvent();
	} catch (e:Error) {
		throw new Error(e.message);
	}
	
 }
 private function moveUp(p:Object):void {
	 cur_state=STATE.MOVE_UP;//"move_up";
	 time_state=0;
	 cmd_list.push({cmd:STATE.MOVE_UP, time_cmd_lim:(p.time_cmd_lim != null)?p.time_cmd_lim:0 });
	 //trace("moveUp: cmd_list.length="+cmd_list.length);
 }
 private function moveDown(p:Object):void {
	 cur_state=STATE.MOVE_DOWN;//"move_down";
	 time_state=0;
	 cmd_list.push({cmd:STATE.MOVE_DOWN, time_cmd_lim:(p.time_cmd_lim != null)?p.time_cmd_lim:0});	 
	 //trace("moveDown: cmd_list.length="+cmd_list.length+" cur_state="+cur_state);
 }
 private function moveLeft(p:Object=null):void {
	 if (model.x < max_x) {//--предел проверить
	 	//cur_state=STATE.MOVE_LEFT;//"move_left";
	 	time_state=0;
		cmd_list.push({cmd:STATE.MOVE_LEFT,time_cmd_lim:(p.time_cmd_lim != null)?p.time_cmd_lim:0 });	 
	 }
 }
 private function moveRight(p:Object=null):void {
	 if (model.x > min_x) {//--предел проверить
	 	 //cur_state=STATE.MOVE_RIGHT;//"move_right";
	 	 time_state=0;
		 cmd_list.push({cmd:STATE.MOVE_RIGHT,time_cmd_lim:(p.time_cmd_lim != null)?p.time_cmd_lim:0 });	 
	 }
 }
 private function moveLeftLimit(p:Object):void {
	 if (model.x < max_x) {
	 	 //cur_state=STATE.MOVE_LEFT_LIMIT;//"move_left_limit";
	 	 time_state=0;
		 cmd_list.push({cmd:STATE.MOVE_LEFT_LIMIT,time_cmd_lim:(p.time_cmd_lim != null)?p.time_cmd_lim:0 });	 
	 }
 }
 private function moveRightLimit(p:Object):void {
	 if (model.x > min_x) {
	 	//cur_state=STATE.MOVE_RIGHT_LIMIT;//"move_right";
	 	time_state=0;
		cmd_list.push({cmd:STATE.MOVE_RIGHT_LIMIT,time_cmd_lim:(p.time_cmd_lim != null)?p.time_cmd_lim:0 });	 
	 }
 }
 private function moveStop(p:Object=null):void {
	  prev_state=cur_state;
	  cur_state=STATE.MOVE_STOP;//"move_stop";
	  time_state=0;
	  //cmd_list.push({cmd:STATE.MOVE_STOP,time_cmd_lim:(p.time_cmd_lim != null)?p.time_cmd_lim:0 });	 
	  cmd_list.length = 0;
 }
 private function rotateLeft(p:Object):void {
	 model.rotationY-=angle_rot;
     calcKlushkaPos(model.rotationY);
	 //trace("Man Angle=" + model.rotationY+" panAngle="+s_conf.main.view.camera.panAngle);
	 correctRotation();
 }
 private function rotateRight(p:Object):void {
	 model.rotationY+=angle_rot;
     calcKlushkaPos(model.rotationY);
	 //trace("Man Angle=" + model.rotationY+" panAngle="+s_conf.main.view.camera.panAngle);
	 correctRotation();
 }
 private function correctRotation():void {
 if ((model.rotationY >= 360)||(model.rotationY <= -360)) {
	 model.rotationY = 0;
 }
 }
 private function checkHit():Boolean {
 	 //---hit bort
	 //---hit other Man
	 //---hit vorota
	 return false;
 }
 private function setPosInPhyshics():void {//--отразить координаты нахождения в физической модели
	if ((nomer == 6)&&(team_nomer == 2))  {//---для вратаря компьютера--
		s_conf.main.ph_engine.vratar_2.px=model.x*5;//--5 это масштабный коеффициент
		//trace("VRATAR FROM PHYSHIK px="+s_conf.main.ph_engine.vratar_2.px+" py="+s_conf.main.ph_engine.vratar_2.px);
	}
	if ((nomer == 6)&&(team_nomer == 1))  {//---для вратаря компьютера--
		s_conf.main.ph_engine.vratar_1.px=model.x*5;//--5 это масштабный коеффициент
		//trace("VRATAR FROM PHYSHIK px="+s_conf.main.ph_engine.vratar_1.px+" py="+s_conf.main.ph_engine.vratar_1.px);
	}
 }
 private function checkLimit():Boolean {

	 if (nomer == 6) { //---проверяем пределы вратаря по Х
	     if ((model.x > min_x) && (model.x < max_x) ) {
		    //trace("checkLimit 6 model.x="+model.x);
			return true;
		 } else {
			 //trace("!!!checkLimit!!!6 OUT "+model.x+"min_x="+min_x+" max_x="+max_x);
			   if (model.x > max_x) {
			   		model.x = max_x;
			   }
			   if (model.x < min_x) {
			   		model.x = min_x;
			   }
			 return false;
		 }
	 } else {         //-- пределы по Z допустимые
		 if ((model.z > min_z) && (model.z < max_z)) {
 			 
			 return true;
		 } else {
			   //trace("!!!checkLimit!!! OUT "+model.z);
			   //--- SET TO LIMIT---
			   if (model.z > max_z) {
			   		model.z = max_z;
			   }
			   if (model.z < min_z) {
			   		model.z = min_z;
			   }
			 return false;
		 }
	 }

 }
 private function checkCameraView():void {
  if (s_conf.main.cur_state == STATE.FLY_OVER) { return;}
  var dAngle:Number;
  var CameraAngle:Number;
  CameraAngle = s_conf.main.view.camera.panAngle;
  if ((s_conf.main.view.camera.panAngle >= 360) || (s_conf.main.view.camera.panAngle < 0)) {
    CameraAngle = Math.abs(s_conf.main.view.camera.panAngle - 360);
  }
  dAngle = Math.abs(CameraAngle - model.rotationY);
  if ((dAngle >= 88)&&(dAngle <= 92)) {
	 if (model.rotationY >= 0) {
		model.rotationY = model.rotationY+10;
	 } else {
	    model.rotationY = model.rotationY-10;
	}
	//trace("panAngle="+s_conf.main.view.camera.panAngle+" dAngle="+dAngle+" model.rotationY="+model.rotationY);
  }
 }
 private function doClick(e:MouseEvent3D):void {
     //Debug.trace("CLICK Man nomer:"+nomer+" model x="+model.x+" y="+model.y+" z="+model.z+" min_z="+min_z+" max_z="+max_z+" min_x="+min_x+" max_x="+max_x+" rotationY="+model.rotationY);
     //trace("CLICK Man nomer:"+nomer+" model x="+model.x+" y="+model.y+" z="+model.z+" min_z="+min_z+" max_z="+max_z+" min_x="+min_x+" max_x="+max_x+" rotationY="+model.rotationY+"panAngle="+s_conf.main.view.camera.panAngle);
	 //cur_state=STATE.MOVE_STOP;//"move_stop";
	 //time_state=0;
	 //model.pushfront=true;
	 //model.bothsides = false;
	 //model.pushback = true;
	 //model.pushfront = false;
	 //(model as Object3D).updateObject();
	 //model.updateObject();
	 //this.model.updateObject();// updateBounds();
	 command(CMD.SHOOT,{});
 }
public function onManControl(e:CPEvents):void {
			//trace("onManControl e.target.name"+e.target.name);
			//if (selected) {
			switch (e.target.name) {
				case "up_btn" :
					break;
				case "up_many_btn" :
					break;
				case "down_btn" :
					break;
				case "down_many_btn" :
					break;
				case "left_btn" :
					break;
				case "right_btn" :
					break;

					//}
			}
		}
 private function onEnterFrame(e:Event):void {
	checkCameraView();
	var cmd_list_len:uint=cmd_list.length;
	if (cmd_list_len <= 0){
		return;
	} else {
		execCmd();
	}
	var res_lim:Boolean;
	if (cur_state==STATE.LOADED) {
		  //model.rotationY+=2;
		 calcTimeState();
	 }
	 if (cur_state==STATE.MOVE_UP) {
		 //trace("cur_state=STATE.MOVE_UP");
		 calcTimeState();
		 prev_z=model.z;
		 model.z-=step_move;
		 where_move=1;
		 calcShadowPos();
		 //res_lim=checkLimit(); 
		 if (checkLimit() == false) {
			 cur_state=STATE.MOVE_DOWN;
			 time_state=0;
			
		 }
	   calcKlushkaPos(model.rotationY+getSideShayba("up"));
	 }
	 if (cur_state==STATE.MOVE_DOWN) {
		  calcTimeState();
		  prev_z=model.z;
		  model.z+=step_move;
		  where_move=-1;
		  calcShadowPos();
		  //res_lim=checkLimit(); 		 
		  if (checkLimit() == false) {
			 cur_state=STATE.MOVE_UP;
			 time_state=0;
		  }
		  calcKlushkaPos(model.rotationY+getSideShayba("down"));
	 }
	 if (cur_state==STATE.MOVE_LEFT) {
		 
		  calcTimeState();
		  model.x+=step_move;
		  //res_lim=checkLimit();
		  setPosInPhyshics();
		  calcShadowPos();
		  if (checkLimit() == false) {
			 cur_state=STATE.MOVE_RIGHT;
			 time_state=0;
		 }
		  calcKlushkaPos(model.rotationY);
	 }
	 if (cur_state==STATE.MOVE_LEFT_LIMIT) {
		  
		  calcTimeState();
		  model.x+=step_move;
		  //res_lim=checkLimit();
		  setPosInPhyshics();
		  calcShadowPos();
		  if (checkLimit() == false) {
			 cur_state=STATE.STOP;
			 time_state=0;
		 }
		  calcKlushkaPos(model.rotationY);
	 }
	 if (cur_state==STATE.MOVE_RIGHT) {
		  
		  calcTimeState();
		  model.x-=step_move;
		  //res_lim=checkLimit();
		  setPosInPhyshics();
		  calcShadowPos();
		  if (checkLimit() == false) {
			 cur_state=STATE.MOVE_LEFT;
			 time_state=0;
		 }
		  calcKlushkaPos(model.rotationY);
	 }
	if (cur_state==STATE.MOVE_RIGHT_LIMIT) {
		
		  calcTimeState();
		  model.x-=step_move;
		  //res_lim=checkLimit();
		  setPosInPhyshics();
		  calcShadowPos();
		  if (checkLimit() == false) {
			 cur_state=STATE.STOP;
			 time_state=0;
		  }
		  calcKlushkaPos(model.rotationY);
	 }
	 if (cur_state==STATE.MOVE_TO_POINT) {
		  calcTimeState();
		  if (model.z > target_point.z) {
		  	  model.z=model.z-step_move;
			  if (model.z <= target_point.z) {//-достигли точку
				 cur_state=STATE.STOP;
			     time_state=0;  
			  }
		  } else {
			  model.z=model.z+step_move;
			  if (model.z >= target_point.z) {//-достигли точку
				 cur_state=STATE.STOP;
			     time_state=0;  
			  }
		  }
		  if (checkLimit() == false) {
			 cur_state=STATE.STOP;
			 time_state=0;
		  }
		  calcKlushkaPos(model.rotationY);
		  calcShadowPos();
	 }
	 if (cur_state == STATE.ROTATE_Y) {
		  calcTimeState();
		  model.rotationY = model.rotationY + 5;
		  correctRotation();
		  calcKlushkaPos(model.rotationY);
	
		 
	 }
 }
}
}