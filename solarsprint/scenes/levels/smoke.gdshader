shader_type canvas_item;

uniform float time_speed : hint_range(0.0, 2.0) = 0.5;
uniform float distortion_amount : hint_range(0.0, 0.5) = 0.1;
uniform sampler2D noise_texture;

uniform float fade_amount : hint_range(0.0, 1.0) = 0.0;  // New fade control

void fragment() {
    vec2 uv_distorted = UV;

    // Create wavy movement using noise
    uv_distorted.x += sin(TIME * time_speed + UV.y * 5.0) * distortion_amount;
    uv_distorted.y += cos(TIME * time_speed + UV.x * 5.0) * distortion_amount;

    // Sample the texture with distortion
    vec4 tex_color = texture(TEXTURE, uv_distorted);

    // Fade effect when hit
    tex_color.a *= smoothstep(0.1, 0.9, tex_color.a) * (1.0 - fade_amount);

    COLOR = tex_color;
}
