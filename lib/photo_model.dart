class PhotoDataModel {
  int? photoCount;
  int? lastSerialNo;
  int? serialSeriesStart;
  List<SeriesModel>? seriesList;

  PhotoDataModel(
      {required this.lastSerialNo,
      required this.photoCount,
      required this.serialSeriesStart,
      required this.seriesList});

  PhotoDataModel.fromJson(Map<String, dynamic> json) {
    lastSerialNo = json['lastSerialNo'];
    photoCount = json['photoCount'];
    serialSeriesStart = json['serialSeriesStart'];
    if (json['seriesList'] != null) {
      seriesList = <SeriesModel>[];
      json['seriesList'].forEach((v) {
        seriesList!.add(SeriesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    {
      data['lastSerialNo'] = lastSerialNo;
      data["photoCount"] = photoCount;
      data['serialSeriesStart'] = serialSeriesStart;
      if (seriesList != null) {
        data['seriesList'] = seriesList!.map((v) => v.toJson()).toList();
      }
      return data;
    }
  }
}

class SeriesModel {
  int? startSeries;
  int? endSeries;

  SeriesModel({
    required this.startSeries,
    required this.endSeries,
  });

  SeriesModel.fromJson(Map<String, dynamic> json) {
    startSeries = json['startSeries'];
    endSeries = json['endSeries'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    {
      data['startSeries'] = startSeries;
      data["endSeries"] = endSeries;
      return data;
    }
  }
}
