package
{
    import loom2d.math.Point;
    import loom2d.math.Rectangle;

    public class Circle
    {
        private var _center:Point;
        private var _radius:Number;

        public function Circle(x:Number, y:Number, r:Number)
        {
            _center = new Point(x, y);
            _radius = r;
        }

        public function set x(newX:Number)
        {
            _center.x = newX;
        }

        public function get x():Number
        {
            return _center.x;
        }

        public function set y(newY:Number)
        {
            _center.y = newY;
        }

        public function get y():Number
        {
            return _center.y;
        }

        public function get center():Point
        {
            return _center;
        }

        public function set center(p:Point):void
        {
            _center = p;
        }

        public function get radius():Number
        {
            return _radius;
        }
    }

    public static class Collision
    {
        public static function circleToAABB(c:Circle, aabb:Rectangle):Boolean
        {
            var point:Point = new Point(0,0);

            if (aabb.containsPoint(c.center))
            {
                return true;
            }

            // Top edge
            var xWithinRange:Boolean = (aabb.left < c.x) && (c.x < aabb.right);
            var yWithinRange:Boolean = Math.abs(aabb.top - c.y) < c.radius;
            if (xWithinRange && yWithinRange)
            {
                return true;
            }

            // Bottom edge
            yWithinRange = Math.abs(aabb.bottom - c.y) < c.radius;
            if (xWithinRange && yWithinRange)
            {
                return true;
            }

            // Left edge
            xWithinRange = Math.abs(aabb.left - c.x) < c.radius;
            yWithinRange = (aabb.top < c.y) && (c.y < aabb.bottom);
            if (xWithinRange && yWithinRange)
            {
                return true;
            }

            // Right edge
            xWithinRange = Math.abs(aabb.right - c.x) < c.radius;
            if (xWithinRange && yWithinRange)
            {
                return true;
            }

            // Top left corner
            point.x = aabb.left;
            point.y = aabb.top;
            if (Point.distanceSquared(c.center, point) < (c.radius * c.radius))
            {
                return true;
            }

            // Top right corner
            point.x = aabb.right;
            if (Point.distanceSquared(c.center, point) < (c.radius * c.radius))
            {
                return true;
            }

            // Bottom left corner
            point.x = aabb.left;
            point.y = aabb.bottom;
            if (Point.distanceSquared(c.center, point) < (c.radius * c.radius))
            {
                return true;
            }

            // Bottom right corner
            point.x = aabb.right;
            if (Point.distanceSquared(c.center, point) < (c.radius * c.radius))
            {
                return true;
            }

            return false;
        }
    }
}