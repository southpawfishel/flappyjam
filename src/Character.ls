package
{
    import loom.gameframework.LoomGameObject;
    import loom.gameframework.LoomGroup;
    import loom2d.display.Sprite;
    import loom2d.math.Point;
    import loom2d.Loom2D;

    public class Character extends LoomGameObject
    {
        [Inject(id="characterLayer")]
        protected var _parentLayer:Sprite;

        protected var _transform:TransformComponent = null;
        protected var _physics:CharacterPhysicsComponent = null;
        protected var _collider:CircleColliderComponent = null;
        protected var _image:ImageComponent = null;
        protected var _controller:FlappyControllerComponent = null;

        public function get transform():TransformComponent
        {
            return _transform;
        }

        public function get physics():CharacterPhysicsComponent
        {
            return _physics;
        }

        public function get collider():CircleColliderComponent
        {
            return _collider;
        }

        public function get image():ImageComponent
        {
            return _image;
        }

        public function get controller():FlappyControllerComponent
        {
            return _controller;
        }

        public override function initialize(objectName:String = null):void
        {
            super.initialize(objectName);
            
            _transform = new TransformComponent();
            addComponent(_transform, "transform");
            _transform.x = Loom2D.stage.stageWidth / 4;
            _transform.y = Loom2D.stage.stageHeight / 2;

            _physics = new CharacterPhysicsComponent();
            addComponent(_physics, "physics");

            _image = new ImageComponent(_parentLayer);
            addComponent(_image, "image");
            _image.addBinding("position", "@transform.position");
            _image.texture = "assets/corgi1.png";
            _image.pivotX = _image.width - 20;
            _image.pivotY = _image.height / 2;
            //_image.center();

            // var colliderImage = new ImageComponent(_parentLayer);
            // addComponent(colliderImage, "colliderImage");
            // colliderImage.texture = "assets/circle30.png";
            // colliderImage.center();
            // colliderImage.alpha = 0.5;
            // colliderImage.addBinding("position", "@transform.position");

            _collider = new CircleColliderComponent(15);
            addComponent(_collider, "collider");
            _collider.addBinding("position", "@transform.position");

            _controller = new FlappyControllerComponent();
            addComponent(_controller, "controller");
        }
    }
}