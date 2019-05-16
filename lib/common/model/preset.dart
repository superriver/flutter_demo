class Presets {
  int id;
  int deviceId;
  String presetName;

  Presets.fromJson(Map<String,dynamic> json){
    this.id = json['id'];
    this.deviceId = json['deviceId'];
    this.presetName = json['presetName'];
  }

}
