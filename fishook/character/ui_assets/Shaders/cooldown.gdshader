shader_type canvas_item;

uniform vec4 cooldown_color: source_color = vec4(0.3, 0.3, 0.3, 0.5);
uniform float percent: hint_range(0, 1) = 1;
uniform bool affect_alpha = true;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (UV.y > percent) {
		COLOR.rgb = cooldown_color.rgb;
		if (COLOR.a > percent && affect_alpha == true) {
			COLOR.a = percent;
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
