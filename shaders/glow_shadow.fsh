// shaders/glow_sdf.fsh
uniform vec2 resolution;   // Layout resolution (e.g., 1920x1080)
uniform vec2 surface_pos;  // Surface top-left position on screen
uniform vec4 rect;         // Target outer shape bounds [x, y, w, h]
uniform float radius;       // Corner radius + outline thickness (20.0)
uniform float glow_size;    // Max blur radius (40.0)
uniform vec3 glow_color;
uniform float intensity;

float sdRoundedBox(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + vec2(r);
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

void main() {
    // 1. Convert screen gl_FragCoord (bottom-left origin) to layout top-left coordinates
    vec2 screen_pos = vec2(gl_FragCoord.x, resolution.y - gl_FragCoord.y);

    // 2. Map coordinates relative to this surface's top-left origin
    vec2 pos = screen_pos - surface_pos;

    // 3. Center and half-extents of target rounded box
    vec2 center = rect.xy + rect.zw * 0.5;
    vec2 half_size = rect.zw * 0.5;

    // 4. Calculate distance to rounded border
    float d = sdRoundedBox(pos - center, half_size, radius);

    // 5. Fade out beyond the border
    float alpha = 0.0;
    if (d > 0.0) {
        alpha = smoothstep(glow_size, 0.0, d);
        alpha = pow(alpha, 1.5);
    }

    gl_FragColor = vec4(glow_color, alpha * intensity);
}