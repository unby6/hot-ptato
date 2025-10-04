#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define PRECISION highp
#else
    #define PRECISION mediump
#endif

extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    // Position of a pixel within the sprite
	vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/max(texture_details.b, texture_details.a);

    float max_x = texture_details.b / max(texture_details.b, texture_details.a);
    float max_y = texture_details.a / max(texture_details.b, texture_details.a);

    float cutout = 0.015;
    // Cut corners so they don't go outside of ad window when using rounded corners
    if (uv.y > max_y - cutout && (uv.x < cutout || uv.x > max_x - cutout)) {
        return vec4(0);
    }

    return Texel(texture, texture_coords);
}
