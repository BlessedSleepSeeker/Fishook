shader_type spatial;
render_mode blend_mix;

uniform float model_height = 2.;
uniform float dissolve_start : hint_range(.0, 1.) = .0;
uniform float dissolve_length : hint_range(.0, 1.) = 1.;
uniform float gradient_bias : hint_range(.1, 5.) = 1.;
varying float vert_height;

void vertex()
{
	vert_height = (VERTEX.y + (model_height / 2.)) / model_height;
}

void fragment() {
	float gradient_height = vert_height - dissolve_start;
	gradient_height *= 1. / (dissolve_length);
	gradient_height = clamp(pow(gradient_height, gradient_bias), 0., 1.);

	ALPHA = mix(1., .0, gradient_height);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
