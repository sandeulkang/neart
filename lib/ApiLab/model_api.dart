import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class APIModel {
  String? title;
  String? alternativeTitle;
  String? creator;
  String? regDate;
  String? collectionDb;
  String? subjectCategory;
  String? subjectKeyword;
  String? extent;
  String? description;
  String? spatial;
  String? temporalCoverage;
  String? person;
  String? language;
  String? sourceTitle;
  String? referenceIdentifier;
  String? rights;
  String? copyrightOthers;
  String? url;
  String? contributor;

  APIModel({
    this.title,
    this.alternativeTitle,
    this.creator,
    this.regDate,
    this.collectionDb,
    this.subjectCategory,
    this.subjectKeyword,
    this.extent,
    this.description,
    this.spatial,
    this.temporalCoverage,
    this.person,
    this.language,
    this.sourceTitle,
    this.referenceIdentifier,
    this.rights,
    this.copyrightOthers,
    this.url,
    this.contributor,
  });

  factory APIModel.fromXml(XmlElement xml){
    return APIModel(
        title: XmlUnits.searchResult(xml, "title"),
        alternativeTitle: XmlUnits.searchResult(xml, "alternativeTitle"),
        creator: XmlUnits.searchResult(xml, "creator"),
        regDate: XmlUnits.searchResult(xml, "regDate"),
        collectionDb: XmlUnits.searchResult(xml, "collectionDb"),
        subjectCategory: XmlUnits.searchResult(xml, "subjectCategory"),
        subjectKeyword: XmlUnits.searchResult(xml, "subjectKeyword"),
        extent: XmlUnits.searchResult(xml, "extent"),
        description: XmlUnits.searchResult(xml, "description"),
        spatial: XmlUnits.searchResult(xml, "spatial"),
        temporalCoverage: XmlUnits.searchResult(xml, "temporalCoverage"),
        person: XmlUnits.searchResult(xml, "person"),
        language: XmlUnits.searchResult(xml, "language"),
        sourceTitle: XmlUnits.searchResult(xml, "sourceTitle"),
        referenceIdentifier: XmlUnits.searchResult(xml, "referenceIdentifier"),
        rights: XmlUnits.searchResult(xml, "rights"),
        copyrightOthers: XmlUnits.searchResult(xml, "copyrightOthers"),
        url: XmlUnits.searchResult(xml, "url"),
        contributor: XmlUnits.searchResult(xml, "contributor"),
    );
  }

}

class XmlUnits {
  static String searchResult(XmlElement xml, String key) {
    return xml.findAllElements(key)
        .map((e) => e.text)
        .isEmpty ? "" : xml
        .findAllElements(key)
        .map((e) => e.text)
        .first;
  }}
