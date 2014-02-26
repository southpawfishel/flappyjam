package
{
    import loom.gameframework.LoomGameObject;
    import loom2d.display.Sprite;

    public class Pipe extends LoomGameObject
    {
        public static var PIPE_WIDTH = 64;
        public static var PIPE_HEIGHT = 480;

        [Inject(id="pipeLayer")]
        protected var _parentLayer:Sprite;

        public var transform:TransformComponent = null;
        public var image:ImageComponent = null;
        public var collider:RectangleColliderComponent = null;
        public var mover:PipeMoverComponent = null;

        public override function initialize(objectName:String = null):void
        {
            super.initialize(objectName);
            
            transform = new TransformComponent();
            addComponent(transform, "transform");
            transform.x = -PIPE_WIDTH;

            image = new ImageComponent(_parentLayer, "assets/pipe_top.png");
            addComponent(image, "image");
            image.addBinding("x", "@transform.x");
            image.addBinding("y", "@transform.y");

            collider = new RectangleColliderComponent(PIPE_WIDTH, PIPE_HEIGHT);
            addComponent(collider, "collider");
            collider.addBinding("x", "@transform.x");
            collider.addBinding("y", "@transform.y");

            mover = new PipeMoverComponent();
            addComponent(mover, "mover");
        }
    }
}