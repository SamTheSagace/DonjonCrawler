class_name StatusType

enum List {
	NONE,
	POISON,
	FROST,
	FIRE,
	LIGHTNING,
	SLICE
}


static func get_statuses_string(statuses: Array[StatusDefinition]) -> String:
	var names: Array[String] = []
	for status in statuses:
		names.append(str(status.type))
	return ", ".join(names)