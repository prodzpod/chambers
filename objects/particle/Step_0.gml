var t = delta_time / 1000000;
_life -= t;

var d = t / life;

da += d * aa;
dr += d * ar;
dangle += d * aangle;
dalpha += d * aalpha;
dsize += d * asize;
dh += d * ah;
ds += d * as;
dv += d * av

a += d * da;
r += d * dr;
angle += d * dangle;
alpha += d * dalpha;
size += d * dsize;
h += d * dh;
s += d * ds;
v += d * dv;

x = xx + r * dcos(a);
y = yy + r * dsin(a);

if (_life <= 0) instance_destroy();