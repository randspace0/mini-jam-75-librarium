shader_type canvas_item;
// Metaball merge: each droplet adds a falloff field; thresholding the sum fuses nearby drops into one blob.

const int MAX_DROPS = 80;
uniform vec2 drops[MAX_DROPS];
uniform int count = 0;
uniform vec2 rect_size;
uniform float radius = 4.0;
uniform vec4 fill : source_color = vec4(0.0, 0.44, 1.0, 1.0);
uniform vec4 stroke : source_color = vec4(0.016, 0.61, 1.0, 1.0);

void fragment() {
	vec2 p = UV * rect_size;
	float f = 0.0;
	for (int i = 0; i < count; i++) {
		vec2 d = p - drops[i];
		f += radius * radius / (dot(d, d) + 0.5);
	}
	float a = smoothstep(0.7, 0.85, f);
	float inner = smoothstep(1.0, 1.25, f);
	COLOR = vec4(mix(stroke.rgb, fill.rgb, inner), a);
}
