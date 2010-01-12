package com.millermedeiros.text {
	
	/**
	 * Single line text field
	 * @author Miller Medeiros
	 */
	public class SingleLineTextField extends AbstractTextField {
		
		public function SingleLineTextField(size:int, color:uint, fontName:String) {
			super();
			_tf.size = size;
			_tf.color = color;
			_tf.font = fontName;
			this.multiline = false;
			this.wordWrap = false;
			this.selectable = false;
			this.defaultTextFormat = _tf;
		}
		
	}
	
}