import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  final String broker = 'test.mosquitto.org';
  final int port = 1883;
  final String clientId =
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}';

  late MqttServerClient client;
  final StreamController<String> _messagesController =
      StreamController.broadcast();

  Stream<String> get messagesStream => _messagesController.stream;

  Future<void> connect() async {
    client = MqttServerClient(broker, clientId);
    client.port = port;
    client.logging(on: true);
    client.keepAlivePeriod = 120;
    client.autoReconnect = true;
    client.onConnected = () => print('Connected to MQTT broker');
    client.onDisconnected = () => print('Disconnected from MQTT broker');
    client.onAutoReconnect = () => print('Reconnecting...');
    client.onAutoReconnected = () => print('Reconnected to broker');
    client.onSubscribed =
        (String topic) => print('Subscribed to topic: $topic');

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .keepAliveFor(120)
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;

    try {
      print('Connecting to MQTT broker...');
      await client.connect();
      print('Connected successfully to $broker:$port');
    } catch (e) {
      print('MQTT connection failed: $e');
      disconnect();
    }
  }

  void disconnect() {
    client.disconnect();
    _messagesController.close();
  }

  void subscribe(String topic) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      const topic = 'test/topic';
      client.subscribe(topic, MqttQos.atMostOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final MqttPublishMessage message =
            messages[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        print('Received message: $payload from topic: ${messages[0].topic}');
      });
    } else {
      print('MQTT client not connected');
    }
  }

  void publish(String topic, String message) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
      print('Message published to $topic: $message');
    } else {
      print('MQTT client not connected');
      client.disconnect();
    }
  }
}
