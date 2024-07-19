shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D noise_texture: filter_nearest, repeat_enable;
uniform vec2 speed = vec2(0.3,0.2);
uniform float distortion = 0.01;
uniform float wave_strength = 0.1;
void fragment()
{
	//vec2 screen_uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
	vec2 uv = SCREEN_UV + speed * TIME;
	vec2 noise = texture(noise_texture, uv).rg - vec2(1);
	COLOR = texture(TEXTURE,UV + noise * wave_strength);
	COLOR *= texture(screen_texture, SCREEN_UV + noise * distortion);
}
