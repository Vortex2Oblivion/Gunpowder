var stage:Stage = null;
var light:FlxSprite = null;
var phillyCityLights:Array<Int> = [
    0xFF31A2FD,
    0xFF31FD8C,
    0xFFFB33F5,
    0xFFFD4531,
    0xFFFBA633,
];


function ljPreloading() {
    ljPreloadImages(["rain"]);
}


var particleSpawnTime:Float = 0.01;
var particleTime:Float = 0;
var particleCount:Float = 0;
var velocityAngle:Float = 140;
var velocitySpeed:Float = 8000;
var spawnX:Float = 0;
var spawnWidth:Float = 6000;
var spawnY:Float = 600;
var piss:Bool = false;
var pis:Float = 0;
var poolLimit:Int = 200;

var rainParticle:FlxSprite;


function beatHit(curBeat) {
    if (curBeat % 4 == 0)
    {
        var c = phillyCityLights[FlxG.random.int(0, phillyCityLights.length - 1)];
        light.color = c;
        light.alpha = 1;
    }
}
function create() {
    light = new FlxSprite().loadGraphic(Paths.image('philly/win'));
    light.scrollFactor.set(0.3, 0.3);
    light.setGraphicSize(Std.int(light.width * 0.85));
    light.updateHitbox();
    light.antialiasing = true;
    light.alpha = 0;
    global["light"] = light;
	light.visible = false;
	stage = loadStage('wiik-100');
	PlayState.gf.visible = false;
}
function createPost() {
    initPool();
}
function update(elapsed:Float) {
	stage.update(elapsed);
    particleTime = particleTime + elapsed;
    if (particleTime >= particleSpawnTime){
        particleTime = particleTime - particleSpawnTime;
        makeParticle();
    }
    //why is this in vc lmao
    if (pis == 0 && FlxG.keys.justPressed.P || pis == 1 && FlxG.keys.justPressed.I || pis > 1 && FlxG.keys.justPressed.S){
        pis = pis + 1;
        if (pis >= 4 ) {
            piss = true;
        }
    }
}
function initPool(){
    for (i in 0...poolLimit) {
        rainParticle = new FlxSprite(-10000, 0).loadGraphic(Paths.image("rain"));
        PlayState.add(rainParticle);
    }
}
function makeParticle(){
    var pos = FlxMath.lerp(spawnX, spawnX+spawnWidth, Math.random());

    rainParticle.x = pos;
    rainParticle.y = spawnY;

    if (piss){
        rainParticle.color = 0xFFFF00;
    }

    rainParticle.angle = velocityAngle;

    rainParticle.alpha = FlxMath.lerp(0.25, 0.7, Math.random());

    rainParticle.velocity.x = Math.cos(velocityAngle*(Math.PI/180))*velocitySpeed;

    rainParticle.velocity.y = Math.sin(velocityAngle*(Math.PI/180))*velocitySpeed;

    var scroll = FlxMath.lerp(0.8, 1.3, Math.random());

    rainParticle.scrollFactor.set(scroll, scroll);

    particleCount = particleCount + 1;

    if (particleCount > 200)  
        particleCount = 0;
}
