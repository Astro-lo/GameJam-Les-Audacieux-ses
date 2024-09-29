shader_type spatial;
//render_mode unshaded;
render_mode shadow_to_opacity;
uniform sampler2D envRight;
uniform sampler2D envLeft;
uniform sampler2D brush;
uniform bool screenMode;
uniform bool roomSideLeft;
uniform bool secondUVSet;
uniform float gamma = 2.2;
#define FlickerSpeed 5.0
#define FlickerIntensity 0.34

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
	ALBEDO = pow(texture_color.xyz,vec3(gamma));
	//ALBEDO = vec3(sin(meshuvset.x * 255.0), sin(meshuvset.y*255.0f), 0.0f);
}

vec2 matcap(vec3 normal, vec3 view) {
  vec3 reflected = reflect(view, normalize(normal));
  float m = 2.8284271247461903 * sqrt( reflected.z+1.0 );
  return reflected.xy / m + 0.5;
}
// stolen from https://thebookofshaders.com/11/
float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}
float noise (float inp) {
	vec2 st = vec2(inp, inp);
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

void light() {
	float matcapSample = texture(brush, matcap(NORMAL, abs(LIGHT))).x * mix(0.14, FlickerIntensity, sin(noise(TIME*FlickerSpeed)));
	float matcapin = mix(0.0, 0.4, matcapSample);
	matcapin += smoothstep(0.0, 0.50, matcapin);
	float stylisedDot = clamp(dot(NORMAL, LIGHT) - matcapin, 0.0, 1.0);
	DIFFUSE_LIGHT += stylisedDot * ATTENUATION * LIGHT_COLOR;
}
