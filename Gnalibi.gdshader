shader_type spatial;
uniform vec3 mainColour : source_color;
uniform sampler2D pattern;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = mainColour;
	ROUGHNESS = 1.0;
	METALLIC = 0.0;
	// Called for every pixel the material is visible on.
}
vec2 matcap(vec3 view, vec3 normal ) {
  vec3 reflected = reflect(view, normal);
  float m = 2.8284271247461903 * sqrt( reflected.z+1.0 );
  return reflected.xy / m + 0.5;
}

void light() {
	DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * texture(pattern, matcap(-LIGHT, NORMAL)).x * ATTENUATION * LIGHT_COLOR;
}
