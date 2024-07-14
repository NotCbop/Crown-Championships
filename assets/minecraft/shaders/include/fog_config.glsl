// comment out the line below to disable the custom fog
//#define CUSTOM_FOG

// enable the line below to override the vanila fog color (which still gets used on the skybox and the clouds)
//#define OVERRIDE_VANILLA_FOG_COLOR


// halfway distance of the fog, higher values = weaker fog
#define FOG_HALFWAY_DISTANCE 45

// the ramp of the fog, higher values make the fog transition happen faster and further away
#define FOG_RAMP 4.5

// the length of the fog gradient in blocks
#define FOG_GRADIENT_LENGTH 120.0

// the color of the fog at the player's position
#define FOG_COLOR_START vec3(0.7, 1.0, 0.8)

// the color of the fog at the end of the gradient
#define FOG_COLOR_END vec3(0.5, 0.7, 1.0)