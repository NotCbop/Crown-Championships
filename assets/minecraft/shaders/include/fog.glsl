#version 150

#moj_import <fog_config.glsl>

#ifdef CUSTOM_FOG

vec4 linear_fog(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
    if(fogStart > 2000.0) return inColor;

    const float blindnessSensitivity = 0.05;
    if(length(fogColor.rgb) < blindnessSensitivity) {
        float blindnessIntensity = length(fogColor.rgb) / blindnessSensitivity;
        vertexDistance *= mix(60.0, 1.0, blindnessIntensity);
    }

    vec3 col = mix(FOG_COLOR_START, FOG_COLOR_END, clamp(vertexDistance / FOG_GRADIENT_LENGTH, 0.0, 1.0)) * fogColor.rgb;

    const float waterSensitivity = 0.5;
    if(distance(fogColor.rgb, vec3(0.0, 0.0, 0.7)) < waterSensitivity) {
        vertexDistance *= 5.0;
        col = fogColor.rgb;
    }

    return vec4(mix(col, inColor.rgb, 1.0 - pow(1.0 - pow(0.5, vertexDistance / FOG_HALFWAY_DISTANCE), FOG_RAMP)), inColor.a);
}

float fog_distance(mat4 modelViewMat, vec3 pos, int shape) {
    return length((modelViewMat * vec4(pos, 1.0)).xyz);
}


vec4 linear_fog_vanilla(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
#ifdef OVERRIDE_VANILLA_FOG_COLOR
    fogColor = FOG_COLOR_END;
#endif

    if (vertexDistance <= fogStart) {
        return inColor;
    }

    float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
    return vec4(mix(inColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);
}

float fog_distance_vanilla(mat4 modelViewMat, vec3 pos, int shape) {
    if (shape == 0) {
        return length((modelViewMat * vec4(pos, 1.0)).xyz);
    } else {
        float distXZ = length((modelViewMat * vec4(pos.x, 0.0, pos.z, 1.0)).xyz);
        float distY = length((modelViewMat * vec4(0.0, pos.y, 0.0, 1.0)).xyz);
        return max(distXZ, distY);
    }
}

#else

vec4 linear_fog(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
#ifdef OVERRIDE_VANILLA_FOG_COLOR
    fogColor = FOG_COLOR_END;
#endif

    if (vertexDistance <= fogStart) {
        return inColor;
    }

    float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
    return vec4(mix(inColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);
}

float fog_distance(mat4 modelViewMat, vec3 pos, int shape) {
    if (shape == 0) {
        return length((modelViewMat * vec4(pos, 1.0)).xyz);
    } else {
        float distXZ = length((modelViewMat * vec4(pos.x, 0.0, pos.z, 1.0)).xyz);
        float distY = length((modelViewMat * vec4(0.0, pos.y, 0.0, 1.0)).xyz);
        return max(distXZ, distY);
    }
}

vec4 linear_fog_vanilla(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
    if (vertexDistance <= fogStart) {
        return inColor;
    }

    float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
    return vec4(mix(inColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);
}

float fog_distance_vanilla(mat4 modelViewMat, vec3 pos, int shape) {
    if (shape == 0) {
        return length((modelViewMat * vec4(pos, 1.0)).xyz);
    } else {
        float distXZ = length((modelViewMat * vec4(pos.x, 0.0, pos.z, 1.0)).xyz);
        float distY = length((modelViewMat * vec4(0.0, pos.y, 0.0, 1.0)).xyz);
        return max(distXZ, distY);
    }
}

#endif

float linear_fog_fade(float vertexDistance, float fogStart, float fogEnd) {
    if (vertexDistance <= fogStart) {
        return 1.0;
    } else if (vertexDistance >= fogEnd) {
        return 0.0;
    }

    return smoothstep(fogEnd, fogStart, vertexDistance);
}