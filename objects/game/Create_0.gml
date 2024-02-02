/// @description init
#macro mb_wheelup 6
#macro mb_wheeldown 7

randomize();
date_set_timezone(timezone_utc);
draw_set_font(fnt_alagard);
global.fnt_small = font_add_sprite_ext(spr_fnt2, "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,!?%^-_()*+=|/\\'\"[]:;<>`", false, 1)

_list = ds_list_create();
temp = ds_list_create();

// shader
application_surface_draw_enable(false);
_u_quality = shader_get_uniform(sdr_bloom, "u_quality");
_u_color = shader_get_uniform(sdr_bloom, "u_color");
_u_threshold = shader_get_uniform(sdr_bloom, "u_threshold");
_u_pixels = shader_get_uniform(sdr_bloom, "u_pixels");
u_quality = [16, 11];
u_color = [0.5, 0.5, 0.5, 0.25];
u_threshold = 0.5;
u_pixel = 32;
u_pixels = [u_pixel / window_get_width(), u_pixel / window_get_height()];

// data
init_data();
save = {
	// little guy
	name: "",
	color_hair: c_white,
	color_skin: c_white,
	color_shirt: c_white,
	color_arms: c_white,
	color_legs: c_white,
	type_hair: 0,
	type_cosmetic: 0,
	// unlocks
	weapon_unlocks: [],
	cosmetic_unlocks: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24],
	// stats
	wins: 0,
	won_with: {},
	deaths: 0,
	died_to: {},
	runs: [],
	running_as: {},
	pb: -1,
	kills: 0,
	killed: {},
	// options
	bgm: 1,
	sfx: 1,
	shake: 1,
	resolution: 1,
	// control
	up: ord("W"),
	left: ord("A"),
	down: ord("S"),
	right: ord("D"),
	jump: vk_space,
	attack: mb_left,
	reload: mb_right,
	attack2: ord("Z"),
	reload2: ord("X"),
	aimup: vk_up,
	aimleft: vk_left,
	aimright: vk_right,
	aimdown: vk_down,
	peek: vk_shift,
	aimreverse: vk_control,
	cancel: vk_escape,
	confirm: vk_enter,
	peekwithaim: false,
	death: vk_f5,
	// frags
	elo: 1000,
	online: true
}
DEFAULT_SAVE = json_parse(json_stringify(save));

run = {
	rta: 0,
	igt: 0,
	cleared: [],
	// stats
	jump: 500,
	move: 350,
	mindmg: 0, // -1~0: lerp 0, min, x+1 / 0~1: lerp min, max, x / 1~2: lerp max*floor(x), max*(floor(x)+1), x-floor(x)
	maxdmg: 1,	// multiplier
	reload: 1, // multiplier
	range: 1,
	inventory: [0],
	durability: [-1],
	class: 0,
	hp: 5,
	shield: 0,
	immunity: 1,
	multishot: 0,
}
global.RUN_DEFAULT = json_parse(json_stringify(run)); // were so js rn

rooms = [];
dungeon = [];

global.boss = undefined;
global.blocks = [];
gameSpeed = 0;

// camera
cameraX = 0;
cameraY = 0;
screenshake = 0;
_screenshake = 0;
screenshakeDuration = 0.5;
_screenshakeDuration = 0.5;

tooltip = "";
tooltipColor = c_white;
tooltipDuration = 1;
_tooltipDuration = 1;

_cameraOffX = 0;
_cameraOffY = 0;
__cameraOffX = 0;
__cameraOffY = 0;
bossID = -1;
bossElo = 1000;
shouldActivateBoss = 5;
weaponroll = 3;

input_clicked = false;

if (os_browser != browser_not_a_browser) return;
if (file_exists("./save.json")) {
	data_load();
	window_apply_resolution();
	room_goto(rm_title);
} else room_goto(rm_character);
bgm = audio_play_sound(bgm_main, 0, true, save.bgm);