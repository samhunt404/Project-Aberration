shader_type spatial;
render_mode unshaded,blend_mul;

const mat3 sobel_x = mat3(vec3(-1.0,0.0,1.0),
						vec3(-2.0,0.0,2.0),
						vec3(-1.0,0.0,1.0));
						
const mat3 sobel_y = mat3(vec3(-1.0,-2.0,-1.0),
						vec3(0.0,0.0,0.0),
						vec3(1.0,2.0,1.0));
uniform sampler2D depthTex : hint_depth_texture;
uniform sampler2D screenTex : hint_screen_texture;
uniform sampler2D normalTex : hint_normal_roughness_texture;

uniform float sensitivity = 0.25;
uniform float depthControl = 100;
uniform float normControl = 0.4;
uniform float colControl = 1;

void vertex() {
	POSITION = vec4(VERTEX,1.0);
}
float valFromRGB(vec3 col)
{
	return clamp((col.r + col.b + col.g)/3.0,0.0,1.0);
}
float sobel(sampler2D sampler,vec2 coord, vec2 pixSize)
{
	vec3 startColor = textureLod(sampler,coord,0.0).rgb;
	//has sqrt in length function
	float basis =  valFromRGB(startColor);
	float Gx = 0.0;
	float Gy = 0.0;
	//gx sum
	Gx += valFromRGB(textureLod(sampler,coord + vec2(-1.0 * pixSize.x,-1.0 * pixSize.y),0.0).rgb) * sobel_x[0].x;
	Gx += valFromRGB(textureLod(sampler,coord + vec2(0.0,-1.0 * pixSize.y),0.0).rgb) * sobel_x[0].y;
	Gx += valFromRGB(textureLod(sampler,coord + vec2(1.0 * pixSize.x,-1.0 * pixSize.y),0.0).rgb) * sobel_x[0].z;
	Gx += valFromRGB(textureLod(sampler,coord + vec2(-1.0 * pixSize.x,0.0),0.0).rgb) * sobel_x[1].x;
	Gx += valFromRGB(textureLod(sampler,coord + vec2(1.0 * pixSize.x,0.0),0.0).rgb) * sobel_x[1].z;
	Gx += valFromRGB(textureLod(sampler,coord + vec2(-1.0 * pixSize.x,1.0 * pixSize.y),0.0).rgb) * sobel_x[2].x;
	Gx += valFromRGB(textureLod(sampler,coord + vec2(0.0,1.0 * pixSize.y),0.0).rgb) * sobel_x[2].y;
	Gx += valFromRGB(textureLod(sampler,coord + vec2(1.0 * pixSize.x,1.0 * pixSize.y),0.0).rgb) * sobel_x[2].z;
	//gy sums
	Gy += valFromRGB(textureLod(sampler,coord + vec2(-1.0 * pixSize.x,-1.0 * pixSize.y),0.0).rgb) * sobel_y[0].x;
	Gy += valFromRGB(textureLod(sampler,coord + vec2(0.0,-1.0 * pixSize.y),0.0).rgb) * sobel_y[0].y;
	Gy += valFromRGB(textureLod(sampler,coord + vec2(1.0 * pixSize.x,-1.0 * pixSize.y),0.0).rgb) * sobel_y[0].z;
	Gy += valFromRGB(textureLod(sampler,coord + vec2(-1.0 * pixSize.x,0.0),0.0).rgb) * sobel_y[1].x;
	Gy += valFromRGB(textureLod(sampler,coord + vec2(1.0 * pixSize.x,0.0),0.0).rgb) * sobel_y[1].z;
	Gy += valFromRGB(textureLod(sampler,coord + vec2(-1.0 * pixSize.x,1.0 * pixSize.y),0.0).rgb) * sobel_y[2].x;
	Gy += valFromRGB(textureLod(sampler,coord + vec2(0.0,1.0 * pixSize.y),0.0).rgb) * sobel_y[2].y;
	Gy += valFromRGB(textureLod(sampler,coord + vec2(1.0 * pixSize.x,1.0 * pixSize.y),0.0).rgb) * sobel_y[2].z;
	//more square root stuff
	float sob = sqrt((Gx * Gx) + (Gy * Gy));
	return sob;
}

void fragment() {
	float colOutline = (sobel(screenTex,SCREEN_UV,1.0/VIEWPORT_SIZE) * colControl);
	float normOutline = (sobel(normalTex,SCREEN_UV,1.0/VIEWPORT_SIZE) * normControl);
	float depthOutline = (sobel(depthTex,SCREEN_UV,1.0/VIEWPORT_SIZE) * depthControl);
	ALBEDO = vec3(1.0 - max(normOutline,max(colOutline,depthOutline)));
	float x = length(dFdxCoarse((texture(screenTex,SCREEN_UV).rgb)));
	float y = length(dFdyCoarse((texture(screenTex,SCREEN_UV).rgb)));
	ALBEDO = 1.0 - vec3(x + y);
}
//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
