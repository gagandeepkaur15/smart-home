abstract class MQTTEvent {}

class MQTTConnectEvent extends MQTTEvent {}

class MQTTSubscribeEvent extends MQTTEvent {
  final String topic;

  MQTTSubscribeEvent(this.topic);
}

class MQTTPublishEvent extends MQTTEvent {
  final String topic;
  final String message;

  MQTTPublishEvent(this.topic, this.message);
}

class MQTTMessageReceivedEvent extends MQTTEvent {
  final String message;

  MQTTMessageReceivedEvent(this.message);
}
