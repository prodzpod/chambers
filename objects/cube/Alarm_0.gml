VIEW = _VIEW != 0 ? _VIEW : VIEW * image_xscale;
DAMAGE = _DAMAGE != 0 ? _DAMAGE : DAMAGE * image_xscale;
hp = _HP != 0 ? _HP : hp * power(2, image_xscale - 1);
headbuttDamage = DAMAGE;