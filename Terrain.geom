#version 400

layout (triangles) in;
layout (triangle_strip, max_vertices = 3) out;

uniform mat4 mvpMatrix;
uniform mat4 mvMatrix;
uniform mat4 norMatrix;
uniform vec4 lightPos;
uniform float waterLevel;
uniform float snowLevel;
uniform bool fog;

out vec3 textureWeights;
out vec2 texCoord;
out vec4 lightColour;
out float fogIntensity;

void main()
{
	float dmax = 5;

	vec4 pos[3];

	for (int i = 0; i < 3; i++) 
    {
        pos[i] = gl_in[i].gl_Position;
        if (pos[i].y < waterLevel){
            pos[i].y = waterLevel;
		}
    }

	vec3 u = pos[0].xyz - pos[2].xyz;
	vec3 v = pos[1].xyz - pos[2].xyz;
	vec4 normal = vec4(normalize(cross(u, v)), 0);
    
    for (int i=0; i< gl_in.length(); i++) {

		if (fog) {
            fogIntensity = exp(-pow(length(vec3(pos[i].x, pos[i].y - 50.0, pos[i].z) * 0.01), 1.3));
            fogIntensity = clamp(fogIntensity, 0.0, 1.0);
        } else {
            fogIntensity = 0.0;
        }

		vec4 oldPos = gl_in[i].gl_Position;
		float ambient = 0.3;

        if (pos[i].y == waterLevel) {
            textureWeights = vec3(1, 0, 0);
			ambient = 0.7;
        } else if (pos[i].y > snowLevel) {
            textureWeights = vec3(0, 1, 0);
        } else if (pos[i].y >= snowLevel - 1) { 
		    float grassWeight = snowLevel - pos[i].y;
			float snowWeight = 1-grassWeight;
		    textureWeights = vec3(0, snowWeight, grassWeight);
		} else {
            textureWeights = vec3(0, 0, 1);
        }
		
		vec4 posEye = mvMatrix * pos[i];
		vec4 norEye = norMatrix * normal;
		vec4 light = normalize(lightPos - posEye); 

		vec4 specular = vec4(1.0) *  pow(max(dot(normalize(light + normalize(vec4( -posEye.xyz, 0))), norEye), 0), 100) * textureWeights.x;		
		float diffuse = max(dot(light, norEye), 0);   
		lightColour = vec4(min(ambient + diffuse + specular - ((pos[i].y - oldPos.y) / dmax), 1.0));

		float xmin = -45, xmax = +45, zmin = 0, zmax = -100;
		texCoord.s = (pos[i].x - xmin) / (xmax - xmin);
		texCoord.t = (pos[i].z - zmin) / (zmax - zmin);

		gl_Position = mvpMatrix * pos[i];
		EmitVertex();	
	}
	EndPrimitive();
}

