package com.gestureworks.cml.element
{
	import com.gestureworks.cml.events.*;
	import com.gestureworks.cml.factories.*;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;	
	import com.gestureworks.events.GWGestureEvent;	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.html.HTMLLoader;
	import flash.html.HTMLPDFCapability;
	import flash.net.URLRequest;	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Timer;
	
	/**
	 * The HTML loads and runs an HTMLLoader display object.
	 * By default Flash is hidden from the web pages after loading via javascript to prevent display bugs native to the HTMLLoader
	 * 
	 * <codeblock xml:space="preserve" class="+ topic/pre pr-d/codeblock ">
	 * 			
		
			var htmlViewer:HTMLViewer = new HTMLViewer();
			
	 

	 * </codeblock>
	 * @author Ideum/cyancdesign
	 */
	
	public class HTML extends ElementFactory
	{
		
		private var _html:HTMLLoader;
		private var _bkg:Sprite;
		
		private var _url:String = "";
		private var _loadURL:String;
		private var _prevURL:String;
		private var _urlReq:URLRequest;
		
		public var _verticalScroll:ScrollBar;
		public var _horizontalScroll:ScrollBar;
		
		private var oldY:Number;
		private var oldX:Number;
		
		public var _content:*;
		
		private var loaded:Boolean = false;
		
		private var tmpImage:BitmapData;
		private var rawSmoothCap:Bitmap;
		private var smoothCap:Sprite;
		
		private var asset:*;
		private var __class:Class;
		
		private var smoothTimer:Timer;

		/**
		 * Constructor
		 */
		public function HTML()
		{
			super();
		}
		
		/**
		 * Getter for html object
		 */
		public function get html():HTMLLoader { return _html; }
		
		/**
		 * CML callbcak Initialisation
		 */
		override public function displayComplete():void {
			super.displayComplete();
			init();
		}

		
		/**
		 * Initialisation method
		 */
		public function init():void 
		{
			//super.init();
			
			_loadURL = _baseURL;
			if (_url != ""){
				_loadURL = _url;
			}
			
			_bkg = new Sprite();
			_bkg.graphics.beginFill(0x000000);
			_bkg.graphics.drawRect(0, 0, _width, _height);
			_bkg.graphics.endFill();
			addChild(_bkg);
			
			rawSmoothCap = new Bitmap();
			smoothCap = new Sprite();
			smoothCap.addChild(rawSmoothCap);
			addChild(smoothCap);
			
			_html = new HTMLLoader();
			_urlReq = new URLRequest(_loadURL);
			_html.width = _width;
			_html.height = _height;
			_html.addEventListener(Event.COMPLETE, onURLLoadComplete);
			_html.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onLocationChange);
			_html.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChanging );
			_html.load(_urlReq); 
			addChild(_html);
			
			_verticalScroll = new ScrollBar();	
			_verticalScroll.x = _html.width - 25;
			_verticalScroll.y = 0;
			_verticalScroll.fill = 0xFFFFFF;
			_verticalScroll.orientation = "vertical";
			_verticalScroll.contentHeight = 768;
			_verticalScroll.width = 25;
			_verticalScroll.height = _html.height;
			_verticalScroll.visible = false;
			_verticalScroll.addEventListener(StateEvent.CHANGE, onScroll);        
			_verticalScroll.init();
			addChild(_verticalScroll);
			
			_horizontalScroll = new ScrollBar();	
			_horizontalScroll.x = 0;
			_horizontalScroll.y = _html.height - 25;
			_horizontalScroll.fill = 0xFFFFFF;
			_horizontalScroll.orientation = "horizontal";
			_horizontalScroll.contentWidth = 1024;
			_horizontalScroll.height = 25;
			_horizontalScroll.width = _html.width;
			_horizontalScroll.visible = false;
			_horizontalScroll.addEventListener(StateEvent.CHANGE, onScroll); 
			_horizontalScroll.init();
			addChild(_horizontalScroll);
			
			if(_smooth){
				generateSmoothVersion();
				StartSmoothDisplay();
			}
				
		}
		
		private function StartSmoothDisplay():void
		{
			smoothTimer = new Timer(1000/30, 0);
			smoothTimer.addEventListener(TimerEvent.TIMER, UpdateSmootherTimer);
			smoothTimer.start();
		}
		private function UpdateSmootherTimer(e:TimerEvent):void {
			generateSmoothVersion();
		}
		
		/**
		 * hide flash
		 * Set to true if want to hide all Flash (object/embed)
		 * hideFlashType = "display: none;" or "visibility:hidden;"
		 */	
		private var _hideFlash:Boolean = true;
		public function get hideFlash():Boolean{ return _hideFlash;}
		public function set hideFlash(value:Boolean):void
		{
			_hideFlash = value;	
		}
		private var _hideFlashType:String = "visibility:hidden;";
		public function get hideFlashType():String{ return _hideFlashType;}
		public function set hideFlashType(value:String):void
		{
			_hideFlashType = value;	
		}
		/**
		 * Locks base url
		 * Set to true if you don't want users to be able to navigate awaw from http://www.xxxxxxx.xxx/
		 */	
		private var _smooth:Boolean = false;
		public function get smooth():Boolean{ return _smooth;}
		public function set smooth(value:Boolean):void
		{
			_smooth = value;	
		}
		
		/**
		 * Locks base url
		 * Set to true if you don't want users to be able to navigate awaw from http://www.xxxxxxx.xxx/
		 */	
		private var _lockBaseURL:Boolean = true;
		public function get lockBaseURL():Boolean{ return _lockBaseURL;}
		public function set lockBaseURL(value:Boolean):void
		{
			_lockBaseURL = value;	
		}
		
		/**
		 * Get/Set the base URL 
		 * Initial URL loaded
		 */	
		private var _baseURL:String = "http://";
		public function get baseURL():String{ return _baseURL;}
		public function set baseURL(value:String):void
		{
			_baseURL = value;	
		}
		
		/**
		 * Get/Set the HTML width
		 */	
		private var _width:Number = 1024;
		override public function get width():Number{ return _width;}
		override public function set width(value:Number):void
		{
			_width = value;
			super.width = value;	
		}
		
		/**
		 * Get/Set the HTML height
		 */	
		private var _height:Number = 768;
		override public function get height():Number{ return _height;}
		override public function set height(value:Number):void
		{
			_height = value;
			super.height = value;
		}
		/**
		 * Sets the generic URL and sends load request
		 */
		public function get url():String { return _url; }
		public function set url(value:String):void	{ 
			_url = value;
			if(loaded)
				loadURL(_url);
		}
		
		public function loadURL(URL:String = ""):void {
			if (URL == "")
				_loadURL = _prevURL;
			else
				_loadURL = URL;
			_urlReq = new URLRequest(_loadURL);
			_html.load(_urlReq);
		}
		
		/**
		 * navigation functions
		 */
		public function goBack():void { _html.historyBack(); }
		public function goForward():void { _html.historyForward(); }
		
		/**
		 * Scroll Bar Event
		 */
		private function onScroll(e:StateEvent):void {
			if (e.target == _verticalScroll) {				
				html.scrollV = ((html.contentHeight - html.height)) * e.value;
			} else if (e.target == _horizontalScroll) {
				html.scrollH = ((html.contentWidth - html.width)) * e.value;
			}
			if(_smooth)
				generateSmoothVersion();
			if (loaded) {
				if (_smooth)
					smoothCap.alpha = 1;
				if (!_smooth)
					_html.alpha = 1;			
			}else {
				if (_smooth)
					smoothCap.alpha = .5;
				if (!_smooth)
					_html.alpha = .5;		
			}
		}
		
		/**
		 * Dispose methods
		 */
		override public function dispose():void
		{
			super.dispose();
			if (_smooth)
				smoothTimer.removeEventListener(TimerEvent.TIMER, UpdateSmootherTimer);
			_html.removeEventListener(Event.COMPLETE, onURLLoadComplete);
			_html.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, onLocationChange);
			_html.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChanging );
			_verticalScroll.removeEventListener(StateEvent.CHANGE, onScroll);   
			_horizontalScroll.removeEventListener(StateEvent.CHANGE, onScroll);
			smoothCap.removeChild(rawSmoothCap);
			removeChild(smoothCap);  
			removeChild(_verticalScroll);
			removeChild(_horizontalScroll); 
			tmpImage = null;
			rawSmoothCap = null;
			smoothCap = null;
			_url = null;
			_html = null;
			_urlReq = null;
		}	
		

		/**
		 * HTMLLoader Events
		 */
		protected function onURLLoadComplete(event:*):void
		{	
			trace("URL Loaded: ", _loadURL);
			_verticalScroll.scrollPosition = 0;
			_horizontalScroll.scrollPosition = 0;
			_verticalScroll.thumbPosition = 0;
			_horizontalScroll.thumbPosition = 0;
			_prevURL = _loadURL;
			
			if (_html.contentWidth > _html.width) {
				_html.height = _height - _horizontalScroll.height;
				_horizontalScroll.visible = true;
				_horizontalScroll.resize(_html.contentWidth);
			}
			else{
				_horizontalScroll.visible = false;
				_html.height = _height;
			}			
			if (_html.contentHeight > _html.height) {
				_html.width = _width - _verticalScroll.width;
				_verticalScroll.visible = true;
				_verticalScroll.resize(_html.contentHeight);
			}
			else{
				_verticalScroll.visible = false;
				_html.width = _width;
			}
			
			loaded = true;
			if(_smooth){
				generateSmoothVersion();
				smoothCap.alpha = 1;
			}
			if (!_smooth)
				_html.alpha = 1;
				
			// hides flash
			if(_hideFlash){
				_html.window.document.location = "javascript:var css = document.createElement('style');css.type = 'text/css';css.innerHTML = 'embed, object { "+_hideFlashType+" }';document.body.appendChild(css);window.scrollTo(0,0)";
			}
		}
		protected function onURLLoadError(event:*):void
		{	
			//trace("URL Error");
		}
		protected function onLocationChanging(event:LocationChangeEvent):void
		{	
			//trace("Location Changing", event.location);
			if ( event.location.indexOf( _baseURL ) < 0 && _lockBaseURL && event.location.match("*.pdf")) 
            {
                event.preventDefault();
				return;
            }			
			if (_smooth)
				smoothCap.alpha = .5;
			if (!_smooth)
				_html.alpha = .5;
			loaded = false
		}
		protected function onLocationChange(event:LocationChangeEvent):void
		{	
			//trace("Location Change", event.location);
			if ( event.location.indexOf( _baseURL ) < 0 && _lockBaseURL && event.location.match("*.pdf") )
            {
                event.preventDefault();
				return;
            }
			if (_smooth)
				smoothCap.alpha = .5;
			if (!_smooth)
				_html.alpha = .5;
			loaded = false;
		}
		
		
		
		/**
		 * Smoothing Function
		 */
		public function generateSmoothVersion():void {	
						
			_html.alpha = 1;
			smoothCap.removeChild(rawSmoothCap);
			removeChild(smoothCap);
			tmpImage = new BitmapData(_html.width, _html.height, false, 0xFFFFFF);
			tmpImage.draw(_html, null, null, null, null, true);
			rawSmoothCap = new Bitmap(tmpImage);
			rawSmoothCap.smoothing = true;
			smoothCap = new Sprite();
			smoothCap.addChild(rawSmoothCap);
			_html.alpha = 0;
			addChild(smoothCap);
			setChildIndex(smoothCap, 0);
			setChildIndex(_bkg, 0);
		}
		
		
		
		private var _hideFrontOnFlip:Boolean = false;
		/**
		 * Specifies whether the front is hidden when the the back is shown
		 * @default false
		 */		
		public function get hideFrontOnFlip():* {return _hideFrontOnFlip}
		public function set hideFrontOnFlip(value:*):void 
		{	
			_hideFrontOnFlip = value;			
		}		
		
	}
}