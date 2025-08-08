shader_type canvas_item;
uniform sampler2D palette: filter_nearest;
uniform sampler2D offset_textrure: repeat_enable, filter_nearest;
uniform sampler2D noise: repeat_enable, filter_nearest;
uniform float scale = 0.001953125;
uniform float world_cords_scale;
uniform vec2 palette_dimentions;
varying vec2 world_position;


void vertex() {
        world_position  = floor( (MODEL_MATRIX * vec4(VERTEX.x, VERTEX.y, 0.0, 1.0)).xy * world_cords_scale) / world_cords_scale;
}

void fragment() {
 	vec4 t = texture(TEXTURE, UV);
	vec4 noise_t = texture(noise, world_position * scale);
	float offset = texture(offset_textrure, UV).r;
	vec4 p_color = texture(palette, vec2(noise_t.r, offset));
	COLOR.rgb =  offset == 0. ? t.rgb : p_color.rgb;
}

