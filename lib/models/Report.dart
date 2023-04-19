class Report {
  late num reportId;
  late String reportComment;
  late String reportDate;
  late String reportType;
  num? reportScore;
  String? resolutionDate;
  String? reportStatus;
  late double reportLocationLatitude;
  late double reportLocationLongitude;

  Report(
      {required this.reportId,
      required this.reportComment,
      required this.reportDate,
      required this.reportType,
      this.reportScore,
      this.resolutionDate,
      required this.reportLocationLatitude,
      required this.reportLocationLongitude});

  Report.fromJson(Map<String, dynamic> json) {
    reportId = json['reportId'];
    reportComment = json['reportComment'];
    reportDate = json['reportDate'];
    reportScore = json['reportScore'];
    resolutionDate = json['resolutionDate'];
    reportLocationLatitude = json['reportLocationLatitude'];
    reportLocationLongitude = json['reportLocationLongitude'];
    reportType = json['reportType'];
    reportStatus = json['status'];
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
    data['status'] = reportStatus;
    return data;
  }
}
