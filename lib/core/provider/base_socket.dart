import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:toplearth/app/env/dev/dev_environment.dart';
import 'package:toplearth/data/factory/storage_factory.dart';
import 'package:toplearth/data/provider/common/system_provider.dart';

abstract class BaseWebSocketController extends GetxController {
  final SystemProvider _systemProvider = StorageFactory.systemProvider;

  late final String socketBaseUrl;
  late final String accessToken;

  StompClient? _stompClient;
  final RxBool _isConnected = false.obs;

  RxBool get isConnected => _isConnected;

  @override
  void onInit() {
    super.onInit();
    accessToken = _systemProvider.getAccessToken() ?? '';
    socketBaseUrl = DevEnvironment.SOCKET_SERVER_URL;
    connectToWebSocket();
  }

  /// WebSocket 연결
  void connectToWebSocket() {
    _stompClient = StompClient(
      config: StompConfig(
        url: '$socketBaseUrl/ws-stomp',
        onConnect: _onConnect,
        beforeConnect: _beforeConnect,
        onDisconnect: _onDisconnect,
        onStompError: _onError,
        stompConnectHeaders: _createAuthHeaders(),
        webSocketConnectHeaders: _createAuthHeaders(),
        onWebSocketError: _onWebSocketError,
      ),
    );
    _stompClient?.activate();
  }

  /// 채널 구독
  void subscribeToChannel({
    required String destination,
    required void Function(Map<String, dynamic>) onMessage,
    Map<String, String>? headers,
  }) {
    if (_stompClient == null || !_isConnected.value) {
      debugPrint('WebSocket 연결이 활성화되지 않았습니다.');
      return;
    }

    _stompClient?.subscribe(
      destination: destination,
      headers: {
        ..._createAuthHeaders(),
        ...?headers,
      },
      callback: (frame) {
        if (frame.body == null) {
          debugPrint('바디가 없는 메시지를 수신했습니다.');
          return;
        }

        try {
          final message = json.decode(frame.body!) as Map<String, dynamic>;
          onMessage(message);
        } catch (e) {
          debugPrint('메시지 디코딩 오류: $e');
        }
      },
    );
    debugPrint('채널 구독 성공: $destination');
  }

  /// 메시지 전송
  void sendMessage({
    required String destination,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) {
    if (_stompClient == null || !_isConnected.value) {
      debugPrint('WebSocket 연결이 활성화되지 않았습니다.');
      return;
    }

    _stompClient?.send(
      destination: destination,
      headers: {
        ..._createAuthHeaders(),
        ...?headers,
      },
      body: json.encode(body),
    );
    debugPrint('메시지 전송 성공: $destination');
  }

  /// WebSocket 연결 해제
  @override
  void onClose() {
    _stompClient?.deactivate();
    debugPrint('WebSocket 연결 해제');
    super.onClose();
  }

  /// 인증 헤더 생성
  Map<String, String> _createAuthHeaders() => {
    'Authorization': 'Bearer $accessToken',
  };

  /// 연결 성공 시 호출
  void _onConnect(StompFrame frame) {
    debugPrint('WebSocket 연결 성공');
    _isConnected.value = true;
  }

  /// 연결 시도 중
  Future<void> _beforeConnect() async {
    debugPrint('WebSocket 연결 시도 중...');
  }

  /// 연결 해제 시 호출
  void _onDisconnect(StompFrame frame) {
    debugPrint('WebSocket 연결 해제');
    _isConnected.value = false;
  }

  /// STOMP 에러 처리
  void _onError(StompFrame frame) {
    debugPrint('WebSocket 에러 발생: ${frame.body}');
  }

  /// WebSocket 에러 처리
  void _onWebSocketError(dynamic error) {
    debugPrint('WebSocket 에러: $error');
  }
}

/// WebSocketController 구현 클래스
class WebSocketController extends BaseWebSocketController {
  // 필요 시 추가 구현
}

mixin WebSocketMixin {
  late final String socketServerUrl;
  String get accessToken => StorageFactory.systemProvider.getAccessToken();

  StompClient? _stompClient;
  final RxBool _isConnected = false.obs;

  RxBool get isConnected => _isConnected;

  /// WebSocket 연결
  void connectToWebSocket() {
    final token = accessToken;
    if (token.isEmpty) {
      debugPrint('⚠️ 토큰이 없어 WebSocket 연결을 시도하지 않습니다.');
      return;
    }

    _stompClient = StompClient(
      config: StompConfig(
        url: '$socketServerUrl/ws-stomp',
        onConnect: _onConnect,
        beforeConnect: _beforeConnect,
        onDisconnect: _onDisconnect,
        onStompError: _onError,
        stompConnectHeaders: _createAuthHeaders(),
        webSocketConnectHeaders: _createAuthHeaders(),
        onWebSocketError: _onWebSocketError,
      ),
    );
    _stompClient?.activate();
  }

  /// 채널 구독
  void subscribeToChannel({
    required String destination,
    required void Function(Map<String, dynamic>) onMessage,
    Map<String, String>? headers,
  }) {
    if (_stompClient == null || !_isConnected.value) {
      debugPrint('WebSocket 연결이 활성화되지 않았습니다.');
      return;
    }

    _stompClient?.subscribe(
      destination: destination,
      headers: {
        ..._createAuthHeaders(),
        ...?headers,
      },
      callback: (frame) {
        if (frame.body == null) {
          debugPrint('바디가 없는 메시지를 수신했습니다.');
          return;
        }

        try {
          final message = json.decode(frame.body!) as Map<String, dynamic>;
          onMessage(message);
        } catch (e) {
          debugPrint('메시지 디코딩 오류: $e');
        }
      },
    );
    debugPrint('채널 구독 성공: $destination');
  }

  /// 메시지 전송
  void sendMessage({
    required String destination,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) {
    if (_stompClient == null || !_isConnected.value) {
      debugPrint('WebSocket 연결이 활성화되지 않았습니다.');
      return;
    }

    _stompClient?.send(
      destination: destination,
      headers: {
        ..._createAuthHeaders(),
        ...?headers,
      },
      body: json.encode(body),
    );
    debugPrint('메시지 전송 성공: $destination');
  }

  /// WebSocket 연결 해제
  void deactivateWebSocket() {
    _stompClient?.deactivate();
    debugPrint('WebSocket 연결 해제');
  }

  /// 인증 헤더 생성
  Map<String, String> _createAuthHeaders() {
    final token = accessToken;
    if (token.isEmpty) {
      debugPrint('⚠️ 토큰이 없습니다. 빈 헤더를 반환합니다.');
      return {};
    }
    return {
      'Authorization': 'Bearer $token',
    };
  }

  /// 연결 성공 시 호출
  void _onConnect(StompFrame frame) {
    debugPrint('WebSocket 연결 성공');
    _isConnected.value = true;
  }

  /// 연결 시도 중
  Future<void> _beforeConnect() async {
    debugPrint('WebSocket 연결 시도 중...');
    final token = accessToken;
    if (token.isEmpty) {
      throw Exception('토큰이 없어 WebSocket 연결을 중단합니다.');
    }
  }

  /// 연결 해제 시 호출
  void _onDisconnect(StompFrame frame) {
    debugPrint('WebSocket 연결 해제');
    _isConnected.value = false;
  }

  /// STOMP 에러 처리
  void _onError(StompFrame frame) {
    debugPrint('WebSocket 에러 발생: ${frame.body}');
  }

  /// WebSocket 에러 처리
  void _onWebSocketError(dynamic error) {
    debugPrint('WebSocket 에러: $error');
  }
}
