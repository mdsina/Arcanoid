uniform sampler2D image;
const vec3 LUMINANCE_WEIGHTS = vec3(0.27, 0.67, 0.06);

void main(void)
{
	vec3 col = texture2D (image, gl_TexCoord[0].xy).xyz;

	float lum = dot(LUMINANCE_WEIGHTS,col);
	gl_FragColor = vec4(lum,lum,lum,1.0);
}