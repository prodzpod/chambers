/// @description Insert description here
event_inherited();
STATE_DEFAULT = {
	duration: 1,
	onenter: function(this) { /* do nothing */ },
	onstep: function(this, t) { /* do nothing */ },
	onend: function(this) { /* do nothing */ return "idle"; },
};
function changeState(key) {
	time_state = 0;
	var nextState = struct_exists(state, "onend") ? state.onend(self) : STATE_DEFAULT.onend(self);
	stateName = is_undefined(key) || !is_string(key) ? nextState : key;
	state = !is_undefined(key) && !is_string(key) ? key : states[$ stateName];
	if (struct_exists(state, "onenter")) state.onenter(self);
	else STATE_DEFAULT.onenter(self);
}
states = { idle: STATE_DEFAULT }
stateName = "idle";
state = STATE_DEFAULT;
time_state = 0;
stunned = false;

onstep = function(t) {
	if (struct_exists(state, "onstep")) state.onstep(self, t);
	else STATE_DEFAULT.onstep(self, t);
	time_state += t;
	if (time_state >= (struct_exists(state, "duration") ? state.duration : STATE_DEFAULT.duration)) changeState();
	if (stateName != "stunned" && _headbuttImmune <= 0 && place_meeting(x, y, player)) {
		player_damage(self, headbuttDamage);
		_headbuttImmune = headbuttImmune;
	} 
	if (headbuttImmune > 0) {
		_headbuttImmune -= t;
	}
	_headbuttImmuneBlink = !_headbuttImmuneBlink;
}
_aim = 0;
ondamage = function(source, amount) {}
ondeath = function() {}
hp = 1;

headbuttDamage = 1;
headbuttImmune = 1;
_headbuttImmune = 0;
_headbuttImmuneBlink = false;

onhurt = function(weapon, amount) {}
onhit = function(amount) {}