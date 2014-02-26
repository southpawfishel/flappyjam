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

        public var transform:TransformComponent = null;
        public var physics:CharacterPhysicsComponent = null;
        public var collider:CircleColliderComponent = null;
        public var image:AtlasSpriteComponent = null;
        public var controller:FlappyControllerComponent = null;

        public override function initialize(objectName:String = null):void
        {
            super.initialize(objectName);
            
            transform = new TransformComponent();
            addComponent(transform, "transform");
            transform.x = Loom2D.stage.stageWidth / 4;
            transform.y = Loom2D.stage.stageHeight / 2;

            physics = new CharacterPhysicsComponent();
            addComponent(physics, "physics");

            image = new AtlasSpriteComponent(_parentLayer, "spritesheet", "corgi1");
            addComponent(image, "image");
            image.addBinding("x", "@transform.x");
            image.addBinding("y", "@transform.y");
            image.pivotX = image.width - 20;
            image.pivotY = image.height / 2;
            //image.center();

            // var colliderImage = new AtlasSpriteComponent(_parentLayer, "spritesheet", "circle30");
            // addComponent(colliderImage, "colliderImage");
            // colliderImage.center();
            // colliderImage.alpha = 0.5;
            // colliderImage.addBinding("x", "@transform.x");
            // colliderImage.addBinding("y", "@transform.y");

            collider = new CircleColliderComponent(15);
            addComponent(collider, "collider");
            collider.addBinding("x", "@transform.x");
            collider.addBinding("y", "@transform.y");

            controller = new FlappyControllerComponent();
            addComponent(controller, "controller");
        }
    }
}