#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec4 normal;

out vec4 lightMapValue;
out vec4 normalLightValue;

flat out int hideVertex;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    hideVertex = 0;

    // Check if the camera pitch is pointing down.
    if(IViewRotMat[2][1] > -0.3) {
        float distToCamera = gl_Position.w;

        // Fast distance check from camera using view space.
        if(distToCamera <= 1.4) {
            hideVertex = 1;
        }

        if(IViewRotMat[2][1] > 0.9 && distToCamera <= 1.55) {
            hideVertex = 1;
        }
    }

    vertexDistance = fog_distance(ModelViewMat, Position, FogShape);

    vertexColor = Color;
    lightMapValue = texelFetch(Sampler2, UV2 / 16, 0);
    normalLightValue = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, vec4(1.0));

    texCoord0 = UV0;
    texCoord1 = UV1;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
