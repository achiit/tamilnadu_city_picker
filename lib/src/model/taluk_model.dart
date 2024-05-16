class TalukModel {
  final String id;
  final String name;
  final String districtId;

  TalukModel({required this.id, required this.name, required this.districtId});

  factory TalukModel.fromJson(Map<String, dynamic> json) {
    return TalukModel(
      id: json['id'] as String,
      name: json['name'] as String,
      districtId: json['district_id'] as String,
    );
  }
}