import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toplearth/data/provider/common/system_provider.dart';

class SystemProviderImpl implements SystemProvider {
  SystemProviderImpl({
    required GetStorage normalStorage,
    required FlutterSecureStorage secureStorage,
  })  : _normalStorage = normalStorage,
        _secureStorage = secureStorage;

  final GetStorage _normalStorage;
  final FlutterSecureStorage _secureStorage;

  String? _accessToken;
  String? _refreshToken;
  String? _fcmToken;

  /* ------------------------------------------------------------ */
  /* Initialize ------------------------------------------------- */
  /* ------------------------------------------------------------ */
  @override
  Future<void> onInit() async {
    await _normalStorage.writeIfNull(SystemProviderExt.isFirstRun, true);

    _accessToken = await _secureStorage.read(
      key: SystemProviderExt.accessToken,
    );
    _refreshToken = await _secureStorage.read(
      key: SystemProviderExt.refreshToken,
    );
    _fcmToken = await _secureStorage.read(
      key: SystemProviderExt.fcmToken,
    );
  }

  @override
  Future<void> allocateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(
      key: SystemProviderExt.accessToken,
      value: accessToken,
    );
    await _secureStorage.write(
      key: SystemProviderExt.refreshToken,
      value: refreshToken,
    );

    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  @override
  Future<void> deallocateTokens() async {
    await _secureStorage.delete(key: SystemProviderExt.accessToken);
    await _secureStorage.delete(key: SystemProviderExt.refreshToken);
    await _secureStorage.delete(key: SystemProviderExt.fcmToken);

    _accessToken = null;
    _refreshToken = null;
    _fcmToken = null;
  }

  /* ------------------------------------------------------------ */
  /* Default ---------------------------------------------------- */
  /* ------------------------------------------------------------ */
  @override
  bool get isLogin => _accessToken != null && _refreshToken != null;

  /* ------------------------------------------------------------ */
  /* Getter ----------------------------------------------------- */
  /* ------------------------------------------------------------ */
  @override
  bool getFirstRun() {
    return _normalStorage.read(SystemProviderExt.isFirstRun)!;
  }

  @override
  String getAccessToken() {
    return _accessToken!;
  }

  @override
  String getRefreshToken() {
    return _refreshToken!;
  }

  @override
  String? getFCMToken() {
    return _fcmToken;
  }

  /* ------------------------------------------------------------ */
  /* Setter ----------------------------------------------------- */
  /* ------------------------------------------------------------ */
  @override
  Future<void> setFirstRun(bool isFirstRun) async {
    await _normalStorage.write(SystemProviderExt.isFirstRun, isFirstRun);
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    await _secureStorage.write(
      key: SystemProviderExt.accessToken,
      value: accessToken,
    );

    _accessToken = accessToken;
  }

  @override
  Future<void> setRefreshToken(String refreshToken) async {
    await _secureStorage.write(
      key: SystemProviderExt.refreshToken,
      value: refreshToken,
    );

    _refreshToken = refreshToken;
  }

  @override
  Future<void> setFCMToken(String token) async {
    await _secureStorage.write(
      key: SystemProviderExt.fcmToken,
      value: token,
    );

    _fcmToken = token;
  }

  @override
  String getMatchingId() {
    return _normalStorage.read(SystemProviderExt.matchingId) ?? '';
  }

  @override
  Future<void> setMatchingId(String matchingId) async {
    await _normalStorage.write(SystemProviderExt.matchingId, matchingId);
  }

  @override
  Future<void> deallocateMatchingId() async {
    await _normalStorage.remove(SystemProviderExt.matchingId);
  }

  @override
  // TODO: implement matchingId
  String get matchingId => throw UnimplementedError();
}
