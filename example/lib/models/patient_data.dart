import "clinics.dart";
import "devices.dart";

class PatientData  {
	List<Clinics>? clinics;
	String? createdAt;
	String? dateOfBirth;
	List<Devices>? devices;
	String? email;
	String? gender;
	String? hcNumber;
	double? height;
	String? heightUnit;
	int? id;
	String? name;
	String? origin;
	double? weight;
	String? weightUnit;

	PatientData({this.clinics, this.createdAt, this.dateOfBirth, this.devices, this.email, this.gender, this.hcNumber, this.height, this.heightUnit, this.id, this.name, this.origin, this.weight, this.weightUnit});

	factory PatientData.fromJson(Map<String, dynamic> json) {
		var clinics =  json['clinics'] as List<dynamic>;
		var devices = json['devices'] as List<dynamic>;
		return PatientData(
			clinics: clinics != null ? clinics.map((v) => new Clinics.fromJson(v)).toList() : null,
			createdAt: json['created_at'],
			dateOfBirth: json['date_of_birth'],
			devices: devices != null ? devices.map((v) => new Devices.fromJson(v)).toList() : null,
			email: json['email'],
			gender: json['gender'],
			hcNumber: json['hc_number'],
			height: json['height'],
			heightUnit: json['height_unit'],
			id: json['id'],
			name: json['name'],
			origin: json['origin'],
			weight: json['weight'],
			weightUnit: json['weight_unit'],
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.clinics!= null) {
      data['clinics'] = this.clinics?.map((v) => v.toJson()).toList();
    }
		data['created_at'] = this.createdAt;
		data['date_of_birth'] = this.dateOfBirth;
		if (this.devices!= null) {
      data['devices'] = this.devices?.map((v) => v.toJson()).toList();
    }
		data['email'] = this.email;
		data['gender'] = this.gender;
		data['hc_number'] = this.hcNumber;
		data['height'] = this.height;
		data['height_unit'] = this.heightUnit;
		data['id'] = this.id;
		data['name'] = this.name;
		data['origin'] = this.origin;
		data['weight'] = this.weight;
		data['weight_unit'] = this.weightUnit;
		return data;
	}


}
