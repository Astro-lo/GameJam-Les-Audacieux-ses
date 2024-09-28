shader_type spatial;
//render_mode unshaded;
render_mode shadow_to_opacity;
uniform sampler2D envRight;
uniform sampler2D envLeft;
uniform sampler2D brush;
uniform bool screenMode;
uniform bool roomSideLeft;
uniform bool secondUVSet;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 texture_color = vec4(1.0f);
	vec2 meshuvset = secondUVSet ? UV2 : UV;
	vec2 uv = screenMode ? SCREEN_UV : meshuvset;
	vec4 sampleLeft = texture(envLeft, uv);
	vec4 sampleRight = texture(envRight, uv);

	texture_color = roomSideLeft ? sampleLeft : sampleRight;
	ALBEDO = pow(texture_color.xyz,vec3(2.2f));
}

void light() {
	vec2 screenUV = FRAGCOORD.xy / VIEWPORT_SIZE.xy;
	DIFFUSE_LIGHT += ALBEDO * ((length(ATTENUATION) + mix(-0.15, 0.2, texture(brush, screenUV).x)) < 0.2 ? vec3(-0.0) : vec3(1.0));
}
