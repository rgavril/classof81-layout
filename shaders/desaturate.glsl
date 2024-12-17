uniform sampler2D tex;

void main (void)
{
	vec4 texel = texture2D(tex,gl_TexCoord[0].st);
	vec4 color = texel * gl_Color;

	// desaturate
	float lum = (0.299 * color.r) + (0.587 * color.g) + (0.114 * color.b);
	
	// Tint & Bright
	color = vec4(lum, lum, lum, color.a);

	// color += vec4(144/700.0, 172/700.0, 191/700.0, 0);
	color += vec4(1.0/255.0, 28.0/255.0, 47.0/255.0, 0);

	// Increase brightness in dark areas
	if (color.r + color.g + color.b < 0.7) {
		color += vec4(0.2, 0.2, 0.2, 0);
	}
	
    gl_FragColor = color;
}