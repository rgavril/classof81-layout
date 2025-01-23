uniform sampler2D tex; // Input texture (sprite)

void main(void)
{
    vec2 texCoord = gl_TexCoord[0].st; // Texture coordinates of the current fragment
    vec4 texel = texture2D(tex, texCoord); // Sample the texture

    // If the pixel is not transparent, convert to black
    if (texel.a > 0.0) 
    {
        // Set the color to gray while preserving alpha (transparency)
        // texel.rgb = vec3(100.0 / 255.0, 100.0 / 255.0, 100.0 / 255.0);
        
       	// Dark yellow
        texel.rgba = vec4(0.4, 0.4, 0.4, 0.3);
    }

    // Output the final color (black with original transparency)
    gl_FragColor = texel;
}
