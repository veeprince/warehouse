class Device {
  final String name,
      jobTitle,
      serial,
      deviceLocation,
      deviceDescription,
      operatingSystem,
      year;

  Device(
      {required this.name,
      required this.serial,
      required this.deviceLocation,
      required this.deviceDescription,
      required this.operatingSystem,
      required this.year,
      required this.jobTitle});
}
