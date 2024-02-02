label = "BGM"
value = game.save.bgm / 2;
onchange = function(t) { game.save.bgm = t * 2; audio_sound_gain(game.bgm, game.save.bgm, 0); }