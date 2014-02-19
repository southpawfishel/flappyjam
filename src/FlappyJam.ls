package
{
    import loom.Application;
    import loom.gameframework.ITicked;
    import loom.gameframework.TimeManager;
    import loom2d.display.StageScaleMode;
    import loom2d.display.Sprite;
    import loom2d.display.Image;
    import loom2d.textures.Texture;
    import loom2d.math.Point;
    import loom.platform.Timer;

    import org.gestouch.events.GestureEvent;
    import org.gestouch.gestures.TapGesture;

    import loom2d.events.KeyboardEvent;
    import loom.platform.LoomKey;

    public class FlappyJam extends Application implements ITicked
    {
        public static var PIPE_GAP = 120;
        public static var GROUND_Y = 416;
        public static var PIPE_TOP_Y = 150;
        public static var PIPE_BOTTOM_Y = 330;
        public static var FIRST_PIPE_TIME = 2000;
        public static var PIPE_INTERVAL = 1500;

        var uiLayer:Sprite = null;
        var groundLayer:Sprite = null;
        var characterLayer:Sprite = null;
        var pipeLayer:Sprite = null;

        var character:Character = null;
        var pipes:Vector.<Pipe> = new Vector.<Pipe>();

        var started:Boolean = false;
        var tapRecognizer:TapGesture = null;
        var pipeSpawnTimer:Timer = null;

        override public function run():void
        {
            // Comment out this line to turn off automatic scaling.
            stage.scaleMode = StageScaleMode.LETTERBOX;

            // Setup anything else, like UI, or game objects.
            var bg = new Image(Texture.fromAsset("assets/bg.png"));
            bg.width = stage.stageWidth;
            bg.height = stage.stageHeight;
            stage.addChild(bg);

            pipeLayer = new Sprite();
            stage.addChild(pipeLayer);
            group.registerManager(pipeLayer, null, "pipeLayer");

            characterLayer = new Sprite();
            stage.addChild(characterLayer);
            group.registerManager(characterLayer, null, "characterLayer");

            groundLayer = new Sprite();
            stage.addChild(groundLayer);
            group.registerManager(groundLayer, null, "groundLayer");

            uiLayer = new Sprite();
            stage.addChild(uiLayer);
            group.registerManager(uiLayer, null, "uiLayer");

            var ground = new Image(Texture.fromAsset("assets/ground.png"));
            ground.y = stage.stageHeight - ground.height;
            groundLayer.addChild(ground);

            character = new Character();
            character.owningGroup = group;
            character.initialize();

            pipeSpawnTimer = new Timer(FIRST_PIPE_TIME);
            pipeSpawnTimer.onComplete += spawnPipe;

            tapRecognizer = new TapGesture(stage);
            tapRecognizer.numTapsRequired = 1;
            tapRecognizer.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onTap);

            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
        }

        public function onTick():void
        {
            var characterCollider:CircleColliderComponent = character.lookupComponentByName("collider") as CircleColliderComponent;
            for each (var pipe:Pipe in pipes)
            {
                // If character hit pipe, game is over
                var pipeCollider:RectangleColliderComponent = pipe.lookupComponentByName("collider") as RectangleColliderComponent;
                if (Collision.circleToAABB(characterCollider.circle, pipeCollider.rectangle))
                {
                    resetGame();
                    return;
                }

                // Despawn pipes that have moved offscreen
                var pipeTransform:TransformComponent = pipe.lookupComponentByName("transform") as TransformComponent;
                if (pipeTransform.x < -Pipe.PIPE_WIDTH)
                {
                    pipes.remove(pipe);
                    pipe.destroy();
                }
            }

            // If character hit ground, game is over
            var characterTransform:TransformComponent = character.lookupComponentByName("transform") as TransformComponent;
            if (characterTransform.y + characterCollider.circle.radius > GROUND_Y)
            {
                resetGame();
            }
        }

        public function onTap(event:GestureEvent):void
        {
            if (!started)
            {
                startGame();
            }
            else
            {
                var characterController:FlappyControllerComponent = character.lookupComponentByName("controller") as FlappyControllerComponent;
                characterController.onTap(event);
            }
        }

        public function keyDownHandler(event:KeyboardEvent):void
        {   
            var keycode = event.keyCode;
            if (keycode == LoomKey.SPACEBAR)
            {
                onTap(null);
            }
        }

        public function startGame():void
        {
            started = true;

            var characterController:FlappyControllerComponent = character.lookupComponentByName("controller") as FlappyControllerComponent;
            characterController.start();

            pipeSpawnTimer.start();
        }

        public function resetGame():void
        {
            started = false;

            var characterController:FlappyControllerComponent = character.lookupComponentByName("controller") as FlappyControllerComponent;
            characterController.reset();

            for each (var pipe:Pipe in pipes)
            {
                pipe.destroy();
            }
            pipes.clear();

            pipeSpawnTimer.stop();
            pipeSpawnTimer.delay = FIRST_PIPE_TIME;
        }

        public function spawnPipe(timer:Timer):void
        {
            var pipeY = Math.randomRange(PIPE_TOP_Y, PIPE_BOTTOM_Y);

            var topPipe = new Pipe();
            topPipe.owningGroup = group;
            topPipe.initialize();
            topPipe.setProperty("@transform.x", stage.stageWidth);
            topPipe.setProperty("@transform.y", pipeY - (PIPE_GAP / 2) - Pipe.PIPE_HEIGHT);
            topPipe.setProperty("@image.x", topPipe.getProperty("@transform.x"));
            topPipe.setProperty("@image.y", topPipe.getProperty("@transform.y"));
            pipes.pushSingle(topPipe);

            var bottomPipe = new Pipe();
            bottomPipe.owningGroup = group;
            bottomPipe.initialize();
            bottomPipe.setProperty("@transform.x", stage.stageWidth);
            bottomPipe.setProperty("@transform.y", pipeY + (PIPE_GAP / 2));
            bottomPipe.setProperty("@image.x", bottomPipe.getProperty("@transform.x"));
            bottomPipe.setProperty("@image.y", bottomPipe.getProperty("@transform.y"));
            pipes.pushSingle(bottomPipe);

            pipeSpawnTimer.delay = PIPE_INTERVAL;
            pipeSpawnTimer.start();
        }
    }
}