
class IpAddress {

  bool hasAddress;

  String part1;
  String part2;
  String part3;
  String part4;
  String port;

  IpAddress(this.part1, this.part2, this.part3, this.part4, this.port, {this.hasAddress = false});

  factory IpAddress.fromString(String ipAddress) {
    List<String> parts = ipAddress.split(':');
    if (parts.length != 2) {
      return IpAddress("127", "0", "0", "1", "4567");
    }
    String port = parts[1];
    parts = parts[0].split('.');
    if (parts.length != 4) {
      return IpAddress("127", "0", "0", "1", "4567");
    }
    return IpAddress(parts[0], parts[1], parts[2], parts[3], port, hasAddress: true);
  }

  String toString() {
    return '$part1.$part2.$part3.$part4:$port';
  }

}
