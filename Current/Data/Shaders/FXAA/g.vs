#version 150

in vec4 vPosition;
in vec2 vTexCoord;

out vec2 TexCoord;

void main() {
	TexCoord = vTexCoord;
	gl_Position = vPosition;
}