shader_type canvas_item;

uniform vec4 primary_color : source_color = vec4(0,1,0,1);
uniform vec4 secondary_color : source_color = vec4(0.15,0.5,0.15,1);
uniform vec4 bg_color : source_color = vec4(0.3,0.3,0.3,1);

uniform float progress : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float follow_progress : hint_range(0.0, 1.0, 0.01) = 0.7;

void fragment() {
	float prog = 1.0 - progress;
	float fol_prog = 1.0 - follow_progress;
	vec4 col = texture(TEXTURE, UV);

	float val = (col.r + col.g + col.b)/3.0;

	if (UV.y > prog){
		COLOR = vec4(primary_color.r * val,primary_color.g * val, primary_color.b * val, col.a);
	}else{
		if (UV.y > fol_prog){
			COLOR = vec4(secondary_color.r * val, secondary_color.g * val, secondary_color.b * val, col.a);
		}else{
			COLOR = vec4(bg_color.r * val, bg_color.g * val, bg_color.b * val, col.a);
		}
	}
}

