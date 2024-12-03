import 'package:timezone/timezone.dart' as tz;

int getNextHour() {
  // 한국 시간으로 초기화
  final now = tz.TZDateTime.now(tz.getLocation('Asia/Seoul'));

  // 현재 시간이 몇 분인지 확인
  if (now.minute > 0) {
    return (now.hour + 1) % 24; // 다음 시간으로 넘어감
  }
  return now.hour; // 현재 정각 시간 유지
}
