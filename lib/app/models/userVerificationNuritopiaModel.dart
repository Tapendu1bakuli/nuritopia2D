class userVerificationNuritopiaModel {
  String? status;
  String? message;

  userVerificationNuritopiaModel({this.status, this.message});

  userVerificationNuritopiaModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
