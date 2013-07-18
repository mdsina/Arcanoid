uniform sampler2D BlurSampler;

void main(void)
{
	vec4 color = texture2D(BlurSampler, gl_TexCoord[0].xy);
	gl_FragColor = color;
}