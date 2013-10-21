package katok {
	import flash.display.*;
	import flash.events.Event;
	import flash.system.*;
	
	import away3d.debug.*;
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.utils.*;
	import away3d.events.*;
	import away3d.loaders.*;
	import away3d.materials.*;
	import away3d.core.render.*;
	import away3d.loaders.*;
	import away3d.exporters.*;
	import away3d.primitives.*;
	
	import katok.KatokMesh;
	import events.*;
	import utils.*;
	
	public class Katok extends Sprite {	
		public var s_conf:Object;
		public var cur_state:uint;	
		public var path_model:String;
		public var path_file:String;
		public var model_name:String;
		public var file_model:String;
		public var file_material:String;
		public var pointTeam:Object;
		private var scene:Scene3D;
		private var collada:Collada;
		private var max3ds:Max3DS;
		//material objects
		private var materialArray:Array;
		private var materialIndex:int=0;
		private var mat_file_name:BitmapFileMaterial;
		private var material:BitmapMaterial;
		private var bort_mat:ColorMaterial;
		private var gate_mat:ColorMaterial;

		private var loader:Loader3D;

		//public var model:Object3D;
		//public var model:ObjectContainer3D;
		public var model:KatokMesh;
		public var Ice_Mesh:Mesh;
		public var bort_top_Mesh:Mesh;
		public var bort_bottom_Mesh:Mesh;
		public var bort_left_Mesh:Mesh;
		public var bort_right_Mesh:Mesh;
		public var st_b_right_Mesh:Mesh;
		public var st_b_left_Mesh:Mesh;
		public var st_t_right_Mesh:Mesh;
		public var st_t_left_Mesh:Mesh;
		public var bort_t_l_Mesh:Mesh;
		public var bort_t_r_Mesh:Mesh;
		public var bort_b_r_Mesh:Mesh;
		public var bort_b_l_Mesh:Mesh;
		
		public var center:Object3D;
		public var ice_W:int;
		public var ice_H:int;
		public var ice_L:int;
		public var bort_H:int;
		private var tween_param:Object;
		private var first_x:int;
		private var first_y:int;
		private var first_scale:int;
		private var first_rotation:int;		
		[Embed (source="D:/and_1/work/flash/flash_work/HK/bin/models/ice_fon_plus.png")]
		//[Embed(source='../main_1.swc', mimeType="application/octet-stream",symbol='ice_fon_plus')]	
		private var KatokTexture:Class;	
		
		public function Katok(s_c:Object) {
			cur_state=STATE.INIT;
			//camera=cam;			
			s_conf=s_c;
			scene=s_conf.scene;
			initEvents();
			initVars();
			
			//initMaterials();
			//initObjects();
			initCodeModel();
			name="katok";
			
			
			//Debug.trace("KATOK name="+name);
			//loadModel();
		}

		private function initVars():void {
			cur_state = STATE.INIT;
			path_model="models/";
			
			model_name="katok_5.3ds";//--GOOD
			file_material="ice_fon_plus.png";//-GOOD
			
			//model_name="katok_8.3ds";//--stoiki
			//file_material="katok_uv_1.png";//-stoiki
			
			file_model=s_conf.site_path+path_model+model_name;
			first_x=0;
			first_y=0;
			first_scale=2;//2
			first_rotation = 0;
			pointTeam=new Object();
			trace("Katok filemodel="+file_model);
		}
		private function initCodeModel():void {
			//model = new KatokModel(s_conf);			
			//trace("initCodeModel typeof model="+typeof(model));			
			//onSuccess(null);
			
			//---B---------------------added in Katok Mesh-----------
			// public var model:KatokMesh;
			// private var uv_mat:Object;//--my
		    // public function KatokMesh(init:Object = null,uv:Object = null)
		    // {
			// uv_mat=uv;
			//  ........
			// ...для мешей material:uv_mat
			// objs.obj0 = {name:"bort_right",  transform:m0, pivotPoint:new Number3D(-0.3426567614078522,-0.5340512990951538,30.98613154888153), container:0, bothsides:false, material:uv_mat, ownCanvas:false, pushfront:false, pushback:false};
			//---E---------------------added in Katok Mesh-----------
			
			materialArray = [Cast.material(new ice_fon_plus())];						
			//materialArray = [Cast.material(new KatokTexture())];	
			model= new KatokMesh(null);
			setMaterialToAllMesh(model.meshes,materialArray[materialIndex]);
			
			Ice_Mesh        = MyF.getMeshByName(model.meshes,"Ice");
			bort_top_Mesh   = MyF.getMeshByName(model.meshes,"bort_top");
			bort_bottom_Mesh= MyF.getMeshByName(model.meshes,"bort_bottom");
			bort_left_Mesh  = MyF.getMeshByName(model.meshes,"bort_left");
			bort_right_Mesh = MyF.getMeshByName(model.meshes,"bort_right");
			st_b_right_Mesh = MyF.getMeshByName(model.meshes,"St_b_right");
			st_b_left_Mesh  = MyF.getMeshByName(model.meshes,"St_b_left");
			st_t_right_Mesh = MyF.getMeshByName(model.meshes,"St_t_right");
			st_t_left_Mesh  = MyF.getMeshByName(model.meshes, "St_t_left");
			
			bort_t_l_Mesh   = MyF.getMeshByName(model.meshes,"bort_t_l");
			bort_t_r_Mesh   = MyF.getMeshByName(model.meshes,"bort_t_r");
			bort_b_r_Mesh   = MyF.getMeshByName(model.meshes,"bort_b_r");
			bort_b_l_Mesh   = MyF.getMeshByName(model.meshes,"bort_b_l");
			
			
			(Ice_Mesh.material as BitmapMaterial).smooth = true;
			
			bort_left_Mesh.ownCanvas=true;
			bort_right_Mesh.ownCanvas=true;
			st_b_right_Mesh.ownCanvas=true;
			st_b_left_Mesh.ownCanvas=true;
			st_t_right_Mesh.ownCanvas=true;
			st_t_left_Mesh.ownCanvas=true;
			
			st_b_right_Mesh.pushback=true;
			st_b_left_Mesh.pushback=true;
			st_t_right_Mesh.pushback=true;
			st_t_left_Mesh.pushback = true;
			
			bort_t_l_Mesh.ownCanvas=true; 
			bort_t_r_Mesh.ownCanvas=true; 
			bort_b_l_Mesh.ownCanvas=true; 
			bort_b_r_Mesh.ownCanvas = true;
						
			bort_t_l_Mesh.pushback=true;
			bort_t_r_Mesh.pushback=true;
			
			bort_left_Mesh.pushback=true;
			//bort_right_Mesh.pushback=true;
			bort_left_Mesh.pushfront=true;
			bort_right_Mesh.pushfront=true;
			
			Ice_Mesh.ownCanvas=true;
			Ice_Mesh.pushback = true;
		
			st_t_right_Mesh.visible=false;
			st_t_left_Mesh.visible=false;
			st_b_right_Mesh.visible=false;
			st_b_left_Mesh.visible=false;
			
			bort_top_Mesh.ownCanvas=true;
			bort_top_Mesh.pushback=true;
			
			bort_bottom_Mesh.ownCanvas=true;
			bort_bottom_Mesh.pushfront=true;
									
			model.x=first_x;
			model.y=first_y;
			
			model.scaleX=model.scaleY=model.scaleZ=first_scale;
			model.rotationX=first_rotation;
			model.addEventListener(MouseEvent3D.MOUSE_DOWN,doClick);
			pointTeam=new Object();
			pointTeam.x=model.x;
			pointTeam.y=model.y;
			pointTeam.z=model.z-(Ice_Mesh.maxZ/2);			
			
			ice_W  = first_scale * (Ice_Mesh.maxX-Ice_Mesh.minX);
			ice_L  = first_scale * (Ice_Mesh.maxZ-Ice_Mesh.minZ);
			ice_H  = first_scale * (Ice_Mesh.maxY-Ice_Mesh.minY);
			bort_H = first_scale * (bort_top_Mesh.maxY-bort_top_Mesh.minY);
			center = new Object3D( { x:model.x + ice_W / 2, y:model.y, z:model.z + ice_L / 2 } );

			cur_state=STATE.LOADED;//"loaded";
			s_conf.scene.addChild(model);

		
		}
		private function setMaterialToAllMesh(m:Array,mat:Material=null):void {
			var L:uint=m.length;
		    for (var i:uint=0; i < L; i++) {
				m[i].material=mat;
			}
		}
		private function getMeshByName(m:Array,nm:String=""):Mesh {//--my
		 var L:uint=m.length;
		 for (var i:uint=0; i < L; i++) 
		 	 if (m[i].name == nm) { return m[i];}
		 return null; 
		}
		public function initMaterials(m_n:String=""):void {
		var urlPath:String;
		try {	
			if (m_n != "") {
				urlPath = s_conf.main.where_addr + m_n;
			} else {
				urlPath = s_conf.site_path + path_model + file_material;
			}
			mat_file_name=new BitmapFileMaterial(urlPath);
			//materialArray = [Cast.material(new ice_fon_plus())];		//--KatokTexture			
			materialArray = [mat_file_name];
			setMaterialToAllMesh(model.meshes, materialArray[materialIndex]);			
		} catch (err:Error) {
		}
   		
		}
		private function initObjects():void
		{		
			max3ds = new Max3DS();
			max3ds.centerMeshes = true;
			max3ds.material = materialArray[materialIndex];			
			//trace("Katok initObjects max3ds.material = "+max3ds.material);
			loader = new Loader3D();
			loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);		
			loader.loadGeometry(file_model, max3ds);						
		
		}
		private function onSuccess(event:Loader3DEvent=null):void 
		{
			//model = loader.handle as ObjectContainer3D;//----for object load
			
			model.x=first_x;
			model.y=first_y;
			//trace("model="+model);
			model.scaleX=model.scaleY=model.scaleZ=first_scale;
			model.rotationX=first_rotation;
			model.addEventListener(MouseEvent3D.MOUSE_DOWN,doClick);
						
			s_conf.scene.addChild(model);

			pointTeam=new Object();
			pointTeam.x=model.x;
			pointTeam.y=model.y;
			pointTeam.z=model.z-(model.geometryLibrary.Ice.maxZ/2);
			//group.bothsides=true;
			
			//model.geometryLibrary.Ice.bothsides=true;
			
			//model.geometryLibrary.Ice .pushback = true;//ownCanvas=true;
			model.ownCanvas=true;
			model.pushback = true;
			//model.pushfront = true;
			//model.geometryLibrary.bort_bottom.bothsides=true;
			//model.geometryLibrary.bort_top.bothsides=true;
			//model.geometryLibrary.bort_top.pushback = true;
			//model.geometryLibrary.bort_bottom.pushback = true;
			/////trace("Katok geom: Ice.maxX="+model.geometryLibrary.Ice.maxX+" Ice.maxY="+model.geometryLibrary.Ice.maxY+" Ice.maxZ="+model.geometryLibrary.Ice.maxZ);
			//trace("Katok geom: Ice.minX="+model.geometryLibrary.Ice.minX+" Ice.minY="+model.geometryLibrary.Ice.minY+" Ice.minZ="+model.geometryLibrary.Ice.minZ);
			//trace("Katok bort_top: bort_top.minX="+model.geometryLibrary.bort_top.minX+" bort_top.minY="+model.geometryLibrary.bort_top.minY+" bort_top.minZ="+model.geometryLibrary.bort_top.minZ);
			//trace("Katok bort_top: bort_top.maxX="+model.geometryLibrary.bort_top.maxX+" bort_top.maxY="+model.geometryLibrary.bort_top.maxY+" bort_top.maxZ="+model.geometryLibrary.bort_top.maxZ);
			//trace("group.objectHeight ="+group.objectHeight +" group.objectWidth="+group.objectWidth+" group.objectDepth ="+group.objectDepth );
			//trace("model._maxX ="+model.geometryLibrary._maxX +" model._minX="+model.geometryLibrary._minX);
			ice_W = first_scale * (model.geometryLibrary.Ice.maxX - model.geometryLibrary.Ice.minX);
			ice_L = first_scale * (model.geometryLibrary.Ice.maxZ - model.geometryLibrary.Ice.minZ);
			ice_H = first_scale * (model.geometryLibrary.Ice.maxY - model.geometryLibrary.Ice.minY);
			bort_H =first_scale * (model.geometryLibrary.bort_top.maxY - model.geometryLibrary.bort_top.minY);
			center = new Object3D({x:model.x+ice_W/2,y:model.y,z:model.z+ice_L/2});
			//trace("KATOK ice_W="+ice_W+" ice_L="+ice_L+" bort_H="+bort_H);
			cur_state=STATE.LOADED;//"loaded";
		
		}
		public function getFirstPointKatok():Object {
			var pointKatok:Object=new Object();
			pointKatok.x=model.x;
			pointKatok.y=model.y;
			pointKatok.z=model.z;
			pointKatok.maxX=model.geometryLibrary.Ice.maxX;
			pointKatok.maxY=model.geometryLibrary.Ice.maxY;
			pointKatok.maxZ=model.geometryLibrary.Ice.maxZ;
			return pointKatok;
		}
 		private function doClick(e:MouseEvent3D):void {
        	//Debug.trace("CLICK Katok ice_W:"+ice_W+" ice_L="+ice_L+" ice_H="+ice_H);
			cur_state=STATE.STOP;//"stop";
				
			//----export---------
			//var exporter:AS3Exporter = new AS3Exporter();
			//exporter.addEventListener(ExporterEvent.COMPLETE, _onExportComplete);
			//exporter.export(model, 'KatokMesh', 'katok');
 		}
		protected function _onExportComplete(ev : ExporterEvent) : void
		{
			//trace('Katok Export completed!');
			System.setClipboard(ev.data);
		}
		private function initEvents():void  {
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}

		//--------------EVENTS-------------------------
		private function onKatokCamera(e:CPEvents):void  {
			//Debug.trace("KATOK onCamera!!!!");
		}
		private function onEnterFrame(e:Event):void  {

		}
	}
}