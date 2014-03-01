package
{
    import loom.gameframework.LoomComponent;
    import loom2d.display.DisplayObject;
    import loom2d.display.DisplayObjectContainer;
    import loom2d.display.Sprite;
    import loom2d.Loom2D;

    public class TransformComponent extends LoomComponent
    {
        public var parent:DisplayObjectContainer = null;
        public var node:Sprite = new Sprite();

        public function get x():Number
        {
            return node.x;
        }

        public function get y():Number
        {
            return node.y;
        }

        public function set x(newX:Number):void
        {
            node.x = newX;
        }

        public function set y(newY:Number):void
        {
            node.y = newY;
        }

        public function get rotation():Number
        {
            return node.rotation;
        }

        public function set rotation(newRotation:Number):void
        {
            node.rotation = newRotation;
        }

        public function TransformComponent(newParent:Sprite=null)
        {
            parent = newParent;
        }

        public override function onAdd():Boolean
        {
            if (!super.onAdd())
            {
                return false;
            }

            if (parent)
            {
                parent.addChild(node);
            }
            else
            {
                Loom2D.stage.addChild(node);
            }

            return true;
        }

        public override function onRemove():void
        {
            node.parent.removeChild(node);

            super.onRemove();
        }

        public function addChild(child:DisplayObject):void
        {
            node.addChild(child);
        }

        public function removeChild(child:DisplayObject):void
        {
            node.removeChild(child);
        }
    }
}