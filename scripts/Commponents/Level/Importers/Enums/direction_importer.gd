extends LdtkEnumImporter

func from_string(s: String) -> Variant:
	return Direction.string_to_direction(s)
