import 'dart:convert';

class Device {
  List<DeviceElement>? devices;

  Device({this.devices});

  Device copyWith({List<DeviceElement>? devices}) =>
      Device(devices: devices ?? this.devices);

  factory Device.fromJson(String str) => Device.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Device.fromMap(Map<String, dynamic> json) => Device(
    devices: json["devices"] == null
        ? []
        : List<DeviceElement>.from(
        json["devices"]!.map((x) => DeviceElement.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "devices": devices == null
        ? []
        : List<dynamic>.from(devices!.map((x) => x.toMap())),
  };
}

class DeviceElement {
  final String ip;
  final String mac;
  final String name;
  final bool blocked;
  final bool loading;

  DeviceElement({
    required this.ip,
    required this.mac,
    required this.name,
    required this.blocked,
    this.loading = false,
  });

  /// 🆕 Copy With Method to Update Status
  DeviceElement copyWith({
    String? ip,
    String? mac,
    String? name,
    bool? blocked,
    bool? loading, // ✅ Made optional
  }) =>
      DeviceElement(
        ip: ip ?? this.ip,
        mac: mac ?? this.mac,
        name: name ?? this.name,
        blocked: blocked ?? this.blocked,
        loading: loading ?? this.loading, // ✅ Preserve existing value if null
      );

  /// 🆕 Convert JSON Map to `DeviceElement`
  factory DeviceElement.fromMap(Map<String, dynamic> json) => DeviceElement(
    ip: json["ip"] ?? "Unknown IP",
    mac: json["mac"] ?? "Unknown MAC",
    name: json["name"] ?? "Unknown Device",
    blocked: json["blocked"] ?? false, // ✅ Default false if missing
    loading: json["loading"] ?? false, // ✅ Add loading flag
  );

  /// Convert `DeviceElement` to JSON Map
  Map<String, dynamic> toMap() => {
    "ip": ip,
    "mac": mac,
    "name": name,
    "blocked": blocked,
    "loading": loading, // ✅ Include in JSON
  };
}
