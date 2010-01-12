/**
 * com.millermedeiros.utils.Random
 * Copyright (c) 2009 Miller Medeiros <http://www.millermedeiros.com/>
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 */
package com.millermedeiros.utils {

	/**
	 * Class used to return a random number, boolean or array
	 * @author	Miller Medeiros (http://www.millermedeiros.com)
	 * @version	1.2 (2009/10/28)
	 */
	public class Random {
		
		
		/**
		 * Constructor (obs: static class and should not be instantiated)
		 */
		public function Random() {
			throw new Error("This class is static and should not be instantiated.");
		}
		
		
		/**
		* Return a random integer between 2 integers
		* - ex: Random.integer(-120, 80) returns all numbers between -120 and 80 (inclusive)
		* - ex2: Random.integer(-120, 80, false) returns -120 or 80
		* @param	min	Minimum possible value
		* @param	max	Maximum possible value
		* @param	between	If it should return all numbers between "max" and "min"
		* @return	random integer
		*/
		public static function integer(min:int = int.MIN_VALUE, max:int = int.MAX_VALUE, between:Boolean = true):int {
			var rndm:int;
			if (between) {
				rndm = int(Math.random() * (max - min + 1)) + min;
			}else {
				rndm = (Random.boolean())? min : max;
			}
			return rndm;
		}
		
		
		/**
		 * Return a ramdom unsigned integer (uint) between 2 unsigned integers
		 * - ex: Random.uInteger(7, 45) returns all numbers between 7 and 45 (inclusive)
		 * - ex2: Random.uInteger(7, 45, false) returns 7 or 45
		 * @param	min	Minimum possible value
		 * @param	max	Maximum possible value
		 * @param	between	If it should return all numbers between "max" and "min"
		 * @return	random unsigned integer
		 */
		public static function uInteger(min:uint = uint.MIN_VALUE, max:uint = uint.MAX_VALUE, between:Boolean = true):uint {
			var rndm:uint;
			if (between) {
				rndm = uint(Math.random() * (max - min + 1)) + min;
			}else {
				rndm = (Random.boolean())? min : max;
			}
			return rndm;
		}
		
		
		/**
		 * Return a random float number between 2 float numbers
		 * - ex: Random.float(0.5, 1.2) returns all numbers between 0.5 and 1.2 (inclusive)
		 * - ex2: Random.float(0.5, 1.2, false) returns 0.5 or 1.2
		 * @param	min	Minimum possible value
		 * @param	max	Maximum possible value
		 * @param	between	If it should return all numbers between "max" and "min"
		 * @return	random number
		 */
		public static function float(min:Number = Number.MIN_VALUE, max:Number = Number.MAX_VALUE, between:Boolean = true):Number {
			var rndm:Number;
			if (between) {
				rndm = Math.random() * (max - min) + min;
			}else {
				rndm = (Random.boolean())? min : max;
			}
			return rndm;
		}
		
		
		/**
		 * Return a random boolean
		 * - ex: Random.boolean() returns true or false (50% of chance of returning true)
		 * - ex2: Random.boolean(0.8) returns true or false (80% of chance of returning true)
		 * @param	chance	Chance of returning true
		 * @return	random boolean
		 */
		public static function boolean(chance:Number = .5):Boolean {
			return (Math.random() < chance)? true : false;
		}
		
		
		/**
		 * Return a random bit (1 or 0)
		 * - ex: Random.bit() returns 1 or 0 (50% of chance of returning 1)
		 * - ex2: Random.bit(0.8) returns 1 or 0 (80% of chance of returning 1)
		 * @param	chance	Chance of returning 1
		 * @return	random bit (1 or 0)
		 */
		public static function bit(chance:Number = .5):uint {
			return (Math.random() < chance)? 1 : 0;
		}
		
		
		/**
		 * Return a random signum (-1 or 1)
		 * - ex: Random.sign() returns -1 or 1 (50% of chance of returning 1)
		 * - ex2: Random.sign(0.8) returns -1 or 1 (80% of chance of returning 1)
		 * @param	chance	Chance of returning 1
		 * @return	random signum (-1 or 1)
		 */
		public static function sign(chance:Number = .5):int {
			return (Math.random() < chance)? 1 : -1;
		}
		
		
		/**
		 * Return a random sin integer (-1 or 0 or 1)
		 * - ex: Random.intSin() returns -1 or 0 or 1 (33.3333333334% of chance of returning 0, 33.3333333333% of chance of returning -1 and 33.3333333333% of chance of returning 1)
		 * - ex2: Random.intSin(0.8) returns -1 or 0 or 1 (80% of chance of returning 0, 10% of chance of returning -1 and 10% of chance of returning 1)
		 * @param	chance	Chance of returning 0
		 * @return	random sin integer (-1 or 0 or 1)
		 */
		public static function sinInt(chance:Number = .333333333334):int {
			var rndm:Number = Math.random();
			var ratio:Number = (1 - chance) * .5;
			if (rndm <= ratio) {
				return -1;
			} else if (rndm <= ratio + chance) {
				return 0;
			} else {
				return 1;
			}
		}
		
		
		/**
		 * Return a random sorted array
		 * - ex: Random.array() returns [1,0] or [0,1]
		 * - ex2: Random.array([1,2,3,4]) returns [3,1,2,4]
		 * - ex3: Random.array([1,2,3,4], 10) returns [3,1,2,4,2,3,4,1,1,2]
		 * @param	items	Array with the items that you want to be shuffled (default is [0,1])
		 * @param	lenght	Lenght of random array (defaul is items.lenght)
		 * @return	random sorted array
		 */
		public static function array(items:Array = null, lenght:int = -1):Array {
			
			if (!items) items = new Array(0, 1);
			if (lenght == -1) lenght = items.length;
			
			function randomSort(elementA:Object, elementB:Object):Number {
				return Random.sinInt();
			}
			
			if(lenght != items.length){
				var endArr:Array = new Array();
				if (lenght < items.length) {
					// ensures that the end array wont have repeated items
					var tempArr:Array = items;
					for (var j:int = 0; j < lenght; j++) {
						endArr.push(tempArr.splice(Random.integer(0, tempArr.length -1), 1)[0]);
					}
				}else {
					// ensures that the end array have at least 1 of each item of the original array
					endArr = items;
					var diff:int = lenght - items.length;
					for (var k:int = 0; k < diff; k++) {
						endArr.push(items[Random.integer(0, items.length-1)]);
					}
				}
				return endArr.sort(randomSort);
			}else {
				return items.sort(randomSort);
			}
			
		}
		
		/**
		 * Returns a random HEX color
		 * @return	radom hexadecimal color
		 */
		public static function color():uint {
			return uint(Math.random()*0xFFFFFF);
		}
		
	}
	
}