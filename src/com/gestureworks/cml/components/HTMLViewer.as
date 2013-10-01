package com.gestureworks.cml.components 
{
	import com.gestureworks.cml.element.*;
	import com.gestureworks.cml.element.HTMLElement;
	import com.gestureworks.cml.events.*;
	import com.gestureworks.cml.kits.*;
	import com.gestureworks.events.GWGestureEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * The HTMLViewer used the HTMLElement to display a webpage/website on screen.
	 * 	
	 * <p>It is composed of the following: 
	 * <ul>
	 * 	<li>image</li>
	 * 	<li>front</li>
	 * 	<li>back</li>
	 * 	<li>menu</li>
	 * 	<li>frame</li>
	 * 	<li>background</li>
	 * </ul></p>
	 * <p>The width and height of the component are automatically set to the dimensions of the HTML element unless it is 
	 * previously specifed by the component.</p>
	 * 
	 * <codeblock xml:space="preserve" class="+ topic/pre pr-d/codeblock ">
	  

			
	 * </codeblock>
	 * 
	 * @author Ideum/cyancdesign
	 * @see Component
	 * @see com.gestureworks.cml.element.Image
	 * @see com.gestureworks.cml.element.TouchContainer
	 */	
	
	public class HTMLViewer extends Component
	{
		private var backBtnTxt:Text;
		private var backBtn:Button;
		private var forwardBtnTxt:Text;
		private var forwardBtn:Button;
				
		public function HTMLViewer() 
		{
			super();
			mouseChildren = true;
			disableNativeTransform = false;
			disableAffineTransform = false;
		}
		
		private var _html:*;
		/**
		 * Sets the video element.
		 * This can be set using a simple CSS selector (id or class) or directly to a display object.
		 * Regardless of how this set, a corresponding display object is always returned. 
		 */		
		public function get html():* {return _html}
		public function set html(value:*):void 
		{
			if (!value) return;
			
			if (value is DisplayObject)
				_html = value;
			else 
				_html = searchChildren(value);		
		}
		
		/**
		 * Initialization function
		 */
		override public function init():void 
		{	
			// automatically try to find elements based on css class - this is the v2.0-v2.1 implementation
			if (!html)
				html = searchChildren(".html_element");
			if (!menu)
				menu = searchChildren(".menu_container");
			if (!frame)
				frame = searchChildren(".frame_element");
			if (!front)
				front = searchChildren(".image_container");
			if (!back) {
				back = searchChildren(".info_container");
			}
			if (!background)
				background = searchChildren(".info_bg");		
			
			// automatically try to find elements based on AS3 class
			if (!html)
				html = searchChildren(HTML);
			
			if (html)
				html.addEventListener(StateEvent.CHANGE, onLoadComplete);
				
			super.init();
		}
		
		private function onLoadComplete(e:StateEvent):void
		{
			if (e.property == "isLoaded") {
				html.removeEventListener(StateEvent.CHANGE, onLoadComplete);
				isLoaded = true;
				dispatchEvent(new StateEvent(StateEvent.CHANGE, id, "isLoaded", isLoaded));
			}
		}
		
		public var isLoaded:Boolean = true;
		
		/**
		 * CML initialization
		 */
		override public function displayComplete():void
		{
			init();
		}
		
		override protected function updateLayout(event:*=null):void 
		{
			if (html) {
				width = html.width;
				height = html.height;	
			}	
			super.updateLayout();				
		}	
		
		
		
		/**
		 * Dispose method to nullify the attributes and remove listener
		 */
		override public function dispose():void 
		{
			super.dispose();
			html = null;
		}
		
		
	}

}