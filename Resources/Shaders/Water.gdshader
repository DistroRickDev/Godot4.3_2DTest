shader_type canvas_item;

// We use screen texture to render underwater
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
// A noise texture to create distortion effect
uniform sampler2D noise_texture: filter_nearest, repeat_enable;
// Strength of distortion
uniform float distortion = .01;
// Speed of the water waves
uniform vec2 speed = vec2(.5,.2);
// Define strength of the waves
uniform float wave_strength = .1;

void vertex() {
	VERTEX.y += sin(TIME);
}

void fragment() {
	// Get noise value between [-1,1]
	vec2 noise = 2.0 * texture(noise_texture, UV + speed * TIME).rg - vec2(1.0);
	// Sample of the water texture
	COLOR = texture(TEXTURE, UV + noise * wave_strength);
	// Multiply the color with screen texture
	COLOR *= texture(SCREEN_TEXTURE, SCREEN_UV + noise + distortion);
}
