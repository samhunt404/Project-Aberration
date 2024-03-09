shader_type spatial;
uniform sampler2D noise;
varying vec3 localPos;
void vertex() {
	localPos =  abs(-NODE_POSITION_WORLD - (vec4(VERTEX,0.0 ) * INV_VIEW_MATRIX).xyz);
	
	
	
}

void fragment() {
	ALBEDO = COLOR.rgb;
}

void light() {
	// Called for every pixel for every light affecting the material.
}
