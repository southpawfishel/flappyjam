package
{
    import loom2d.math.Point;
    import loom2d.math.Rectangle;

    public class Circle
    {
        public var center:Point;
        public var radius:Number;

        public function Circle(x:Number, y:Number, r:Number)
        {
            center = new Point(x, y);
            radius = r;
        }
    }

    public static class Collision
    {
        public static var point:Point = new Point(0,0);

        public static function circleToAABB(c:Circle, aabb:Rectangle):Boolean
        {
            if (aabb.containsPoint(c.center))
            {
                return true;
            }

            // Top edge
            var xWithinRange:Boolean = (aabb.left < c.center.x) && (c.center.x < aabb.right);
            var yWithinRange:Boolean = Math.abs(aabb.top - c.center.y) < c.radius;
            if (xWithinRange && yWithinRange)
            {
                return true;
            }

            // Bottom edge
            yWithinRange = Math.abs(aabb.bottom - c.center.y) < c.radius;
            if (xWithinRange && yWithinRange)
            {
                return true;
            }

            // Left edge
            xWithinRange = Math.abs(aabb.left - c.center.x) < c.radius;
            yWithinRange = (aabb.top < c.center.y) && (c.center.y < aabb.bottom);
            if (xWithinRange && yWithinRange)
            {
                return true;
            }

            // Right edge
            xWithinRange = Math.abs(aabb.right - c.center.x) < c.radius;
            if (xWithinRange && yWithinRange)
            {
                return true;
            }

            var radiusSquared = c.radius * c.radius;
            // Top left corner
            point.x = aabb.left;
            point.y = aabb.top;
            if (Point.distanceSquared(c.center, point) < radiusSquared)
            {
                return true;
            }

            // Top right corner
            point.x = aabb.right;
            if (Point.distanceSquared(c.center, point) < radiusSquared)
            {
                return true;
            }

            // Bottom left corner
            point.x = aabb.left;
            point.y = aabb.bottom;
            if (Point.distanceSquared(c.center, point) < radiusSquared)
            {
                return true;
            }

            // Bottom right corner
            point.x = aabb.right;
            if (Point.distanceSquared(c.center, point) < radiusSquared)
            {
                return true;
            }

            return false;
        }
    }
}