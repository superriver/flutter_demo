class Data {
  String requestId;
  List<Volume> list;
  Data(this.requestId,this.list);
}

class Volume {
  String intent;
  PlayLoad playLoad;
  Volume(this.intent,this.playLoad);
}

class PlayLoad {
  Device device;
  Execution execution;
  PlayLoad([this.device,this.execution]);
}

class Device {
  String id;
  CustomData customData;
  Device(this.id,this.customData);
}

class CustomData {
  String deviceName;
  String ipAddress;
  CustomData(this.deviceName,this.ipAddress);
}

class Execution {
  String command;
  Params params;
  Execution(this.command,this.params);
}

class Params {
  String operation;
  String controlNum;
  String controlPosition;
  Params(this.operation,this.controlNum,this.controlPosition);
}
