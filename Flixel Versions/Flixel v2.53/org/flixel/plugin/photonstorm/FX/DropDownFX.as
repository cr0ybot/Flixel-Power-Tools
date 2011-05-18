/**
 * DropDownFX - Special FX Plugin
 * -- Part of the Flixel Power Tools set
 * 
 * v1.0 First release
 * 
 * @version 1.0 - May 11th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm.FX 
{
	import com.greensock.motionPaths.RectanglePath2D;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * Creates a drop-down effect FlxSprite, useful for bringing in images in cool ways
	 */
	public class DropDownFX extends BaseFX
	{
		private var image:BitmapData;
		private var chunk:uint;
		private var offset:uint;
		private var updateLimit:uint = 0;
		private var lastUpdate:uint = 0;
		private var complete:Boolean = false;
		private var ready:Boolean = false;
		private var dropDirection:uint;
		private var dropRect:Rectangle;
		private var dropPoint:Point;
		private var dropY:uint;
		
		public function DropDownFX() 
		{
		}
		
		/**
		 * Creates a new DropDown effect from the given image
		 * 
		 * @param	source				The source image bitmapData to use for the drop
		 * @param	x					The x coordinate to place the resulting effect sprite
		 * @param	y					The y coordinate to place the resulting effect sprite
		 * @param	width				The width of the resulting effet sprite. Doesn't have to match the source image
		 * @param	height				The height of the resulting effet sprite. Doesn't have to match the source image
		 * @param	direction			0 = Top to bottom. 1 = Bottom to top. 2 = Left to Right. 3 = Right to Left.
		 * @param	pixels				How many pixels to drop per update (default 1)
		 * @param	split				Boolean (default false) - if split it will drop from opposite sides at the same time
		 * @param	backgroundColor		The background colour of the FlxSprite the effect is drawn in to (default 0x0 = transparent)
		 * 
		 * @return	An FlxSprite with the effect ready to run in it
		 */
		public function create(source:FlxSprite, x:int, y:int, width:uint, height:uint, direction:uint = 0, pixels:uint = 1, split:Boolean = false, backgroundColor:uint = 0x0):FlxSprite
		{
			sprite = new FlxSprite(x, y).makeGraphic(width, height, backgroundColor);
			
			canvas = new BitmapData(width, height, true, backgroundColor);
			
			if (source.pixels.width != width || source.pixels.height != height)
			{
				image = new BitmapData(width, height, true, backgroundColor);
				image.copyPixels(source.pixels, new Rectangle(0, 0, source.pixels.width, source.pixels.height), new Point(0, height - source.pixels.height));
			}
			else
			{
				image = source.pixels;
			}
			
			offset = pixels;
			
			dropDirection = direction;
			dropRect = new Rectangle(0, canvas.height - offset, canvas.width, offset);
			dropPoint = new Point(0, 0);
			dropY = canvas.height;
			
			active = true;
			
			return sprite;
		}
		
		/**
		 * Starts the Effect runnning
		 * 
		 * @param	delay	How many "game updates" should pass between each update? If your game runs at 30fps a value of 0 means it will do 30 drops per second. A value of 1 means it will do 15 drops per second, etc.
		 */
		public function start(delay:uint = 0):void
		{
			updateLimit = delay;
			lastUpdate = 0;
			ready = true;
		}
		
		public function draw():void
		{
			if (ready && complete == false)
			{
				if (lastUpdate != updateLimit)
				{
					lastUpdate++;
					
					return;
				}
				
				canvas.lock();
				
				switch (dropDirection)
				{
					//	Dropping Down
					case 0:
					
						//	Get a pixel strip from the picture (starting at the bottom and working way up)
						for (var y:int = 0; y < dropY; y += offset)
						{
							dropPoint.y = y;
							canvas.copyPixels(image, dropRect, dropPoint);
						}
						
						dropY -= offset;
						
						dropRect.y -= offset;
						
						if (dropY <= 0)
						{
							complete = true;
						}
					
						break;
				}
				
				lastUpdate = 0;
				
				canvas.unlock();
				
				sprite.pixels = canvas;
				sprite.dirty = true;
			}
		}
		
	}

}