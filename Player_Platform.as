﻿package 
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.display.Stage;

	public class Player_Platform extends MovieClip
	{
		var s:Stage;
		//Constants
		private const FRICTION:Number = 0; 
		private const SPEED_LIMIT:int = 7; 
		private const GRAVITY:Number = 0.8; 
		private const ACCELERATION:Number = 1; 
		private const BOUNCE:Number = -0.3; 
		private const JUMP_FORCE:Number = -13;
		private const BOTTOM_OF_STAGE:uint = 10;
		
		//Variables:
		private var _vx:Number;
		private var _vy:Number;
		private var _accelerationX:Number;
		private var _accelerationY:Number;
		private var _frictionX:Number;
		private var _isOnGround:Boolean;
		private var _bounceX:Number;
		private var _bounceY:Number;
		private var _collisionArea:MovieClip;

		public function Player_Platform(stage:Stage)
		{
			_vx = 0;
			_vy = 0;
			_accelerationX = 0;
			_accelerationY = 0;
			_frictionX = FRICTION;
			_isOnGround = undefined;
			_bounceX = 0;
			_bounceY = 0;
			_collisionArea = this.body; 
			//this.ears.stop();

			//Add stage event listeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN,OnKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,OnKeyUp);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function OnKeyDown(event:KeyboardEvent):void
		{
			//Remove friction if the object is moving
			_frictionX = 1;
			
			if (event.keyCode == Keyboard.LEFT)
			{
				_accelerationX = -ACCELERATION;
			}
			if (event.keyCode == Keyboard.RIGHT)
			{
				_accelerationX = ACCELERATION;
			}
			if ((event.keyCode == Keyboard.UP)
			|| (event.keyCode == Keyboard.SPACE))
			{
				if (_isOnGround)
				{
					_accelerationY = JUMP_FORCE;
				//	this.ears.play();
					_isOnGround = false;
				}
			}
		}
		private function OnKeyUp(event:KeyboardEvent):void
		{
			if ((event.keyCode == Keyboard.LEFT)
			|| (event.keyCode == Keyboard.RIGHT))
			{
				_accelerationX = 0;
				//Apply friction when the keys are no longer being pressed
				_frictionX = FRICTION;
			}
			if ((event.keyCode == Keyboard.UP)
			|| (event.keyCode == Keyboard.SPACE))
			{
				_accelerationY = 0;
			}
		}
		private function onEnterFrame(event:Event):void
		{
			//Initialize local variables
			var playerHalfWidth:uint = _collisionArea.width / 2;
			var playerHalfHeight:uint = _collisionArea.height / 2;

			//Apply Acceleration
			_vx += _accelerationX;
			if (_vx > SPEED_LIMIT)
			{
				_vx = SPEED_LIMIT;
			}
			if (_vx < -SPEED_LIMIT)
			{
				_vx = -SPEED_LIMIT;
			}
			
			_vy += _accelerationY;
			if (_vy > SPEED_LIMIT * 3)
			{
				_vy = SPEED_LIMIT * 3;
			}
			//No speed limit for jumping
			
			//Apply Friction
			if (_isOnGround)
			{
				_vx *= _frictionX;
			}
			if (Math.abs(_vx) < 0.1)
			{
				_vx = 0;
			}
			if (Math.abs(_vy) < 0.1)
			{
				_vy = 0;
			}
			
			//Apply Gravity
			_vy += GRAVITY;
			
			//Apply Bounce from collision with platforms
			x += bounceX;
			y += bounceY;
			
			//Move the player
			x += _vx;
			y += _vy;
			
			//Reset platform bounce values so that they 
			//don't compound with the next collision
			_bounceX = 0;
			_bounceY = 0;

			//Prevent object from moving up if
			//it's not on the ground
			if (! _isOnGround)
			{
				_accelerationY = 0;
			}
			
			//Flap ears only when going up
			if (_vy >= 0)
			{
				//this.ears.gotoAndStop(1);
				_isOnGround = false;
				//_directionY = "down"
			}
			
			//Stage boundaries
			if (x + playerHalfWidth > stage.stageWidth)
			{
				_vx = 0;
				x=stage.stageWidth - playerHalfWidth;
			}
			else if (x - playerHalfWidth < 0)
			{
				_vx = 0;
				x = 0+playerHalfWidth;
			}
			if (y - playerHalfHeight < 0)
			{
				_vy = 0;
				y = 0 + playerHalfHeight;
			}
			else if (y + playerHalfHeight > stage.stageHeight - BOTTOM_OF_STAGE)
			{
				_vy *= BOUNCE;
				y = stage.stageHeight - playerHalfHeight - BOTTOM_OF_STAGE;
				_isOnGround = true;
			}
		}
		
		//Getters and Setters
		public function get isOnGround():Boolean
		{
			return _isOnGround;
		}
		public function set isOnGround(onGround:Boolean):void
		{
			_isOnGround = onGround;
		}
		public function set vx(vxValue:Number):void
		{
			_vx = vxValue;
		}
		public function get vx():Number
		{
			return _vx;
		}
		public function set vy(vyValue:Number):void
		{
			_vy = vyValue;
		}
		public function get vy():Number
		{
			return _vy;
		}
		public function get bounceX():Number
		{
			return _bounceX;
		}
		public function set bounceX(bounceXValue:Number):void
		{
			_bounceX = bounceXValue;
		}
		public function get bounceY():Number
		{
			return _bounceY;
		}
		public function set bounceY(bounceYValue:Number):void
		{
			_bounceY = bounceYValue;
		}
		public function get collisionArea():MovieClip
		{
			return _collisionArea;
		}
	}
}