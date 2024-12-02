import 'package:toplearth/core/provider/base_connect.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/data/provider/home/home_provider.dart';

class HomeRemoteProviderImpl extends BaseConnect implements HomeRemoteProvider {
  @override
  Future<ResponseWrapper> setGoalDistance({
    required double goalDistance,
  }) async {
    try {
      final response = await patch(
        '/api/v1/users/goal',
        {'goalDistance': goalDistance},
        headers: BaseConnect.usedAuthorization,
      );

      if (response.statusCode == 200) {
        return ResponseWrapper(success: true, data: response.body);
      } else {
        return ResponseWrapper(
          success: false,
          message: response.statusText ?? 'Unknown error',
        );
      }
    } catch (e) {
      return ResponseWrapper(
        success: false,
        message: 'Failed to set goal distance: $e',
      );
    }
  }
}
