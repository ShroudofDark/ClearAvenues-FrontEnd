class Report {
  num? reportId;
  String? reportComment;
  String? reportDate;
  num? reportScore;
  String? resolutionDate;
  double? reportLocationLatitude;
  double? reportLocationLongitude;

  Report(
      {this.reportId,
      this.reportComment,
      this.reportDate,
      this.reportScore,
      this.resolutionDate,
      this.reportLocationLatitude,
      this.reportLocationLongitude});

  Report.fromJson(Map<String, dynamic> json) {
    reportId = json['reportId'];
    reportComment = json['reportComment'];
    reportDate = json['reportDate'];
    reportScore = json['reportScore'];
    resolutionDate = json['resolutionDate'];
    reportLocationLatitude = json['reportLocationLatitude'];
    reportLocationLongitude = json['reportLocationLongitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['reportId'] = reportId;
    data['reportComment'] = reportComment;
    data['reportDate'] = reportDate;
    data['reportScore'] = reportScore;
    data['resolutionDate'] = resolutionDate;
    data['reportLocationLatitude'] = reportLocationLatitude;
    data['reportLocationLongitude'] = reportLocationLongitude;
    return data;
  }
}
