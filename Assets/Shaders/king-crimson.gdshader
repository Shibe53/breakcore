shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float tearIntensity;
uniform float tearFrequency;
uniform float bandWidth;
float random(vec2 uv){
	vec3 p3  = fract(vec3(uv.yyy) * 0.1013);
    p3 += dot(p3, p3.yzx + 33.0+fract(TIME)/(2.0*uv.y));
    return fract((p3.x + p3.y) * p3.z);
	//float r=fract((TIME+120.0)*cos((TIME+120.0)*dot(uv, (TIME+120.0)*vec2(1653.21974, 7851653.21974))));
}
void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = SCREEN_UV;
	vec3 c = textureLod(screen_texture, uv, 0.0).rgb;
	vec3 coff = textureLod(screen_texture, uv+vec2(tearIntensity, 0.0), 0.0).rgb;
	vec3 coffneg = textureLod(screen_texture, uv-vec2(tearIntensity, 0.0), 0.0).rgb;
	//black wipe
	COLOR.rgb = c;
	//red plus horizontal tearing
	vec2 dist = mod(uv, vec2(bandWidth, bandWidth)) - (vec2(bandWidth/2.0, bandWidth/2.0));
	uv -= dist;
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
