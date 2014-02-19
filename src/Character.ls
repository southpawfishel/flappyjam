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

        public override function initialize(objectName:String = null):void
        {
            super.initialize(objectName);
            
            _transform = new TransformComponent();
            _transform.x = Loom2D.stage.stageWidth / 4;
            _transform.y = Loom2D.stage.stageHeight / 2;
            addComponent(_transform, "transform");

            _physics = new CharacterPhysicsComponent();
            addComponent(_physics, "physics");

            _image = new ImageComponent(_parentLayer);
            _image.texture = "assets/circle30.png";
            _image.center();
            _image.addBinding("position", "@transform.position");
            addComponent(_image, "image");

            _collider = new CircleColliderComponent(15);
            _collider.addBinding("position", "@transform.position");
            addComponent(_collider, "collider");

            _controller = new FlappyControllerComponent();
            addComponent(_controller, "controller");
        }
    }
}