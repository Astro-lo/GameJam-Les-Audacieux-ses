shader_type spatial;
//render_mode unshaded;
uniform sampler2D env;
uniform bool screenMode;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 texture_color;
	if (screenMode) {
		texture_color = texture(env, SCREEN_UV);
	} else {
		texture_color = texture(env, UV);
	}
	ALBEDO = texture_color.xyz;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
