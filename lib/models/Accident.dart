class Accident {
  late num accidentId;
  late String accidentType;
  late double accidentLocationLatitude;
  late double accidentLocationLongitude;
  late String accidentDate;
  late int numInjuries;
  late num locationId;


  Accident(
      {required this.accidentId,
        required this.accidentType,
        required this.accidentLocationLatitude,
        required this.accidentLocationLongitude,
        required this.accidentDate,
        required this.numInjuries,
        required this.locationId});

  Accident.fromJson(Map<String, dynamic> json) {
    accidentId = json['accidentId'];
    accidentType = json['accidentType'];
    accidentLocationLatitude = json['accidentLocationLat'];
    accidentLocationLongitude = json ['accidentLocationLong'];
    accidentDate = json['accidentTime'];
    numInjuries = json['numInjuries'];
    locationId = json['locationId'];
  }
}

