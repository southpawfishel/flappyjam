package
{
    import loom2d.display.Image;
    import loom2d.ui.TextureAtlasSprite;
    import loom2d.display.Stage;
    import loom2d.display.Sprite;
    import loom2d.textures.Texture;
    import loom2d.Loom2D;
    import loom2d.math.Point;
    import loom.gameframework.AnimatedComponent;
    import loom.gameframework.LoomComponent;

    class ImageComponent extends LoomComponent
    {
        private var _parent:Sprite;
        private var _image:Image;
        private var _texture:Texture;

        public function set texture(tex:String):void
        {
            _texture = Texture.fromAsset(tex);
            _texture.smoothing = 0;
            _image.texture = _texture;
        }
        
        public function set x(value:int):void
        {
            _image.x = value;
        }
        
        public function set y(value:int):void
        {
            _image.y = value;
        }

        public function set position(value:Point):void
        {
            this.x = value.x;
            this.y = value.y;
        }

        public function set alpha(value:Number):void
        {
            _image.alpha = value;
        }

        public function get width():Number
        {
            return _image.width;
        }

        public function get height():Number
        {
            return _image.height;
        }

        public function set width(val:Number):void
        {
            _image.width = val;
        }

        public function set height(val:Number):void
        {
            _image.height = val;
        }

        public function center():void
        {
            _image.center();
        }

        public function set pivotX(val:Number):void
        {
            _image.pivotX = val;
        }

        public function set pivotY(val:Number):void
        {
            _image.pivotY = val;
        }

        public function set rotation(angle:Number):void
        {
            _image.rotation = angle;
        }

        public function ImageComponent(parent:Sprite, texture:String):void
        {
            _parent = parent;
            
            _texture = Texture.fromAsset(texture);
            _texture.smoothing = 0;
        }
        
        public override function onAdd():Boolean
        {
            if (!super.onAdd())
            {
                return false;
            }

            _image = new Image(_texture);
            if (_parent)
            {
                _parent.addChild(_image);
            }
            else
            {
                Loom2D.stage.addChild(_image);
            }

            return true;
        }
        
        public override function onRemove():void
        {
            _image.parent.removeChild(_image, true);
        
            super.onRemove();
        }
    }

    class AtlasSpriteComponent extends LoomComponent
    {
        private var _parent:Sprite;
        private var _image:TextureAtlasSprite;

        public function set texture(tex:String):void
        {
            _image.textureName = tex;
        }
        
        public function set x(value:int):void
        {
            _image.x = value;
        }
        
        public function set y(value:int):void
        {
            _image.y = value;
        }

        public function set position(value:Point):void
        {
            this.x = value.x;
            this.y = value.y;
        }

        public function set alpha(value:Number):void
        {
            _image.alpha = value;
        }

        public function get width():Number
        {
            return _image.width;
        }

        public function get height():Number
        {
            return _image.height;
        }

        public function set width(val:Number):void
        {
            _image.width = val;
        }

        public function set height(val:Number):void
        {
            _image.height = val;
        }

        public function center():void
        {
            _image.center();
        }

        public function set pivotX(val:Number):void
        {
            _image.pivotX = val;
        }

        public function set pivotY(val:Number):void
        {
            _image.pivotY = val;
        }

        public function set rotation(angle:Number):void
        {
            _image.rotation = angle;
        }

        public function AtlasSpriteComponent(parent:Sprite, atlas:String, texture:String):void
        {
            _parent = parent;
            _image = new TextureAtlasSprite();
            _image.atlasName = atlas;
            _image.textureName = texture;
        }
        
        public override function onAdd():Boolean
        {
            if (!super.onAdd())
            {
                return false;
            }

            if (_parent)
            {
                _parent.addChild(_image);
            }
            else
            {
                Loom2D.stage.addChild(_image);
            }

            return true;
        }
        
        public override function onRemove():void
        {
            _image.parent.removeChild(_image, true);
        
            super.onRemove();
        }
    }
}