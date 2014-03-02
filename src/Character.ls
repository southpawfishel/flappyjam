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
        public var collider:CircleColliderComponent = null;
        public var image:AtlasSpriteComponent = null;
        public var controller:FlappyControllerComponent = null;

        public override function initialize(objectName:String = null):void
        {
            super.initialize(objectName);
            
            transform = new TransformComponent(_parentLayer);
            addComponent(transform, "transform");
            transform.node.x = Loom2D.stage.stageWidth / 4;
            transform.node.y = Loom2D.stage.stageHeight / 2;

            image = new AtlasSpriteComponent(transform.node, "spritesheet", "corgi1");
            addComponent(image, "image");
            image.pivotX = image.width - 20;
            image.pivotY = image.height / 2;
            //image.center();

            // var colliderImage = new AtlasSpriteComponent(transform.node, "spritesheet", "circle30");
            // addComponent(colliderImage, "colliderImage");
            // colliderImage.center();
            // colliderImage.alpha = 0.5;

            collider = new CircleColliderComponent(15);
            addComponent(collider, "collider");

            controller = new FlappyControllerComponent();
            addComponent(controller, "controller");
        }
    }
}