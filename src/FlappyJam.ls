package
{
    import loom.Application;
    import loom.gameframework.ITicked;
    import loom.gameframework.TimeManager;
    import loom2d.display.StageScaleMode;
    import loom2d.display.Sprite;
    import loom2d.display.Image;
    import loom2d.ui.SimpleLabel;
    import loom2d.ui.TextureAtlasManager;
    import loom2d.ui.TextureAtlasSprite;
    import loom2d.textures.Texture;
    import loom2d.math.Point;
    import loom2d.math.Rectangle;
    import loom.platform.Timer;

    import org.gestouch.events.GestureEvent;
    import org.gestouch.gestures.TapGesture;
    import loom2d.events.TouchEvent;
    import loom2d.events.TouchPhase;

    import loom2d.events.KeyboardEvent;
    import loom.platform.LoomKey;

    public class FlappyJam extends Application implements ITicked
    {
        public static var PIPE_GAP = 120;
        public static var GROUND_Y = 432;
        public static var PIPE_TOP_Y = 150;
        public static var PIPE_BOTTOM_Y = 330;
        public static var FIRST_PIPE_TIME = 2000;
        public static var PIPE_INTERVAL = 1500;

        var uiLayer:Sprite = null;
        var groundLayer:Sprite = null;
        var characterLayer:Sprite = null;
        var pipeLayer:Sprite = null;

        var character:Character = null;
        var activePipes:Vector.<Pipe> = new Vector.<Pipe>();
        var deadPipes:Vector.<Pipe> = new Vector.<Pipe>();

        var started:Boolean = false;
        var tapRecognizer:TapGesture = null;
        var pipeSpawnTimer:Timer = null;

        var score:Number = 0;
        var scoreLabel:SimpleLabel = null;

        override public function run():void
        {
            stage.scaleMode = StageScaleMode.LETTERBOX;
            //stage.reportFps = true;

            TextureAtlasManager.register("spritesheet", "assets/spritesheet.xml");

            var bg = new TextureAtlasSprite();
            bg.atlasName = "spritesheet";
            bg.textureName = "bg";
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

            var ground = new TextureAtlasSprite();
            ground.atlasName = "spritesheet";
            ground.textureName = "ground";
            ground.y = stage.stageHeight - ground.height;
            groundLayer.addChild(ground);

            scoreLabel = new SimpleLabel("assets/Curse-hd.fnt", stage.stageWidth, 50);
            uiLayer.addChild(scoreLabel);
            setScore(0);

            character = new Character();
            character.owningGroup = group;
            character.initialize();

            // Set up initial pipes
            for (var i = 0; i < 4; ++i)
            {
                deadPipes.pushSingle(newPipe());
            }
            pipeSpawnTimer = new Timer(FIRST_PIPE_TIME);
            pipeSpawnTimer.onComplete += spawnPipe;

            stage.addEventListener(TouchEvent.TOUCH, onTap);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
        }

        public function onTick():void
        {
            var scoredThisFrame:Boolean = false;

            var characterCircle:Circle = character.collider.circle;
            characterCircle.center.x = character.transform.node.x;
            characterCircle.center.y = character.transform.node.y;
            var pipeRect:Rectangle = new Rectangle(0, 0, Pipe.PIPE_WIDTH, Pipe.PIPE_HEIGHT);
            var charX:Number = character.transform.node.x;

            for each (var pipe:Pipe in activePipes)
            {
                if (pipe.mover.passedPlayer)
                {
                    // Despawn pipes that have moved offscreen
                    if (pipe.transform.node.x < -Pipe.PIPE_WIDTH)
                    {
                        pipe.mover.offscreen = true;
                        deadPipes.pushSingle(pipe);
                        activePipes.remove(pipe);
                    }
                }
                else
                {
                    // If character hit pipe, game is over
                    pipeRect.x = pipe.transform.node.x;
                    pipeRect.y = pipe.transform.node.y;
                    if (Collision.circleToAABB(characterCircle, pipeRect))
                    {
                        resetGame();
                        return;
                    }

                    // Score pipes that have passed the player
                    var pipeX:Number = pipe.transform.node.x;
                    var pipeCounted:Boolean = pipe.mover.passedPlayer;
                    var passedPlayer = pipeX + Pipe.PIPE_WIDTH < charX - characterCircle.radius;
                    if (!pipeCounted && passedPlayer)
                    {
                        pipe.mover.passedPlayer = true;
                        if (!scoredThisFrame)
                        {
                            scoredThisFrame = true;
                            onPassedPipe();
                        }
                    }
                }
            }

            // If character hit ground, game is over
            var charY:Number = character.transform.node.y;
            if (charY + characterCircle.radius > GROUND_Y)
            {
                resetGame();
            }
        }

        public function onTap(event:TouchEvent):void
        {
            // Do nothing if this isn't a touch began event
            if (event.getTouch(stage, TouchPhase.BEGAN) == null)
            {
                return;
            }

            handleTapInput();
        }

        public function keyDownHandler(event:KeyboardEvent):void
        {   
            var keycode = event.keyCode;
            if (keycode == LoomKey.SPACEBAR)
            {
                handleTapInput();
            }
        }

        public function handleTapInput():void
        {
            if (!started)
            {
                startGame();
            }
            else
            {
                character.controller.onTap();
            }
        }

        public function startGame():void
        {
            started = true;

            setScore(0);

            character.controller.start();

            pipeSpawnTimer.start();
        }

        public function resetGame():void
        {
            started = false;

            character.controller.reset();

            for each (var pipe in activePipes)
            {
                pipe.mover.offscreen = true;
                pipe.mover.passedPlayer = true; 
                pipe.transform.node.x = stage.stageWidth;
                deadPipes.pushSingle(pipe);
            }
            activePipes.clear();

            pipeSpawnTimer.stop();
            pipeSpawnTimer.delay = FIRST_PIPE_TIME;
        }

        public function onPassedPipe():void
        {
            setScore(score+1);
        }

        public function setScore(newScore:Number)
        {
            score = newScore;
            scoreLabel.text = score.toFixed(0);
        }

        public function spawnPipe(timer:Timer):void
        {
            var pipeY = Math.randomRange(PIPE_TOP_Y, PIPE_BOTTOM_Y);

            var topPipe = getOrDequeuePipe();
            topPipe.transform.node.x = stage.stageWidth;
            topPipe.transform.node.y = pipeY - (PIPE_GAP / 2) - Pipe.PIPE_HEIGHT;
            topPipe.image.texture = "pipe_top";
            topPipe.mover.passedPlayer = false;
            topPipe.mover.offscreen = false;
            activePipes.pushSingle(topPipe);

            var bottomPipe = getOrDequeuePipe();
            bottomPipe.transform.node.x = stage.stageWidth;
            bottomPipe.transform.node.y = pipeY + (PIPE_GAP / 2);
            bottomPipe.image.texture = "pipe_bottom";
            bottomPipe.mover.passedPlayer = false;
            bottomPipe.mover.offscreen = false;
            activePipes.pushSingle(bottomPipe);

            pipeSpawnTimer.delay = PIPE_INTERVAL;
            pipeSpawnTimer.start();
        }

        private function getOrDequeuePipe():Pipe
        {
            if (deadPipes.length == 0)
            {
                return newPipe();
            }
            else
            {
                return deadPipes.pop() as Pipe;
            }
        }

        private function newPipe():Pipe
        {
            var pipe = new Pipe();
            pipe.owningGroup = group;
            pipe.initialize();
            return pipe;
        }
    }
}