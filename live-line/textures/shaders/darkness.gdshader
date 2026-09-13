shader_type canvas_item;

uniform vec2 light_pos;
uniform float radius = 250.0;

void fragment() {
    // Convert UV to pixel coordinates
    vec2 pixel_pos = UV * SCREEN_PIXEL_SIZE;

    // Distance from light
    float dist = distance(pixel_pos, light_pos);

    // Darkness falloff
    float alpha = smoothstep(radius, radius * 0.5, dist);

    // Output darkness
    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}
