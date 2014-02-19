package
{
    import loom2d.display.Image;
    import loom2d.display.Stage;
    import loom2d.display.Sprite;
    import loom2d.textures.Texture;
    import loom2d.Loom2D;
    import loom2d.math.Point;
    import loom.gameframework.AnimatedComponent;

    class ImageComponent extends AnimatedComponent
    {
        private var _parent:Sprite;
        private var _image:Image;
        private var _texture:Texture;
        private var _centered:Boolean;
        private var _pivotX:Number = 0;
        private var _pivotY:Number = 0;
        
        public function set x(value:int):void
        {
            if (_image)
            {
                _image.x = value;
            }
        }
        
        public function set y(value:int):void
        {
            if (_image)
            {
                _image.y = value;
            }
        }

        public function set position(value:Point):void
        {
            if (_image)
            {
                this.x = value.x;
                this.y = value.y;
            }
        }

        public function set texture(tex:String):void
        {
            _texture = Texture.fromAsset(tex);
            _texture.smoothing = 0;

            if (_image)
            {
                _image.texture = _texture;
                _image.readjustSize();
            }
        }

        public function center():void
        {
            _centered = true;
            if (_image)
            {
                _image.center();
            }
        }

        public function set pivotX(val:Number):void
        {
            _pivotX = val;
            if (_image)
            {
                _image.pivotX = val;
            }
        }

        public function set pivotY(val:Number):void
        {
            _pivotY = val;
            if (_image)
            {
                _image.pivotY = val;
            }
        }

        public function ImageComponent(parent:Sprite):void
        {
            _parent = parent;
        }
        
        public override function onAdd():Boolean
        {
            if (!super.onAdd())
            {
                return false;
            }

            _image = new Image(_texture);
            if (_centered)
            {
                _image.center();
            }
            else
            {
                _image.pivotX = _pivotX;
                _image.pivotY = _pivotY;
            }
            if (_parent)
            {
                _parent.addChild(_image);
            }
            else
            {
                Loom2D.stage.addChild(_image);
            }

            onFrame();

            return true;
        }
        
        public override function onRemove():void
        {
            _image.parent.removeChild(_image, true);
        
            super.onRemove();
        }
    }
}