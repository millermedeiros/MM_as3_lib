/**
 * SVGArc v0.1 (2009/10/28)
 * Copyright (c) 2009 Miller Medeiros <http://www.millermedeiros.com/>
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 */
package com.millermedeiros.geom {
	
	import com.millermedeiros.utils.GeomUtils;
	import flash.geom.Point;
	
	//TODO: fix implementation following w3.org doc
	
	/**
	 * SVGArc Implementation following: http://www.w3.org/TR/SVG/implnote.html#ArcImplementationNotes
	 * @author Miller Medeiros (http://www.millermedeiros.com/)
	 */
	public class SVGArc extends Arc {
		
		/**
		 * Create a new SVG Elliptical Arc object
		 * - Conversion from endpoint to center parameterization following: http://www.w3.org/TR/SVG/implnote.html#ArcImplementationNotes
		 * @param	start	Start Point
		 * @param	end	End Point
		 * @param	rx	X radii of the ellipse
		 * @param	ry	Y radii of the ellipse
		 * @param	rotation Rotation angle of the ellipse (in degrees)
		 * @param	isLarge	Define if is a large arc (large-arc-flag)
		 * @param	isCounterClockwise	Define if arc should be draw clockwise (sweep-flag)
		 */
		public function SVGArc(start:Point, end:Point, rx:Number, ry:Number, rotation:Number = 0, isLarge:Boolean = false, isCounterClockwise:Boolean = false) {
			
			super();
			
			//trace("SVGArc: ", start, end, rx, ry, rotation, isLarge, isCounterClockwise);
			
			/*
			
			// ================== w3.org implementation ==================== //
			
			//midpoint
			var midX:Number = (start.x - end.x) / 2;
			var midY:Number = (start.y - end.y) / 2;
			
			//angle
			_rotation = rotation;
			var radRotation:Number = GeomUtils.degreeToRadians(rotation);
			var sinRotation:Number = Math.sin(radRotation);
			var cosRotation:Number = Math.cos(radRotation);
			
			//(x1', y1')
			var x1:Number = (cosRotation * midX + sinRotation * midY);
	        var y1:Number = (-sinRotation * midX + cosRotation * midY);
			
			// Correction of out-of-range radii
			if (rx == 0 || ry == 0) throw new Error("rx and rx can't be equal to zero !!"); // Ensure radii are non-zero
			_rx = Math.abs(rx);
			_ry = Math.abs(ry);
			var x1_2:Number = x1 * x1;
			var y1_2:Number = y1 * y1;
			var rx_2:Number = _rx * _rx;
			var ry_2:Number = _ry * _ry;
			var radiiFix:Number = (x1_2 / rx_2) + (y1_2 / ry_2);
			if(radiiFix > 1){
				_rx = Math.sqrt(radiiFix) * _rx;
				_ry = Math.sqrt(radiiFix) * _ry;
				rx_2 = _rx * _rx;
				ry_2 = _ry * _ry;
			}
			
			//(cX', cY')
			var sqr:Number = Math.sqrt(((rx_2 * ry_2) - (rx_2 * y1_2) - (ry_2 * x1_2)) / ((rx_2 * y1_2) + (ry_2 * x1_2)));
			sqr *= (isLarge != isCounterClockwise)? 1 : -1;
			var cx1:Number = sqr * ((_rx * y1) / _ry);
			var cy1:Number = sqr * -((_ry * x1) / _rx);
			
			//(cx, cy) from (cx', cy')
			_cx = (cosRotation * cx1 + -sinRotation * cy1) + midX;
			_cy = (sinRotation * cx1 + cosRotation * cy1) + midY;
			
			// angleStart and angleExtent
			var ux:Number = (x1 - cx1) / _rx;
	        var uy:Number = (y1 - cy1) / _ry;
	        var vx:Number = (-x1 - cx1) / _rx;
	        var vy:Number = (-y1 - cy1) / _ry;
			var uv:Number = ux*vx + uy*vy; // u.v
			var u:Number = Math.sqrt(ux*ux + uy*uy); // |u|
			var v:Number = Math.sqrt(vx*vx + vy*vy); // |v|
			_angleStart = GeomUtils.radianToDegree( Math.acos(ux / u) );
			_angleStart *= (uy < 0)? -1 : 1;
			_angleExtent = GeomUtils.radianToDegree( Math.acos(uv/(u*v)) );
			_angleExtent *= ((ux*vy - uy*vx) < 0)? -1 : 1;
			_angleExtent %= 360;
			if (!isCounterClockwise && _angleExtent > 0) _angleExtent -= 360;
			else if (isCounterClockwise && _angleExtent < 0) _angleExtent += 360;
			*/
			
			
			// ================== Degrafa implementation ==================== //
			
			
			//----- data translation
			
			var rx:Number = rx;
			var ry:Number = ry;
			var angle:Number = rotation;
			var largeArcFlag:Boolean = isLarge;
			var sweepFlag:Boolean = isCounterClockwise;
			var x:Number = end.x;
			var y:Number = end.y;
			var LastPointX:Number = start.x;
			var LastPointY:Number = start.y;
			
			//---- init degrafa
			
			/**
			 * copied from com.degrafa.geometry.utilities.ArcUtils
			 * degrafa is released under MIT license
			 * Copyright (c) 2008 The Degrafa Team : http://www.Degrafa.com/team
			 */
			
			//store before we do anything with it	 
	        var xAxisRotation:Number = angle;	 
	        	        	        	
	        // Compute the half distance between the current and the final point
	        var dx2:Number = (LastPointX - x) / 2.0;
	        var dy2:Number = (LastPointY - y) / 2.0;
	        
	        // Convert angle from degrees to radians
	        //angle = GeometryUtils.degressToRadius(angle);
	        angle = GeomUtils.degreeToRadians(angle);
	        var cosAngle:Number = Math.cos(angle);
	        var sinAngle:Number = Math.sin(angle);
	
	        
	        //Compute (x1, y1)
	        var x1:Number = (cosAngle * dx2 + sinAngle * dy2);
	        var y1:Number = (-sinAngle * dx2 + cosAngle * dy2);
	        
	        // Ensure radii are large enough
	        rx = Math.abs(rx);
	        ry = Math.abs(ry);
	        var Prx:Number = rx * rx;
	        var Pry:Number = ry * ry;
	        var Px1:Number = x1 * x1;
	        var Py1:Number = y1 * y1;
	        
	        // check that radii are large enough
	        var radiiCheck:Number = Px1/Prx + Py1/Pry;
	        if (radiiCheck > 1) {
	            rx = Math.sqrt(radiiCheck) * rx;
	            ry = Math.sqrt(radiiCheck) * ry;
	            Prx = rx * rx;
	            Pry = ry * ry;
	        }
	
	        
	        //Compute (cx1, cy1)
	        var sign:Number = (largeArcFlag == sweepFlag) ? -1 : 1;
	        var sq:Number = ((Prx*Pry)-(Prx*Py1)-(Pry*Px1)) / ((Prx*Py1)+(Pry*Px1));
	        sq = (sq < 0) ? 0 : sq;
	        var coef:Number = (sign * Math.sqrt(sq));
	        var cx1:Number = coef * ((rx * y1) / ry);
	        var cy1:Number = coef * -((ry * x1) / rx);
	
	        
	        //Compute (cx, cy) from (cx1, cy1)
	        var sx2:Number = (LastPointX + x) / 2.0;
	        var sy2:Number = (LastPointY + y) / 2.0;
	        var cx:Number = sx2 + (cosAngle * cx1 - sinAngle * cy1);
	        var cy:Number = sy2 + (sinAngle * cx1 + cosAngle * cy1);
	
	        
	        //Compute the angleStart (angle1) and the angleExtent (dangle)
	        var ux:Number = (x1 - cx1) / rx;
	        var uy:Number = (y1 - cy1) / ry;
	        var vx:Number = (-x1 - cx1) / rx;
	        var vy:Number = (-y1 - cy1) / ry;
	        var p:Number 
	        var n:Number
	        
	        //Compute the angle start
	        n = Math.sqrt((ux * ux) + (uy * uy));
	        p = ux;
	        
	        sign = (uy < 0) ? -1.0 : 1.0;
	        
	        //var angleStart:Number = GeometryUtils.radiusToDegress(sign * Math.acos(p / n));
	        var angleStart:Number = GeomUtils.radianToDegree(sign * Math.acos(p / n));
	
	        // Compute the angle extent
	        n = Math.sqrt((ux * ux + uy * uy) * (vx * vx + vy * vy));
	        p = ux * vx + uy * vy;
	        sign = (ux * vy - uy * vx < 0) ? -1.0 : 1.0;
	        //var angleExtent:Number = GeometryUtils.radiusToDegress(sign * Math.acos(p / n));
	        var angleExtent:Number = GeomUtils.radianToDegree(sign * Math.acos(p / n));
	        
	        if(!sweepFlag && angleExtent > 0) 
	        {
	            angleExtent -= 360;
	        } 
	        else if (sweepFlag && angleExtent < 0) 
	        {
	            angleExtent += 360;
	        }
	        
	        angleExtent %= 360;
	        angleStart %= 360;
			
			//return Object({x:LastPointX,y:LastPointY,startAngle:angleStart,arc:angleExtent,radius:rx,yRadius:ry,xAxisRotation:xAxisRotation});
			
			
			//----- end Degrafa
			
			_cx = cx;
			_cy = cy;
			_rx = rx;
			_ry = ry;
			_rotation = xAxisRotation;
			_angleStart = angleStart;
			_angleExtent = angleExtent;
		}
		
	}

}