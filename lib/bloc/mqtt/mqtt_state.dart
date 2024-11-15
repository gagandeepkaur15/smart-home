abstract class MQTTState {
  final List<String> messages; 
  MQTTState([this.messages = const []]); 
}

class MQTTInitialState extends MQTTState {}

class MQTTConnectingState extends MQTTState {}

class MQTTConnectedState extends MQTTState {}

class MQTTSubscribedState extends MQTTState {
  final String topic;

  MQTTSubscribedState(this.topic);
}

class MQTTMessagePublishedState extends MQTTState {
  final String message;

  MQTTMessagePublishedState(this.message);
}

class MQTTMessageReceivedState extends MQTTState {
   MQTTMessageReceivedState(List<String> messages) : super(messages);
}

class MQTTErrorState extends MQTTState {
  final String error;

  MQTTErrorState(this.error);
}
