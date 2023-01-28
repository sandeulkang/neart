

class JsonModel {
  String alternativeTitle;
  String charge;
  String collectionDb;
  String contributor;
  String creator;
  String copyrightOthers;
  String description;
  String eventPeriod;
  String extent;
  String grade;
  String language;
  String person;
  String referenceIdentifier;
  String sourceTitle;
  String regDate;
  String rights;
  String spatial;
  String subjectCategory;
  String subjectKeyword;
  String temporalCoverage;
  String title;
  String url;
  String venue;

  JsonModel({
    required this.alternativeTitle,
    required this.charge,
    required this.collectionDb,
    required this.contributor,
    required this.copyrightOthers,
    required this.creator,
    required this.description,
    required this.eventPeriod,
    required this.extent,
    required this.grade,
    required this.language,
    required this.person,
    required this.referenceIdentifier,
    required this.regDate,
    required this.rights,
    required this.sourceTitle,
    required this.spatial,
    required this.subjectCategory,
    required this.subjectKeyword,
    required this.temporalCoverage,
    required this.title,
    required this.url,
    required this.venue
  });


  factory JsonModel.fromJson(Map<String, dynamic> json) {
    return JsonModel(
      alternativeTitle: json['alternativeTitle'],
      charge: json['charge'],
      collectionDb: json['collectionDb'],
      contributor: json['contributor'],
      copyrightOthers: json['copyrightOthers'],
      creator: json['creator'],
      description: json['description'],
      eventPeriod: json['eventPeriod'],
      extent: json['extent'],
      grade: json['grade'],
      language: json['language'],
      person: json['person'],
      referenceIdentifier: json['referenceIdentifier'],
      regDate: json['regDate'],
      rights: json['rights'],
      sourceTitle: json['sourceTitle'],
      spatial: json['spatial'],
      subjectCategory: json['subjectCategory'],
      subjectKeyword: json['subjectKeyword'],
      temporalCoverage: json['temporalCoverage'],
      title: json['title'],
      url: json['url'],
      venue: json['venue'],
    );
  }

}
