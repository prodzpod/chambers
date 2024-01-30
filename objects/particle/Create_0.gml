alarm[0] = 1;
life = 1;
_life = life;

xx = x;
yy = y;
image_speed = 0;
image_index = irandom(sprite_get_number(spr_particle) - 1);
depth = -1;

a = random(360);
r = 0;
angle = random(360);
alpha = random(1);
size = random(1);
h = random(255);
s = random(0.25) * 255;
v = 255;

da = 0;
dr = random(40) + 20;
dangle = 0;
dalpha = -alpha;
dsize = 0;
dh = 0;
ds = 0;
dv = 0;

aa = 0;
ar = -dr;
aangle = 0;
aalpha = 0;
asize = 0;
ah = 0;
as = 0;
av = 0;

label = "";

onstep = function(this) {}; 