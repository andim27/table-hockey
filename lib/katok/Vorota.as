package katok {

	import flash.display.*;
	import flash.events.Event;
	import flash.system.*;
	/*
	import away3dlite.loaders.Collada;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	import away3dlite.events.*;
	import away3dlite.loaders.*;
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.core.utils.*;
	*/
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
	import away3d.primitives.*;
	import utils.*;
	import away3d.exporters.*;
	
	import katok.VorotaMesh;

	public class Vorota extends Sprite {
		public var s_conf:Object;
 		public var cur_state:uint;
 		public var site_path:String;
		public var path_model:String;
		public var path_file:String;
		public var model_name:String;
		public var file_model:String;
 		public var file_material:String;
 		public var nomer:int =0;
		public var goal_net:Mesh;
		private var scene:Scene3D;
		private var max3ds:Max3DS;
		//material objects
		private var materialArray:Array;
		private var materialIndex:int=0;
		private var mat_file_name:BitmapFileMaterial;
		private var material:BitmapMaterial;

		private var loader:Loader3D;
		//public var model:Object3D;
		public var model:VorotaMesh;//Mesh
		private var first_x:int;
 		private var first_y:int;
		private var first_z:int;
 		private var first_scale:Number;
 		private var first_rotation:int;
		public  var vorota_W:int;//---ширина ворота
		public  var vorota_L:int;//---длина ворота

		public function Vorota(s_c:Object,v_nomer:int) {
			s_conf=s_c;
			scene=s_conf.scene;
			site_path=s_conf.site_path;
			nomer      = v_nomer;//--номер ворот--
			initVars();
			//initMaterials();
			initCodeModel();
		}
		private function initVars():void {
			cur_state=STATE.INIT;
			path_model="models/";
			//model_name="vorota25.3ds";
			//model_name="vorota.3ds";
			model_name="vorota_box.3ds";
			//file_material="vorota_net.png";
			file_material="vorota_uv_2.png";
			file_model=site_path+path_model+model_name;
			first_scale=1;
            //trace("Vorota init s_conf.main.kt.model.z="+s_conf.main.kt.model.z+" s_conf.ice_L="+s_conf.ice_L);
			if (nomer==1) {//--ближе к нам
				first_x=s_conf.main.kt.model.x+(s_conf.ice_W*0.5);
				first_y=s_conf.main.kt.model.y+1;//s_conf.ice_H*7;
				first_z=s_conf.main.kt.model.z+(s_conf.ice_L*(7.8/8));
				first_rotation=0;
			}
			if (nomer==2) {
				first_x=s_conf.main.kt.model.x+int(s_conf.ice_W*0.5);
				first_y=s_conf.main.kt.model.y+1;//s_conf.ice_H*7;
				first_z=s_conf.main.kt.model.z+(s_conf.ice_L*(1.2/8));
				first_rotation=180;//180;
			}

		}
		private function initCodeModel():void {
			
			materialArray = [Cast.material(new vorota_uv_2())];
			model= new VorotaMesh(null);
			MyF.setMaterialToAllMesh(model.meshes,materialArray[materialIndex]);
			
			var vorota_Mesh:Mesh = MyF.getMeshByName(model.meshes,"vorota");
			model.x=first_x;
			model.y=first_y;
			model.z=first_z;
			
			model.rotationY=first_rotation;
			model.scaleX=model.scaleY=model.scaleZ=first_scale;		
			model.ownCanvas = true;
			if (nomer==1) {
				//model.pushback = true;
			}
			if (nomer==2) {
				model.pushfront = true;
			}
			
			s_conf.scene.addChild(model);
			cur_state=STATE.LOADED;
			vorota_W = first_scale * (vorota_Mesh.maxX - vorota_Mesh.minX);
			vorota_L = first_scale * (vorota_Mesh.maxZ - vorota_Mesh.minZ);						
			//trace("Vorota("+nomer+") model x="+model.x+" y="+model.y+" z="+model.z+" vorota_W="+vorota_W+" vorota_L="+vorota_L);
			
		}
		private function initMaterials():void {
			//materialArray = [Cast.material(TextureModel)];//new BitmapFileMaterial("D:/Work/Flash/Hockey-1/models/ice_fon_texture.png");
			//material = new BitmapMaterial(Cast.bitmap(TextureModel));//Material_001 
			cur_state=STATE.LOAD_MATERIAL;
			var urlPath:String=site_path+path_model+file_material;
			mat_file_name=new BitmapFileMaterial(urlPath);
			mat_file_name.addEventListener(MaterialEvent.LOAD_SUCCESS, showModel);
			//Debug.trace("Vorota initMaterials "+urlPath);
			
		}
		public function showModel(e:MaterialEvent):void {
			material=mat_file_name;
			loadModel();
		}
		public function loadModel():void {
			cur_state=STATE.LOAD_MODEL;
			max3ds = new Max3DS();
			//max3ds.scaling=first_scale;
			max3ds.centerMeshes=true;
			//materialArray = [Cast.material(GreenPaint)];
			materialArray=[];
			max3ds.material=material;// materialArray[materialIndex];
			//Debug.trace("Vorota loadModel max3ds="+max3ds);
			loader = new Loader3D();
			loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			loader.loadGeometry(file_model, max3ds);
		}
		private function onSuccess(event:Loader3DEvent):void {
			//Debug.trace("Vorota onSuccess!!!!!!!!!");
			//model = loader.handle as ObjectContainer3D;
			//model=loader.handle;
			initEvents();
			//model.ownCanvas=true;
			
			model.x=first_x;
			model.y=first_y;
			model.z=first_z;
			
			model.rotationY=first_rotation;
			model.ownCanvas = true;
			if (nomer==1) {
				//model.pushback = true;
			}
			if (nomer==2) {
				model.pushfront = true;
			}
			
			//model.pushback = true;
			//model.bothsides=true;
			//model.bothsides=true;
			//model.geometryLibrary.vorota.ownCanvas = true;
			model.geometryLibrary.vorota.bothsides=true;
			s_conf.scene.addChild(model);
			model.scaleX=model.scaleY=model.scaleZ=first_scale;

			cur_state=STATE.LOADED;
			vorota_W = first_scale * (model.geometryLibrary.vorota.maxX - model.geometryLibrary.vorota.minX);
			vorota_L = first_scale * (model.geometryLibrary.vorota.maxZ - model.geometryLibrary.vorota.minZ);			
			//model.geometryLibrary.goal_net.materials[0]=new WireframeMaterial(0,{thickness:4});

			//Debug.trace("Vorota("+nomer+") model x="+model.x+" y="+model.y+" z="+model.z+" vorota_W="+vorota_W+" vorota_L="+vorota_L);
		}
		private function initEvents():void {
			model.addEventListener(MouseEvent3D.MOUSE_DOWN,doClick);
		}
		private function doClick(e:MouseEvent3D):void {
			//Debug.trace("CLICK Vorota nomer:"+nomer+" model x="+model.x+" y="+model.y+" z="+model.z+" scaleX="+model.scaleX);
			//----export---------
			var exporter:AS3Exporter = new AS3Exporter();
			//exporter.addEventListener(ExporterEvent.COMPLETE, _onExportComplete);
			exporter.export(model, 'VorotaMesh', 'katok');
		}
		protected function _onExportComplete(ev : ExporterEvent) : void
		{
			//trace('Vorota Export completed!');
			System.setClipboard(ev.data);
		}
	}
}