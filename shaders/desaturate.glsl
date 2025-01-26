uniform sampler2D tex; // Input texture

void main(void)
{
    vec2 texCoord = gl_TexCoord[0].st; // Texture coordinates of the current fragment
    vec4 texel = texture2D(tex, texCoord); // Sample the texture

    // Desaturate the color
    float luminance = (0.299 * texel.r) + (0.587 * texel.g) + (0.114 * texel.b);
    vec4 desaturatedColor = vec4(luminance, luminance, luminance, texel.a);

    // Brighten dark areas by lifting blacks
    desaturatedColor.rgb += 0.4;

	// Hardcoded tint color for #90ACBF
    vec4 tintColor = vec4(0.5647, 0.6745, 0.7490, 1.0);

    // Apply the tint by multiplying with the tintColor
    vec4 tintedColor = desaturatedColor * tintColor;

    // Increase overall brightnes
    tintedColor.rgb *= 1.2;

    gl_FragColor = tintedColor; // Set the output color
}
