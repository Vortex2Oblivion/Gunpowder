import openfl.geom.ColorTransform;

var bgApple = new FlxSprite().makeGraphic(FlxG.width*2,FlxG.height*2);

function badApple(choose:String){
			if (choose == "a"){
			remove(gf);
			remove(boyfriend);
			remove(dad);
			boyfriend.colorTransform.color = (0x000000);
			Pibby.colorTransform.color = (0x000000);
			dad.colorTransform.color = (0x000000);
			gf.colorTransform.color = (0x000000);
			healthBar.colorTransform.color = (0x000000);
			iconP1.colorTransform.color = (0x000000);
			iconP2.colorTransform.color = (0x000000);
			add(bgApple);
			bgApple.screenCenter();
			add(gf);
			add(dad);
			add(boyfriend);
			}
			if (choose == "a"){
			remove(bgApple);
			boyfriend.colorTransform = new ColorTransform();
			dad.colorTransform = new ColorTransform();
			gf.colorTransform = new ColorTransform();
			healthBar.colorTransform = new ColorTransform();
			iconP1.colorTransform = new ColorTransform();
			iconP2.colorTransform = new ColorTransform();
			}
}