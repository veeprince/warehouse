class CheckList {
  String name;
  String jobTitle;
  String deviceDescription;
  String deviceLocation;
  String operatingSystem;
  String serial;
  String year;

  CheckList(this.name, this.jobTitle, this.deviceDescription,
      this.operatingSystem, this.deviceLocation, this.year, this.serial);

  factory CheckList.fromJSON(Map<String, dynamic> json) {
    return CheckList(
      json["name"],
      json["jobTitle"],
      json["deviceDescription"],
      json["operatingSystem"],
      json["deviceLocation"],
      json["year"],
      json["serial"],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "jobTitle": jobTitle,
      "deviceDescription": deviceDescription,
      "deviceLocation": deviceLocation,
      "year": year,
      "operatingSystem": operatingSystem,
      "serial": serial
    };
  }
}
