shader_type canvas_item;
uniform sampler2D noise: repeat_enable;
uniform float scale = 0.001953125;
uniform float world_cords_scale;
varying vec2 world_position;

void vertex() {
        world_position  = floor( (MODEL_MATRIX * vec4(VERTEX.x, VERTEX.y, 0.0, 1.0)).xy * world_cords_scale) / world_cords_scale;
}

void fragment() {
	vec2 uv = world_position * scale;
	vec4 noise_t = texture(noise, uv);
	vec4 t_rigdes  = texture(TEXTURE, uv * noise_t.rg);
	vec4 t = texture(TEXTURE, UV);
	COLOR.rgb = mix(t.rgb, t.rgb * 4., t_rigdes.r);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
