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

        protected var _transform:TransformComponent = null;
        protected var _image:ImageComponent = null;
        protected var _collider:RectangleColliderComponent = null;
        protected var _mover:PipeMoverComponent = null;

        public function get transform():TransformComponent
        {
            return _transform;
        }

        public function get image():ImageComponent
        {
            return _image;
        }

        public function get collider():RectangleColliderComponent
        {
            return _collider;
        }

        public function get mover():PipeMoverComponent
        {
            return _mover;
        }

        public override function initialize(objectName:String = null):void
        {
            super.initialize(objectName);
            
            _transform = new TransformComponent();
            _transform.x = -PIPE_WIDTH;
            addComponent(_transform, "transform");

            _image = new ImageComponent(_parentLayer);
            _image.texture = "assets/pipe_top.png";
            _image.addBinding("position", "@transform.position");
            addComponent(_image, "image");

            _collider = new RectangleColliderComponent(PIPE_WIDTH, PIPE_HEIGHT);
            _collider.addBinding("position", "@transform.position");
            addComponent(_collider, "collider");

            _mover = new PipeMoverComponent();
            addComponent(_mover, "mover");
        }
    }
}