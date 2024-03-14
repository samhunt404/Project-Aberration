shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture;
void vertex() {
	POSITION = vec4(VERTEX,1.0);
}
float valFromRGB(vec3 col)
{
	return (col.r + col.b + col.g)/3.0;
}
float findOutline(sampler2D tex, float dis,vec2 uv,vec2 pixelSize)
{
	vec3 base = texture(tex,uv).rgb;
	vec3 h1 = texture(tex,uv + (vec2(-1,0) * dis * pixelSize)).rgb;
	vec3 h2 = texture(tex,uv + (vec2(-0.5,1) * dis * pixelSize)).rgb;
	vec3 h3 = texture(tex,uv + (vec2(0.5,1) * dis * pixelSize)).rgb;
	vec3 h4 = texture(tex,uv + (vec2(1,0) * dis * pixelSize)).rgb;
	vec3 h5 = texture(tex,uv + (vec2(0.5,-1) * dis * pixelSize)).rgb;
	vec3 h6 = texture(tex,uv + (vec2(-0.5,-1) * dis * pixelSize)).rgb;
	
	float maxDif = max(max(max(distance(base,h1) , 
				distance(base,h2) ), 
				max(distance(base,h3) , 
				distance(base,h4)) ),
				max(distance(base,h5) ,
				distance(base,h6)));
	return maxDif;
}
void fragment() {
	float outline = (findOutline(screen_texture,2,SCREEN_UV,1.0/VIEWPORT_SIZE));
	ALBEDO = min(texture(screen_texture,SCREEN_UV).rgb, vec3(1.0 - clamp(outline * outline * 10.0,0.0,1.0)));
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
