import 'Threat.dart';

class AdminRecord {
  String id;
  DateTime reportTime;
  DateTime analysePeriodStartTime;
  DateTime analysePeriodEndTime;
  num threatLevel;
  num numberOfThreatRecords;
  List<Threat> listOfThreats;

  AdminRecord(this.id, this.reportTime, this.analysePeriodStartTime, this.analysePeriodEndTime, this.threatLevel,
      this.numberOfThreatRecords, this.listOfThreats);



}
