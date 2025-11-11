shader_type canvas_item;

uniform vec4 outline_col : source_color = vec4(1,1,1,1);
uniform bool outline = true;
uniform vec4 new_col : source_color = vec4(1,1,1,1);
uniform bool colorize = false;

uniform vec2 size = vec2(32,32);

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	vec2 pix_size = vec2(1.0/size.x, 1.0/size.y);
	
	if (colorize){
		COLOR = vec4(new_col.r, new_col.g, new_col.b, texture(TEXTURE, UV).a);
	}
	
	if (outline){
		if ((texture(TEXTURE, UV + vec2(pix_size.x, 0.0)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(-pix_size.x, 0.0)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(0.0, pix_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(0.0, -pix_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(pix_size.x, pix_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(-pix_size.x, pix_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(pix_size.x, -pix_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(-pix_size.x, -pix_size.y)).a > 0.0) && col.a == 0.0){
			COLOR = outline_col;
		}
	}
	
}
