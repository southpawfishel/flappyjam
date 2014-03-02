package
{
    import loom.gameframework.TickedComponent;
    import loom2d.Loom2D;
    import loom2d.math.Point;

    import org.gestouch.events.GestureEvent;
    import org.gestouch.gestures.TapGesture;

    public class FlappyControllerComponent extends TickedComponent
    {
        private static var GRAVITY:Number = 1600;
        private static var JUMP_VELOCITY:Number = -475;
        private static var OFFSCREEN_CUTOFF_Y:Number = -50;
        private static var TICKS_PER_ANIM_FRAME = 5;

        private var _velocity:Point = new Point(0, 0);
        private var _gravity:Point = new Point(0, 0);

        private var _started:Boolean = false;

        private var _transform:TransformComponent = null;
        private var _collider:CircleColliderComponent = null;
        private var _image:AtlasSpriteComponent = null;

        private var _tickCount = 0;
        private var _frameNum = 0;

        private static var secondsPerTick = 1.0 / 60.0;

        public override function onAdd():Boolean
        {
            if (!super.onAdd())
            {
                return false;
            }

            _transform = owner.lookupComponentByName("transform") as TransformComponent;
            _collider = owner.lookupComponentByName("collider") as CircleColliderComponent;
            _image = owner.lookupComponentByName("image") as AtlasSpriteComponent;

            Debug.assert(_transform != null, "Character must have transform component");
            Debug.assert(_collider != null, "Character must have collider component");
            Debug.assert(_image != null, "Character must have image component");

            secondsPerTick = timeManager.msPerTick / 1000.0;

            return true;
        }

        public function onTap():void
        {
            if (!_started)
            {
                return;
            }

            jump();
        }

        private function jump():void
        {
            _velocity.y = JUMP_VELOCITY;
        }

        private static function easeOut(ratio:Number):Number
        {
            var invRatio:Number = ratio - 1.0;
            return invRatio * invRatio * invRatio + 1;
        }
        
        private static function easeIn(ratio:Number):Number
        {
            return ratio * ratio * ratio;
        }

        private function onTick():void
        {
            updateMovement();

            updateRotation();

            updateAnimationFrame();
        }

        public function updateMovement():void
        {
            // Apply gravity to velocity
            _velocity.x += _gravity.x * secondsPerTick;
            _velocity.y += _gravity.y * secondsPerTick;

            // Apply velocity to position
            _transform.node.x += _velocity.x * secondsPerTick;
            _transform.node.y += _velocity.y * secondsPerTick;

            // Don't move too far off the top of the screen
            if (_transform.node.y < OFFSCREEN_CUTOFF_Y)
            {
                _transform.node.y = OFFSCREEN_CUTOFF_Y;
            }
        }

        public function updateRotation():void
        {
            // Rotate character according to physics
            var t = 0;
            if (_velocity.y < 0)
            {
                t = -1 * _velocity.y / 500;
                _image.rotation = Math.degToRad(-1 * easeOut(t) * 30.0);
            }
            else if (_velocity.y > 200)
            {
                t = Math.clamp((_velocity.y - 300) / 500, 0, 1);
                _image.rotation = Math.degToRad(easeIn(t) * 60.0);
            }
        }

        public function updateAnimationFrame():void
        {
            // Update animation
            if (_tickCount++ > TICKS_PER_ANIM_FRAME)
            {
                _tickCount = 0;
                ++_frameNum;
                _frameNum %= 2;
                _image.texture = "corgi" + (_frameNum+1);
            }
        }

        public function start():void
        {
            _started = true;
            _gravity = new Point(0, GRAVITY);
            jump();
        }

        public function reset():void
        {
            _started = false;
            _transform.node.y = Loom2D.stage.stageHeight / 2;
            _velocity = new Point(0, 0);
            _gravity = new Point(0, 0);
            _image.rotation = 0;
        }
    }
}