shader_type spatial;
render_mode unshaded;

uniform sampler2D screenTex : hint_screen_texture;
void vertex() {
	POSITION = vec4(VERTEX,1.0);
}

void fragment() {
	vec2 p = 1.0/VIEWPORT_SIZE;
	
	vec3 ul = texture(screenTex,SCREEN_UV + vec2(1,1) * p).rgb;
	vec3 u = texture(screenTex,SCREEN_UV + vec2(0,1) * p).rgb;
	vec3 ur = texture(screenTex,SCREEN_UV + vec2(-1,1) * p).rgb;
	vec3 l = texture(screenTex,SCREEN_UV + vec2(1,0) * p).rgb;
	vec3 base = texture(screenTex,SCREEN_UV).rgb;
	vec3 r = texture(screenTex,SCREEN_UV + vec2(-1,0) * p).rgb;
	vec3 dl = texture(screenTex,SCREEN_UV + vec2(1,-1) * p).rgb;
	vec3 d = texture(screenTex,SCREEN_UV + vec2(0,-1) * p).rgb;
	vec3 dr = texture(screenTex,SCREEN_UV + vec2(-1,-1) * p).rgb;
	
	vec3 avg = (ul + u + ur + l + r + dl + d + dr + base)/vec3(9,9,9);
	
	ALBEDO = avg;
	
	
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
