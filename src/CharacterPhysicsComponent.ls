package
{
    import loom2d.math.Point;
    import loom.gameframework.TickedComponent;

    public class CharacterPhysicsComponent extends TickedComponent
    {
        private var _transform:TransformComponent = null;
        private var _velocity:Point = new Point(0, 0);
        private var _gravity:Point = new Point(0, 0);

        public static var secondsPerTick = 1.0 / 60.0;

        // Velocity getter/setters
        public function set velocityX(vx:Number):void
        {
            _velocity.x = vx;
        }

        public function set velocityY(vy:Number):void
        {
            _velocity.y = vy;
        }

        public function get velocityX():Number
        {
            return _velocity.x;
        }

        public function get velocityY():Number
        {
            return _velocity.y;
        }

        public function set velocity(v:Point):void
        {
            _velocity = v;
        }

        public function get velocity():Point
        {
            return _velocity;
        }

        // Gravity
        public function set gravity(g:Point):void
        {
            _gravity = g;
        }

        public override function onAdd():Boolean
        {
            if (!super.onAdd())
            {
                return false;
            }

            secondsPerTick = timeManager.msPerTick / 1000.0;

            _transform = owner.lookupComponentByName("transform") as TransformComponent;

            Debug.assert(_transform != null, "Physics must have transform component");

            return true;
        }

        public function onTick():void
        {
            // Apply gravity to velocity
            _velocity.x += _gravity.x * secondsPerTick;
            _velocity.y += _gravity.y * secondsPerTick;
            //trace(_velocity);

            // Apply velocity to position
            _transform.x += _velocity.x * secondsPerTick;
            _transform.y += _velocity.y * secondsPerTick;
            //trace(_position);
        }
    }
}