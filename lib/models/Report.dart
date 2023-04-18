class Report {
  num? reportId;
  String? reportComment;
  String? reportDate;
  String? reportType;
  num? reportScore;
  String? resolutionDate;
  double? reportLocationLatitude;
  double? reportLocationLongitude;

  Report(
      {this.reportId,
      this.reportComment,
      this.reportDate,
      this.reportType,
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
    reportType = json['reportType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reportId'] = reportId;
    data['reportComment'] = reportComment;
    data['reportDate'] = reportDate;
    data['reportScore'] = reportScore;
    data['resolutionDate'] = resolutionDate;
    data['reportLocationLatitude'] = reportLocationLatitude;
    data['reportLocationLongitude'] = reportLocationLongitude;
    data['reportType'] = reportType;
    return data;
  }
}
