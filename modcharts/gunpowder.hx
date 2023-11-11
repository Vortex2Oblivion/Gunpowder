import("openfl.filters.ShaderFilter");

var rain:CustomShader = new CustomShader(Paths.shader("rain"));
var abberation:CustomShader = new CustomShader(Paths.shader("abberation"));
var mirror:CustomShader = new CustomShader(Paths.shader("mirror"));
var pixel:CustomShader = new CustomShader(Paths.shader("pixel"));
var bleed:CustomShader = new CustomShader(Paths.shader("bleed"));
var camShader:CustomShader;
var camShader2:CustomShader;
var t:Float = 0;
var bgParticlesBF:FlxSprite;
var streetBehind:FlxSprite = null;
var bgParticlesPico:FlxSprite;

//yooo he said the thing!!!
var uno:FlxSprite;
var dos:FlxSprite;
var tres:FlxSprite;
var cuatro:FlxSprite;
var ruckus:FlxSprite;

var bleedTime:Float = 0;
var bleedDamage:Float = 0.2;

function addBleedTime(){
    bleedTime += 5;
}

function createPost() {

    PlayState.healthBar.scale.y = 0.35;
    PlayState.healthBar.scale.x = 0.975;
    PlayState.healthBar.y -= 55;
    PlayState.healthBarBG.y -= 50;
    if(PlayState.scoreWarning != null)
        PlayState.scoreWarning.y -= 55;

    FlxTween.num(3, 1, 12.25, {ease: FlxEase.quintIn}, updateFunction);
    uno = new FlxSprite(0, 0).loadGraphic(Paths.image('uno'));
    uno.screenCenter();
    uno.camera = PlayState.camHUD;
    uno.alpha = 0;
    PlayState.add(uno);

    dos = new FlxSprite(0, 0).loadGraphic(Paths.image('dos'));
    dos.screenCenter();
    dos.camera = PlayState.camHUD;
    dos.alpha = 0;
    PlayState.add(dos);

    tres = new FlxSprite(0, 0).loadGraphic(Paths.image('tres'));
    tres.screenCenter();
    tres.camera = PlayState.camHUD;
    tres.alpha = 0;
    PlayState.add(tres);

    cuatro = new FlxSprite(0, 0).loadGraphic(Paths.image('cuatro'));
    cuatro.screenCenter();
    cuatro.camera = PlayState.camHUD;
    cuatro.alpha = 0;
    PlayState.add(cuatro);

    ruckus = new FlxSprite(0, 0).loadGraphic(Paths.image('BRING_IN_THE_WAWA'));
    ruckus.screenCenter();
    ruckus.camera = PlayState.camHUD;
    ruckus.alpha = 0;
    PlayState.add(ruckus);
    ruckus.setGraphicSize(Std.int(ruckus.width * 0.55));
    PlayState.camGame.setFilters([new ShaderFilter(rain), new ShaderFilter(abberation), new ShaderFilter(pixel), new ShaderFilter(mirror)]);
    PlayState.camHUD.setFilters([new ShaderFilter(abberation), new ShaderFilter(pixel), new ShaderFilter(mirror), new ShaderFilter(bleed)]);
    bleed.shaderData.red.value = [255];
    bleed.shaderData.size.value = [0];
    bleed.shaderData.strength.value = [15];
}
function updateFunction(Value:Float){
    mirror.shaderData.zoom.value = [Value];
}
function angles(Value:Float){
    mirror.shaderData.angle.value = [Value];
}
function pixle(Value:Float){
    pixel.shaderData.scale.value = [Value];
}
function create(){
    stage = PlayState_.stage;

    light = global['light'];
    streetBehind = global['Rooftop'];

    camShader = new CustomShader(Paths.shader("blammedhud"));
    camShader2 = new CustomShader(Paths.shader("blammedhud"));

    camShader.shaderData.isUI.value = [false];
    camShader2.shaderData.isUI.value = [true];

    FlxG.camera.filtersEnabled = true;

    mirror.shaderData.zoom.value = [3];
    pixel.shaderData.scale.value = [1];

    bgParticlesBF = new FlxSprite(-350, -550);
    bgParticlesPico = new FlxSprite(-350, -550);

    for(bgParticles in [bgParticlesBF, bgParticlesPico]) {
        bgParticles.loadGraphic(Paths.image("philly/particles"));
        bgParticles.antialiasing = true;
        bgParticles.scale.x *= 1.5;
        bgParticles.scale.y *= 1.5;
        bgParticles.updateHitbox();
        bgParticles.shader = new CustomShader(Paths.shader("blammedparticles"));
        bgParticles.shader.shaderData.horizontalDistort.value = [0];
        bgParticles.shader.shaderData.verticalScroll.value = [0];
        bgParticles.visible = true;
    }

    bgParticlesBF.angle = 270;
    bgParticlesPico.angle = 90;

    PlayState.insert(PlayState.members.indexOf(streetBehind), bgParticlesBF);
    PlayState.insert(PlayState.members.indexOf(streetBehind), bgParticlesPico);


    camShader.shaderData.enabled.value = [true];
    camShader2.shaderData.enabled.value = [true];
    camShader.shaderData.diff.value = [0];
    camShader2.shaderData.diff.value = [0];
}

