shader_type spatial;
//render_mode unshaded;
render_mode shadow_to_opacity;
uniform sampler2D env;
uniform sampler2D brush;
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
	ALBEDO = pow(texture_color.xyz,vec3(2.2f));
	//ALBEDO.r += 2.0;
}

void light() {
	vec2 screenUV = FRAGCOORD.xy / VIEWPORT_SIZE.xy;
	DIFFUSE_LIGHT += ALBEDO * ((length(ATTENUATION) + mix(-0.15, 0.2, texture(brush, screenUV).x)) < 0.2 ? vec3(-0.0) : vec3(1.0));
	//DIFFUSE_LIGHT += LIGHT_COLOR * ALBEDO * ATTENUATION;
	//DIFFUSE_LIGHT = vec3(0.0, 1.0, 0.0) * 100000.0f;
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
}
