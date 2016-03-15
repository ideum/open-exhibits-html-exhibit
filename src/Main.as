package
{
	import com.gestureworks.cml.components.HTMLViewer;
	import com.gestureworks.cml.elements.Frame;
	import com.gestureworks.cml.elements.HTML;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.core.GestureWorksAIR;
	
	[SWF(width = "1280", height = "720", backgroundColor = "0x000000", frameRate = "30")]
	
	/**
	 * ...
	 * @author 
	 */
	public class Main extends GestureWorksAIR 
	{
		
		public function Main() 
		{
			gml = "gml/my_gestures.gml";
		}
		
		override protected function gestureworksInit():void {
			
			//Space Photo Background
			var htmlContainer:TouchContainer = new TouchContainer();
			htmlContainer.className = "html_container";
			htmlContainer.visible = true;
			htmlContainer.targetParent = true;
			htmlContainer.mouseChildren = false;
			htmlContainer.gestureEvents = false;
			htmlContainer.init();
			
			var htmlframe:Frame = new Frame();
			htmlframe.className = "frame_element";
			htmlframe.init();
			
			var htmlViewer:HTMLViewer = new HTMLViewer();
			htmlViewer.x = 0;
			htmlViewer.y = 0;
			htmlViewer.width = 1280;
			htmlViewer.height = 720;
			htmlViewer.gestureEvents = false;	
			htmlViewer.html = htmlElement;
			
			var htmlElement:HTML = new HTML();
			htmlElement.className = "html_element";
			htmlElement.width = 1280;
			htmlElement.height = 720;
			htmlElement.baseURL = "http://upload.wikimedia.org";
			htmlElement.src = "http://upload.wikimedia.org/wikipedia/commons/e/e9/Sombrero_Galaxy_in_infrared_light_(Hubble_Space_Telescope_and_Spitzer_Space_Telescope).jpg";
			htmlElement.lockBaseURL = false;
			htmlElement.hideFlash = true;
			htmlElement.smooth = true;
			htmlElement.hideFlashType = "display:none;";
			htmlElement.init();			
					
			htmlViewer.addChild(htmlElement);
			htmlViewer.addChild(htmlContainer);
			htmlViewer.childToList("html_container", htmlContainer);
			addChild(htmlViewer);			
			htmlViewer.init();	
			
			
			// NASA.gov Website Viewer
			var htmlNASAContainer:TouchContainer = new TouchContainer();
			htmlNASAContainer.className = "html_container";
			htmlNASAContainer.visible = true;
			htmlNASAContainer.targetParent = true;
			htmlNASAContainer.mouseChildren = false;
			htmlNASAContainer.gestureEvents = false;
			htmlNASAContainer.init();
			
			var htmlNASAframe:Frame = new Frame();
			htmlNASAframe.className = "frame_element";
			htmlNASAframe.init();
			
			var htmlNASAViewer:HTMLViewer = new HTMLViewer();
			htmlNASAViewer.x = 100;
			htmlNASAViewer.y = 50;
			htmlNASAViewer.scale = .5;
			htmlNASAViewer.rotation = 3;
			htmlNASAViewer.width = 1024;
			htmlNASAViewer.height = 768;
			htmlNASAViewer.gestureEvents = true;
			htmlNASAViewer.gestureList = { "n-drag":true, "n-scale":true, "n-rotate":true };	
			htmlNASAViewer.html = htmlNASAElement;
			
			var htmlNASAElement:HTML = new HTML();
			htmlNASAElement.className = "html_element";
			htmlNASAElement.width = 1024;
			htmlNASAElement.height = 768;
			htmlNASAElement.baseURL = "http://www.nsf.gov/";
			htmlNASAElement.src = "http://www.nsf.gov/";
			htmlNASAElement.lockBaseURL = false;
			htmlNASAElement.hideFlash = true;
			htmlNASAElement.smooth = true;
			htmlNASAElement.hideFlashType = "display:none;";
			htmlNASAElement.init();			
			
			htmlNASAContainer.addChild(htmlNASAframe);
			htmlNASAContainer.childToList("frame_element", htmlNASAframe);		
			htmlNASAViewer.addChild(htmlNASAElement);
			htmlNASAViewer.addChild(htmlNASAContainer);
			htmlNASAViewer.childToList("html_container", htmlNASAContainer);
			addChild(htmlNASAViewer);			
			htmlNASAViewer.init();		
			
			
			//NASA Twitter Website Viewer
			var htmlContainer:TouchContainer = new TouchContainer();
			htmlContainer.className = "html_container";
			htmlContainer.visible = true;
			htmlContainer.targetParent = true;
			htmlContainer.mouseChildren = false;
			htmlContainer.gestureEvents = false;
			htmlContainer.init();
			
			var htmlframe:Frame = new Frame();
			htmlframe.className = "frame_element";
			htmlframe.init();
			
			var htmlElement:HTML = new HTML();
			htmlElement.className = "html_element";
			htmlElement.width = 1024;
			htmlElement.height = 768;
			htmlElement.baseURL = "https://twitter.com/nsf/";
			htmlElement.src = "https://twitter.com/nsf/";
			htmlElement.lockBaseURL = false;
			htmlElement.hideFlash = true;
			htmlElement.smooth = true;
			htmlElement.hideFlashType = "display:none;";
			htmlElement.init();					
			
			var htmlViewer:HTMLViewer = new HTMLViewer();
			htmlViewer.x = 690;
			htmlViewer.y = 240;
			htmlViewer.scale = .5;
			htmlViewer.rotation = -2;
			htmlViewer.width = 1024;
			htmlViewer.height = 768;
			htmlViewer.gestureEvents = true;
			htmlViewer.gestureList = { "n-drag":true, "n-scale":true, "n-rotate":true };	
			htmlViewer.html = htmlElement;
			
			htmlContainer.addChild(htmlframe);
			htmlContainer.childToList("frame_element", htmlframe);		
			htmlViewer.addChild(htmlElement);
			htmlViewer.addChild(htmlContainer);
			htmlViewer.childToList("html_container", htmlContainer);
			addChild(htmlViewer);			
			htmlViewer.init();				
		}
		
	}
	
}