function updatePost(elapsed:Float) {
    var color = new FlxColor(light.color);
    for (i in [camShader, camShader2]) {
        i.shaderData.r.value = [color.redFloat];
        i.shaderData.g.value = [color.greenFloat];
        i.shaderData.b.value = [color.blueFloat];
    }
}

var particlesFloatSpeed:Float = 0;
var vigSize:Float = 0;
function update(elapsed) {
    camShader.shaderData.diff.value = [FlxMath.lerp(camShader.shaderData.diff.value[0], 0, 0.125 * elapsed * 60)];
    camShader2.shaderData.diff.value =  [camShader.shaderData.diff.value] * 2;

	t += elapsed;
    rain.shaderData.iTime.value = [t];
    strength = FlxMath.lerp(strength, 0, elapsed*5);
    abberation.shaderData.strength.value = [strength];

    particlesFloatSpeed = FlxMath.lerp(particlesFloatSpeed, 0.1, 0.125 * elapsed * 60);
    bgParticlesPico.shader.shaderData.verticalScroll.value = bgParticlesBF.shader.shaderData.verticalScroll.value = [(bgParticlesBF.shader.shaderData.verticalScroll.value[0] + (particlesFloatSpeed * elapsed)) % 1];
    bgParticlesPico.shader.shaderData.horizontalDistort.value = bgParticlesBF.shader.shaderData.horizontalDistort.value = [bgParticlesBF.shader.shaderData.horizontalDistort.value[0] + elapsed];
    if (PlayState.section != null) {
        bgParticlesBF.alpha = FlxMath.lerp(bgParticlesBF.alpha, PlayState.section.mustHitSection ? 1 : 0, 0.125 * elapsed * 60);
        bgParticlesPico.alpha = FlxMath.lerp(bgParticlesPico.alpha, PlayState.section.mustHitSection ? 0 : 1, 0.125 * elapsed * 60);
    }
    if(bleedTime > 0){
        bleedTime -= elapsed;
        var damage = bleedDamage*elapsed;
        var healthAfter = PlayState.health - damage;
        if( healthAfter > 0.01+damage){
            PlayState.health = healthAfter;
        }
    }
    var targetVigSize = bleedTime*0.05;
    if(targetVigSize < 0){
        targetVigSize = 0;
    }
    vigSize = FlxMath.lerp(vigSize, targetVigSize, elapsed*8);
    bleed.shaderData.size.value = [vigSize];
}
var strength:Float = 0;

function stepHit(curStep) {
    if (curStep == 1664){
        PlayState.camGame.setFilters([new ShaderFilter(camShader), new ShaderFilter(rain), new ShaderFilter(abberation) , new ShaderFilter(mirror)]);
        PlayState.camHUD.setFilters([new ShaderFilter(camShader2), new ShaderFilter(abberation) , new ShaderFilter(mirror)]);
    }
    if(curStep == 496){
        FlxTween.num(1, 2.55, 1.45, {ease: FlxEase.quintIn, onComplete: function(){FlxTween.num(2.55, 1, 0.255, {ease: FlxEase.quintOut}, updateFunction);}}, updateFunction);
    }
    if(curStep == 1920){
        FlxTween.num(1, 7, 15, {ease: FlxEase.quintIn}, updateFunction);
        FlxTween.num(0, 90, 15, {ease: FlxEase.quintIn}, angles);
    }
    if(curStep == 2079){
        if (PlayState.misses == 0 && !PlayState.botplay){
            Medals.unlock("Gunpowder FC");
        }
    }
}

function pixelate(){
    FlxTween.num(1, 8, 1.3, {ease: FlxEase.linear, onComplete: function(){FlxTween.num(2.55, 1, 0.255, {ease: FlxEase.linear}, pixle);}}, pixle);
}

function caBurst(){
    strength = strength + 0.007;
    if (0.01 != null || 0.01 != '' ){ 
        if (strength > 0.01){ 
            strength = 0.01;
        }
    }
}

function unoA() {
    uno.alpha = 1;
    FlxTween.tween(uno, {alpha: 0 }, Conductor.stepCrochet / 250, {ease: FlxEase.cubeInOut});
}

function dosA() {
    dos.alpha = 1;
    FlxTween.tween(dos, {alpha: 0 }, Conductor.stepCrochet / 250, {ease: FlxEase.cubeInOut});
}

function tresA() {
    tres.alpha = 1;
    FlxTween.tween(tres, {alpha: 0 }, Conductor.stepCrochet / 250, {ease: FlxEase.cubeInOut});
}

function cuatroA() {
    cuatro.alpha = 1;
    FlxTween.tween(cuatro, {alpha: 0 }, Conductor.stepCrochet / 250, {ease: FlxEase.cubeInOut});
}

function ruckusA() {
    ruckus.alpha = 1;
    FlxTween.tween(ruckus, {alpha: 0 }, 1, {ease: FlxEase.cubeInOut});
}

function onPostEndSong() {
    if (PlayState.misses == 0 && !PlayState.botplay){
        Medals.unlock("Gunpowder FC");
    }
}