package
{
    import loom.gameframework.LoomComponent;
    import loom2d.math.Point;
    import loom2d.math.Rectangle;

    public class RectangleColliderComponent extends LoomComponent
    {
        private var _collider:Rectangle;

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
            _collider.x = p.x;
            _collider.y = p.y;
        }

        public function set width(w:Number)
        {
            _collider.width = w;
        }

        public function set height(h:Number)
        {
            _collider.height = h;
        }

        public function get width():Number
        {
            return _collider.width;
        }

        public function get height():Number
        {
            return _collider.height;
        }

        public function get rectangle():Rectangle
        {
            return _collider;
        }

        public function RectangleColliderComponent(w:Number, h:Number)
        {
            _collider = new Rectangle(0, 0, w, h);
        }
    }
}