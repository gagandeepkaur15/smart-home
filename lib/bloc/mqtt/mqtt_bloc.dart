import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/bloc/mqtt/mqtt_event.dart';
import 'package:smart_home/bloc/mqtt/mqtt_state.dart';
import 'package:smart_home/services/mqtt.dart';

class MQTTBloc extends Bloc<MQTTEvent, MQTTState> {
  final MQTTService mqttService;

  MQTTBloc(this.mqttService) : super(MQTTInitialState()) {
    on<MQTTConnectEvent>((event, emit) async {
      emit(MQTTConnectingState());
      try {
        await mqttService.connect();
        emit(MQTTConnectedState());
        emit(MQTTConnectedState());
      } catch (e) {
        emit(MQTTErrorState(e.toString()));
      }
    });

    on<MQTTSubscribeEvent>((event, emit) {
      mqttService.subscribe(event.topic);
      emit(MQTTSubscribedState(event.topic));
      mqttService.messagesStream.listen((message) {
        add(MQTTMessageReceivedEvent(message));
      });
    });

    on<MQTTMessageReceivedEvent>((event, emit) {
      final currentMessages = state is MQTTMessageReceivedState
      ? state.messages
      : [];
      final updatedMessages = List<String>.from(currentMessages)..add(event.message);
       emit(MQTTMessageReceivedState(updatedMessages));
    });

    on<MQTTPublishEvent>((event, emit) {
      mqttService.publish(event.topic, event.message);
      emit(MQTTMessagePublishedState(event.message)); 
    });
  }
}
