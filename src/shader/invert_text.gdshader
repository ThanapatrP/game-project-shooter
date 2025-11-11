shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	if (texture(TEXTURE, UV).a > 0.0){
		vec4 col = texture(TEXTURE, UV);
		
		COLOR = vec4(col.r - texture(screen_texture, SCREEN_UV).r,
					col.g - texture(screen_texture, SCREEN_UV).g,
					col.b - texture(screen_texture, SCREEN_UV).b,
					1.0);
		
		//COLOR = vec4(1,0,0,1);
	}else{
		COLOR = texture(screen_texture, SCREEN_UV);
	}
}
