#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform sampler2D u_fadetex;
uniform sampler2D u_disttex;
uniform float threshold;

void main() {
    vec2 pt = vec2(v_texCoord.x,1.0-v_texCoord.y);

	vec4 color1 = texture2D(CC_Texture0, v_texCoord);
    vec4 color2 = texture2D(u_fadetex, pt);
    vec4 color3 = texture2D(u_disttex, pt);
    if( color2.r > threshold ){
	    gl_FragColor = color1;
    }else{
    	gl_FragColor = color3;
    }
}