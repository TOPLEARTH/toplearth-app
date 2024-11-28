import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/domain/entity/plogging/plogging_state.dart';
import 'package:toplearth/presentation/view_model/my_page/my_page_view_model.dart';

class CalendarWidget extends BaseWidget<MyPageViewModel> {
  const CalendarWidget({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          _buildCalendar(),
          const SizedBox(height: 16),
          _buildPloggingImages(), // 플로깅 이미지 리스트 추가
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'ko_KR',
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: viewModel.focusedDate.value,
      selectedDayPredicate: (day) =>
          isSameDay(viewModel.selectedDate.value, day),
      onDaySelected: (selectedDay, focusedDay) {
        viewModel.updateSelectedDate(selectedDay);
        viewModel.updateFocusedDate(focusedDay);
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final isCompleted = viewModel.isPloggingCompleted(day);
          return Center(
            child: isCompleted
                ? const Icon(Icons.eco, color: Colors.green)
                : Text('${day.day}'),
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            decoration: const BoxDecoration(
              color: ColorSystem.main,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPloggingImages() {
    final ploggingList = viewModel.getPloggingForSelectedDate();

    if (ploggingList.isEmpty) {
      return const Center(
        child: Text('플로깅 기록이 없습니다.',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ploggingList.length,
        itemBuilder: (context, index) {
          final plogging = ploggingList[index];
          return _buildPloggingCard(plogging);
        },
      ),
    );
  }

  Widget _buildPloggingCard(PloggingState plogging) {
    // 플로깅 데이터 추출
    final distance = plogging.distance.toStringAsFixed(1); // 거리 (소수점 1자리)
    final duration = plogging.duration; // 총 시간 (분 단위)
    final imageUrl = plogging.ploggingImageList.isNotEmpty
        ? plogging.ploggingImageList.first.imageUrl
        : ''; // 첫 번째 이미지 URL

    // 시간 계산 (시간:분:초 형식)
    final hours = duration ~/ 60; // 시간
    final minutes = duration % 60; // 분

    return Stack(
      children: [
        // 배경 이미지
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(
            imageUrl,
            width: 120,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        // 거리와 시간 정보 오버레이
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              '$distance KM',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
