shader_type canvas_item;
render_mode unshaded;

uniform vec4 new_color : source_color = vec4(1,1,1,1);

void fragment() {
	COLOR = vec4(new_color.r, new_color.g, new_color.g, texture(TEXTURE, UV).a);
}
