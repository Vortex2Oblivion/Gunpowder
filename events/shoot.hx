function ljPreloading() {
    ljPreloadImages(["square"]);
}


function makeTracer(){
    var tracer = new FlxSprite(PlayState.dad.x + 440, PlayState.dad.y + 140);
    tracer.loadGraphic(Paths.image("square"));
    tracer.angle = 10 + (Math.random() * 2);
    tracer.origin.x = 0;
    tracer.color = 0xFFFFFF;
    FlxTween.tween(tracer, {alpha: 0 }, 1, {ease: FlxEase.cubeOut, onComplete: function(){
        PlayState.remove(tracer);
        tracer.destroy();
        tracer.kill();
    }});
    PlayState.add(tracer);
}