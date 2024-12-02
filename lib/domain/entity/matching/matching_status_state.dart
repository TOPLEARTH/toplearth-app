import 'package:toplearth/domain/type/e_matching_status.dart';

class MatchingStatusState {
  final EMatchingStatus status;

  MatchingStatusState({
    required this.status,
  });

  MatchingStatusState copyWith({
    EMatchingStatus? status,
  }) {
    return MatchingStatusState(
      status: status ?? this.status,
    );
  }

  MatchingStatusState initial() {
    return MatchingStatusState(
      status: EMatchingStatus.WAITING,
    );
  }


  factory MatchingStatusState.fromJson(Map<String, dynamic> json) {
    try {
      return MatchingStatusState(
        status: EMatchingStatus.values.firstWhere(
              (e) => e.name == json['status'],
          orElse: () {
            // 데이터가 일치하지 않을 경우 로그 추가
            print("Invalid status received: ${json['status']}");
            throw Exception("Invalid status: ${json['status']}");
          },
        ),
      );
    } catch (e) {
      print("Error in MatchingStatusState.fromJson: $e");
      // 기본 상태 반환 또는 null 처리
      return MatchingStatusState(
        status: EMatchingStatus.WAITING,
      );
    }
  }



  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
    };
  }
}