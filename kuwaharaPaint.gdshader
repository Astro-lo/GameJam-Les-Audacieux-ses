shader_type spatial;
uniform sampler2D diffuseTexture;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform int radius = 2;
uniform vec3 offset=vec3(0.0);
uniform float darkening = 1.0;
void fragment() 
 {
	vec2 screenPixelSize = 1.0/VIEWPORT_SIZE;
     vec2 src_size = vec2 ( screenPixelSize.x,  screenPixelSize.y);
     vec2 uv = UV.xy;
     float n = float((radius + 1) * (radius + 1));
     vec3 m0 = offset; vec3 m1 = offset; vec3 m2 = offset; vec3 m3 = offset;
     vec3 s0 = offset; vec3 s1 = offset; vec3 s2 = offset; vec3 s3 = offset;
     vec3 c;

     for (int j = -radius; j <= 0; ++j)  {
         for (int i = -radius; i <= 0; ++i)  {
             c = texture(diffuseTexture, uv + vec2(float(i),float(j)) * src_size).rgb;
             m0 += c;
             s0 += c * c;
         }
     }

     for (int j = -radius; j <= 0; ++j)  {
         for (int i = 0; i <= radius; ++i)  {
             c = texture(diffuseTexture, uv + vec2(float(i),float(j)) * src_size).rgb;
             m1 += c;
             s1 += c * c;
         }
     }

     for (int j = 0; j <= radius; ++j)  {
         for (int i = 0; i <= radius; ++i)  {
             c = texture(diffuseTexture, uv + vec2(float(i),float(j)) * src_size).rgb;
             m2 += c;
             s2 += c * c;
         }
     }

     for (int j = 0; j <= radius; ++j)  {
         for (int i = -radius; i <= 0; ++i)  {
             c = texture(diffuseTexture, uv + vec2(float(i),float(j)) * src_size).rgb;
             m3 += c;
             s3 += c * c;
         }
     }


     float min_sigma2 = 1e+2;
     m0 /= n;
     s0 = abs(s0 / n - m0 * m0);

     float sigma2 = s0.r + s0.g + s0.b;
     if (sigma2 < min_sigma2) {
         min_sigma2 = sigma2;
         ALBEDO = m0;
     }

     m1 /= n;
     s1 = abs(s1 / n - m1 * m1);

     sigma2 = s1.r + s1.g + s1.b;
     if (sigma2 < min_sigma2) {
         min_sigma2 = sigma2;
         ALBEDO = m1;
     }

     m2 /= n;
     s2 = abs(s2 / n - m2 * m2);

     sigma2 = s2.r + s2.g + s2.b;
     if (sigma2 < min_sigma2) {
         min_sigma2 = sigma2;
         ALBEDO = m2;
     }

     m3 /= n;
     s3 = abs(s3 / n - m3 * m3);

     sigma2 = s3.r + s3.g + s3.b;
     if (sigma2 < min_sigma2) {
         min_sigma2 = sigma2;
         ALBEDO = m3;
     }
	ALBEDO *= darkening;
 }
//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
