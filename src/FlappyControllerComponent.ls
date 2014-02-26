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

        private var _started:Boolean = false;

        private var _transform:TransformComponent = null;
        private var _physics:CharacterPhysicsComponent = null;
        private var _collider:CircleColliderComponent = null;
        private var _image:AtlasSpriteComponent = null;

        private var tickCount = 0;
        private var frameNum = 0;

        public override function onAdd():Boolean
        {
            if (!super.onAdd())
            {
                return false;
            }

            _transform = owner.lookupComponentByName("transform") as TransformComponent;
            _physics = owner.lookupComponentByName("physics") as CharacterPhysicsComponent;
            _collider = owner.lookupComponentByName("collider") as CircleColliderComponent;
            _image = owner.lookupComponentByName("image") as AtlasSpriteComponent;

            Debug.assert(_transform != null, "Character must have transform component");
            Debug.assert(_physics != null, "Character must have physics component");
            Debug.assert(_collider != null, "Character must have collider component");
            Debug.assert(_image != null, "Character must have image component");

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
            _physics.velocityY = JUMP_VELOCITY;
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
            // Don't move too far off the top of the screen
            if (_transform.y < OFFSCREEN_CUTOFF_Y)
            {
                _transform.y = OFFSCREEN_CUTOFF_Y;
            }

            // Rotate character according to physics
            var t = 0;
            if (_physics.velocityY < 0)
            {
                t = -1 * _physics.velocityY / 500;
                _image.rotation = Math.degToRad(-1 * easeOut(t) * 30.0);
            }
            else
            {
                t = Math.clamp((_physics.velocityY / 900) + 0.2, 0, 1);
                _image.rotation = Math.degToRad(easeIn(t) * 60.0);
            }

            // Update animation
            if (tickCount++ > TICKS_PER_ANIM_FRAME)
            {
                tickCount = 0;
                ++frameNum;
                frameNum %= 2;
                _image.texture = "corgi" + (frameNum+1);
            }
        }

        public function start():void
        {
            _started = true;
            _physics.gravity = new Point(0, GRAVITY);
            jump();
        }

        public function reset():void
        {
            _started = false;
            _transform.y = Loom2D.stage.stageHeight / 2;
            _physics.velocity = new Point(0, 0);
            _physics.gravity = new Point(0, 0);
        }
    }
}