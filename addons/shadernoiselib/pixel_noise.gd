@tool
extends VisualShaderNodeCustom
class_name VisualShaderNodePixelNoise3D

func _get_name() -> String:
	return "PixelNoise3D"
	
func _get_category():
	return "NoiseLib"

func _get_description():
	return "3D scalable pixel noise"

func _init():
	set_input_port_default_value(0, Vector3.ZERO) # UVW
	set_input_port_default_value(1, Vector3.ZERO) # Offset
	set_input_port_default_value(2, Vector3.ONE * 10) # Scale

func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_SCALAR

func _get_input_port_count():
	return 3

func _get_input_port_name(port):
	match port:
		0: return "uvw"
		1: return "offset"
		2: return "scale"

func _get_input_port_type(port):
	match port:
		0: return VisualShaderNode.PORT_TYPE_VECTOR_3D
		1: return VisualShaderNode.PORT_TYPE_VECTOR_3D
		2: return VisualShaderNode.PORT_TYPE_VECTOR_3D

func _get_output_port_count():
	return 1

func _get_output_port_name(port):
	match port:
		0: return "noise"

func _get_output_port_type(port):
	return VisualShaderNode.PORT_TYPE_SCALAR

func _get_global_code(mode):
	return """
	vec3 pixel_noise_hash_noise_range( vec3 p ) {
		p = mod(p * p.zxy + p.yzx, 96.267); // New pseudo-random step which improves the noise function here
		p = p + p.zxy - p.yzx;
		p *= mat3(vec3(127.1, 311.7, -53.7), vec3(269.5, 183.3, 77.1), vec3(-301.7, 27.3, 215.3));
		return clamp(2.0 * fract(fract(p)*4375.55) -1., -1, 1);
	}
	
	float pixel_noise_sample(vec3 uvw, vec3 scale) {
		uvw = floor(uvw * scale);
		return mod(pixel_noise_hash_noise_range(uvw).x, 1.);
	}
	"""

func _get_code(input_vars, output_vars, mode, type):
	return "%s = pixel_noise_sample(%s + %s, %s);" % [output_vars[0], input_vars[0], input_vars[1], input_vars[2]]
