class Clinics  {
	int? id;
	String? name;

	Clinics({this.id, this.name});

	factory Clinics.fromJson(Map<String, dynamic> json) {
		return Clinics(
			id: json['id'],
			name: json['name'],
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['name'] = this.name;
		return data;
	}


}
