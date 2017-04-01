attribute vec3 a_Position;
attribute vec2 a_TexCoord;

uniform mat4 MVPMatrix;

varying lowp vec2 v_TexCoord;

void main()
{
    v_TexCoord = a_TexCoord;
    vec4 pos = vec4(a_Position, 1.0);
    gl_Position = MVPMatrix * pos;
}
