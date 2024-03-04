shader_type spatial;
render_mode ambient_light_disabled;
uniform sampler2D color;
uniform vec3 shadowCol : source_color;
uniform sampler2D bump : hint_normal;
uniform int bands = 3;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(color,UV).rgb;
	NORMAL_MAP = texture(bump,UV).rgb;
}

void light() {
	
	vec3 posterizedLight = clamp(dot(NORMAL, LIGHT) * ATTENUATION * LIGHT_COLOR, 0.0, 1.0);
	posterizedLight.x = floor(posterizedLight.x * float(bands))/float(bands);
	posterizedLight.y = floor(posterizedLight.y * float(bands))/float(bands);
	posterizedLight.z = floor(posterizedLight.z * float(bands))/float(bands);
	DIFFUSE_LIGHT += shadowCol;
	DIFFUSE_LIGHT += posterizedLight;
}
