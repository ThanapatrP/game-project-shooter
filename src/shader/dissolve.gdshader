shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform sampler2D noise_tex;
uniform float dissolve_level : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float between_gap : hint_range(0.0, 0.5, 0.1) = 0.1;
uniform vec4 gap_color : source_color;

void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);

	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}

	COLOR *= c;
	
	float _base = 0.0 - between_gap;
	float _ceil = 1.0 + between_gap;
	float _block = 1.0 + between_gap;
	
	float _lower = clamp(_base + (dissolve_level * _block), 0.0, 1.0);
	float _upper = clamp(dissolve_level * _block, 0.0, 1.0);
	
	vec4 noise_col = texture(noise_tex, UV);
	
	if (noise_col.r > _upper){
		COLOR = vec4(0,0,0,0);
	}else if(noise_col.r > _lower){
		COLOR = vec4(gap_color.r, gap_color.g, gap_color.b, gap_color.a);
	}
}

