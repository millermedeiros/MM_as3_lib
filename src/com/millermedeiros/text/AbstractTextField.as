package com.millermedeiros.text {
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * Abstract Textfield class used for default Textfield configuration
	 * @author Miller Medeiros (www.millermedeiros.com)
	 */
	public class AbstractTextField extends TextField{
		
		protected var _tf:TextFormat;
		
		public function AbstractTextField() {
			
			if (getQualifiedSuperclassName(this).split("::")[1] == "Sprite") throw(new Error("This is an abstract class and should not be instantiated ."));
			
			this.multiline = true;
			this.wordWrap = true;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.background = false;
			this.embedFonts = true;
			this.selectable = true;
			this.mouseWheelEnabled = false;
			this.antiAliasType = AntiAliasType.ADVANCED;
			
			_tf = new TextFormat();
			
		}
		
	}
	
}