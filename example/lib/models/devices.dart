class Devices  {
	String? accessToken;
	String? latestData;
	String? name;
	String? refreshToken;
	String? tokenExpiry;
	String? tokenType;
	int? userId;
	String? userSince;

	Devices({this.accessToken, this.latestData, this.name, this.refreshToken, this.tokenExpiry, this.tokenType, this.userId, this.userSince});

	factory Devices.fromJson(Map<String, dynamic> json) {
		return Devices(
			accessToken: json['access_token'],
			latestData: json['latest_data'],
			name: json['name'],
			refreshToken: json['refresh_token'],
			tokenExpiry: json['token_expiry'],
			tokenType: json['token_type'],
			userId: json['user_id'],
			userSince: json['user_since'],
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['access_token'] = this.accessToken;
		data['latest_data'] = this.latestData;
		data['name'] = this.name;
		data['refresh_token'] = this.refreshToken;
		data['token_expiry'] = this.tokenExpiry;
		data['token_type'] = this.tokenType;
		data['user_id'] = this.userId;
		data['user_since'] = this.userSince;
		return data;
	}


}
