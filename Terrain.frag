#version 330

uniform sampler2D waterTexture;
uniform sampler2D grassTexture;
uniform sampler2D snowTexture;
uniform bool wireframe;
uniform bool fog;

in vec4 textureWeights;
in vec2 texCoord;
in vec4 lightColour;

in float fogIntensity;

void main()
{
    vec4 waterTexColor = texture(waterTexture, texCoord) * textureWeights.x;
    vec4 grassTexColor = texture(grassTexture, texCoord) * textureWeights.y;
    vec4 snowTexColor = texture(snowTexture, texCoord) * textureWeights.z;
    
    if (wireframe) {
        gl_FragColor = vec4(0, 0, 1, 1);
    } else {
        gl_FragColor = lightColour *(waterTexColor + grassTexColor + snowTexColor);
    }

    if (fog) {
        vec4 fogColor = vec4(255/242, 255/248, 255/247, 1);
        gl_FragColor = mix(gl_FragColor, fogColor, fogIntensity);
    }
}
