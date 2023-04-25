
///Associations are what our locations are in the database
class Association {
  //Based on zipcode
  late num associationId;
  //The weight of an association
  late int intensity;

  Association({
    required this.associationId,
    required this.intensity,
  });

  Association.fromJson(Map<String, dynamic> json) {
    associationId = json['locationId'];
    intensity = json['intensityScore'];
  }
}

