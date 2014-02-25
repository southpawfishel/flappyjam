package
{
    import loom.gameframework.TickedComponent;

    public class PipeMoverComponent extends TickedComponent
    {
        public static var SPEED = 150;

        private var _passedPlayer:Boolean = true;
        private var _transform:TransformComponent = null;
        public var offscreen:Boolean = true;

        public function get passedPlayer():Boolean
        {
            return _passedPlayer;
        }

        public function set passedPlayer(val:Boolean):void
        {
            _passedPlayer = val;
        }

        public override function onAdd():Boolean
        {
            if (!super.onAdd())
            {
                return false;
            }

            _transform = owner.lookupComponentByName("transform") as TransformComponent;

            Debug.assert(_transform != null, "Pipe Mover must have transform component");

            return true;
        }

        private function onTick():void
        {
            if (offscreen)
            {
                return;
            }

            static var secondsPerTick = timeManager.msPerTick / 1000;

            _transform.x -= SPEED * secondsPerTick;
        }
    }
}