#ifdef GL_ES
precision mediump float;
#endif
 
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform float threshold;

void main(void)
{
	vec4 color = texture2D(CC_Texture0, v_texCoord);
	float gray = dot(vec3(color.r,color.g,color.b), vec3(0.299, 0.587, 0.114));

	float r = (1.0-threshold)*color.r + threshold*gray;//mix(color.r,color,threshold);
	float g = (1.0-threshold)*color.g + threshold*gray;//mix(color.g,color,threshold);
	float b = (1.0-threshold)*color.b + threshold*gray;//mix(color.b,color,threshold);

    gl_FragColor = vec4(r,g,b,color.a);
}