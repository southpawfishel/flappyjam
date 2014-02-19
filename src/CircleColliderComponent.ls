package
{
    import loom.gameframework.TickedComponent;
    import loom2d.math.Point;

    public class CircleColliderComponent extends TickedComponent
    {
        private var _collider:Circle;

        public function set x(newX:Number)
        {
            _collider.x = newX;
        }

        public function set y(newY:Number)
        {
            _collider.y = newY;
        }

        public function set position(p:Point)
        {
            _collider.center = p;
        }

        public function get position():Point
        {
            return _collider.center;
        }

        public function get radius():Number
        {
            return _collider.radius;
        }

        public function get circle():Circle
        {
            return _collider;
        }

        public function CircleColliderComponent(r:Number)
        {
            _collider = new Circle(0, 0, r);
        }
    }
}