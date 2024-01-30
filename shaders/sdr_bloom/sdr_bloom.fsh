//
// epic bloom shader TAKEN FROM STARTELLERS
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 u_quality; // [quality, rotation]
uniform vec4 u_color;
uniform float u_threshold;
uniform vec2 u_pixels;

vec4 pr(vec4 i) {
	vec4 filtered = i * u_color;
	float threshold = dot(u_color.xyz, vec3(0.2126, 0.7152, 0.0722)) * u_threshold;
	float brightness = dot(filtered.xyz, vec3(0.2126, 0.7152, 0.0722));
	return (brightness >= threshold) ? filtered : vec4(0, 0, 0, i.w);
}

void main()
{
	float PI = 6.28318530718 / 2.0;
	vec4 texColor = vec4(0, 0, 0, 0);
	for (float j = 0.0; j < u_quality.y; j++) {
		float angle = j / u_quality.y * (PI * 2.0);
		for (float i = 1.0; i <= u_quality.x; i++) {
			texColor += pr(texture2D(gm_BaseTexture, v_vTexcoord
				+ vec2(cos(angle) * u_pixels.x, sin(angle) * u_pixels.y) * i / u_quality.x))
				* (1.0 - ((i - 1.0) / u_quality.x));
		}
	}
    texColor /= u_quality.y * ((1.0 / u_quality.x + 1.0) * u_quality.x / 2.0);
	texColor += texture2D(gm_BaseTexture, v_vTexcoord);	
	gl_FragColor = v_vColour * texColor;
}
