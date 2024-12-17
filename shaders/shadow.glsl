uniform sampler2D tex;
varying vec2 vTexCoord;

void main (void)
{
	vec4 texel = texture2D(tex,gl_TexCoord[0].st);
	vec4 color = texel * gl_Color;

	// Make all pixels black
	color *= vec4(0, 0, 0, 1);
	color += vec4(0.3,0.3,0.3,0);
	gl_FragColor = color;
	
	// Blur
}