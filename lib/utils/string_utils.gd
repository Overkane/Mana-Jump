class_name StringUtils
extends Node

# Never set 'full_objects' to true, since it is potentially unsafe cuz of arbitrary code execution.
static func encode_data(value: Variant) -> String:
	return JSON.stringify(JSON.from_native(value), "\t")

# Never set 'allow_objects' to true, since it is potentially unsafe cuz of arbitrary code execution.
static func decode_data(string: String) -> Variant:
	return JSON.to_native(JSON.parse_string(string))
