shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float sweepWidth;
uniform float sweepTime;
uniform float redTime;
uniform float tearIntensity;
uniform float tearFrequency;
float random(vec2 uv){
	float r=fract((TIME+120.0)*sin((TIME+120.0)*dot(uv, (TIME+120.0)*vec2(1653.21974, 7851653.21974))));
	return r;
}
void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = SCREEN_UV;
	vec2 vu = vec2(uv.y, uv.x);
	vec3 c = textureLod(screen_texture, uv, 0.0).rgb;
	vec3 coff = textureLod(screen_texture, uv+vec2(tearIntensity, 0.0), 0.0).rgb;
	vec3 coffneg = textureLod(screen_texture, uv-vec2(tearIntensity, 0.0), 0.0).rgb;
	//black wipe
	COLOR.rgb = c;
	//red plus horizontal tearing
	random(uv)>=1.0-tearFrequency?COLOR.r=coff.r:COLOR.r=c.r;
	random(uv)<tearFrequency?COLOR.r=coffneg.r:COLOR.r=COLOR.r;
	COLOR.bg = vec2(0.0);
	//black wipe
	//return to statusquo
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
