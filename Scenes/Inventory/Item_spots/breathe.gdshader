shader_type spatial;


uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;
uniform float breathe_speed = 2.0f;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float delta =  sin(TIME * breathe_speed) * 0.5 + 0.5;
	EMISSION = mix(color1, color2, delta).xyz;
	ALPHA = delta * 0.25 + 0.25;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
