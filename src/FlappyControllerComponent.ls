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

        private var _started:Boolean = false;

        private var _transform:TransformComponent = null;
        private var _physics:CharacterPhysicsComponent = null;
        private var _collider:CircleColliderComponent = null;

        public override function onAdd():Boolean
        {
            if (!super.onAdd())
            {
                return false;
            }

            _transform = owner.lookupComponentByName("transform") as TransformComponent;
            _physics = owner.lookupComponentByName("physics") as CharacterPhysicsComponent;
            _collider = owner.lookupComponentByName("collider") as CircleColliderComponent;

            Debug.assert(_transform != null, "Character must have transform component");
            Debug.assert(_physics != null, "Character must have physics component");
            Debug.assert(_collider != null, "Character must have collider component");

            return true;
        }

        public function onTap(event:GestureEvent):void
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

        private function onTick():void
        {
            if (_transform.y < OFFSCREEN_CUTOFF_Y)
            {
                _transform.y = OFFSCREEN_CUTOFF_Y;
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