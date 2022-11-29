import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'constants.dart' as Constants;
import 'models.dart';

class MQTTBrowserWrapper {
  int numberOfConnections = 0;
  late MqttBrowserClient client;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  final VoidCallback onConnectedCallback;
  final Function(String) onMessageArrived;
  late Function(String) onSubscribedTopic;

  MQTTBrowserWrapper(this.onConnectedCallback, this.onMessageArrived);

  Future<void> prepareMqttClient(String topic) async {
    numberOfConnections++;
    if (numberOfConnections >= 3) {
      print('Over retry times');
      return;
    }
    _setupMqttClient();
    await _connectClient();
    _subscribeToTopic(topic);
  }

  void publishMessage(String topic, String message) {
    _publishMessage(topic, message);
  }

  Future<void> _connectClient() async {
    try {
      print('MQTTClientWrapper::Client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect();
    } on Exception catch (e) {
      print('MQTTClientWrapper::client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('MQTTClientWrapper::client connected');
    } else {
      print(
          'MQTTClientWrapper::client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    client = MqttBrowserClient(Constants.serverUri, "client_id");
    client.port = Constants.port;
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void subscribe(String topic, Function(String) onSubscribeTopic) {
    print('MQTTClientWrapper::Subscribing to the $topic topic');
    client.subscribe(topic, MqttQos.atMostOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print("MQTTClientWrapper::GOT A NEW MESSAGE $message");
      if (message != null) {
        onSubscribeTopic(message);
      }
      // LocationData newLocationData = _convertJsonToLocation(message);
      // if (newLocationData != null) onLocationReceivedCallback(newLocationData);
    });
  }

  void _subscribeToTopic(String topicName) {
    print('MQTTClientWrapper::Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atMostOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print("MQTTClientWrapper::GOT A NEW MESSAGE $message");
      if (message != null) {
        onMessageArrived(message);
      }
      // LocationData newLocationData = _convertJsonToLocation(message);
      // if (newLocationData != null) onLocationReceivedCallback(newLocationData);
    });
  }

  void _publishMessage(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('MQTTClientWrapper::Publishing message $message to topic $topic');
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void _onSubscribed(String topic) {
    print('MQTTClientWrapper::Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print(
        'MQTTClientWrapper::OnDisconnected client callback - Client disconnection');
    // if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
    //   print(
    //       'MQTTClientWrapper::OnDisconnected callback is solicited, this is correct');
    // }
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print(
        'MQTTClientWrapper::OnConnected client callback - Client connection was sucessful');
    onConnectedCallback();
  }
}
