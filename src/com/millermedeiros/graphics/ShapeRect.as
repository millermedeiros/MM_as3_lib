package com.millermedeiros.graphics {
	
	import flash.display.Shape;
	
	/**
	 * Basic helper to create a rectangle shape
	 * @author Miller Medeiros
	 */
	public class ShapeRect extends Shape{
		
		/**
		 * Creates a basic rectangle shape
		 * @param	wid	rectangle Width
		 * @param	hei	Rectangle Height
		 * @param	color	Fill color
		 * @param	alpha	Shape alpha (obs: change the shape alpha and not the beginFill alpha - so you can change it later)
		 */
		public function ShapeRect(wid:Number, hei:Number, color:uint = 0xFFFFFF, alpha:Number = 1) {
			this.alpha = alpha;
			this.graphics.beginFill(color);
			this.graphics.drawRect(0, 0, wid, hei);
			this.graphics.endFill();
		}
		
	}
	
}