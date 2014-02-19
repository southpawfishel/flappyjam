package
{
    import loom.gameframework.LoomComponent;
    import loom2d.math.Point;

    public class TransformComponent extends LoomComponent
    {
        private var _position:Point = new Point(0, 0);

        public function TransformComponent()
        {
        }

        public function set x(val:Number):void
        {
            _position.x = val;
        }

        public function set y(val:Number):void
        {
            _position.y = val;
        }

        public function get x():Number
        {
            return _position.x;
        }

        public function get y():Number
        {
            return _position.y;
        }

        public function set position(p:Point):void
        {
            _position = p;
        }

        public function get position():Point
        {
            return _position;
        }
    }
}