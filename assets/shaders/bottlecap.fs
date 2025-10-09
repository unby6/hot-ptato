#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define PRECISION highp
#else
    #define PRECISION mediump
#endif

extern PRECISION float radius_squared;
extern PRECISION vec4 color;
extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    // Position of a pixel within the sprite
	vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;

    vec2 adjusted_uv = uv - vec2(0.5, 0.5);
    adjusted_uv = adjusted_uv * texture_details.a / texture_details.b; 

    float val = 1 - smoothstep(0., radius_squared, adjusted_uv.x * adjusted_uv.x + adjusted_uv.y * adjusted_uv.y);

    return vec4(color.rgb, color.a * val * 0.8);
}
