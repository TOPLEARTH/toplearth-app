import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/domain/entity/quest/quest_state.dart';
import 'package:toplearth/presentation/view/my_page/my_page_calendar.dart';
import 'package:toplearth/presentation/view_model/my_page/my_page_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_back_app_bar.dart';

class MyPageScreen extends BaseScreen<MyPageViewModel> {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const DefaultBackAppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          // 항상 표시되는 Tab Selector
          _buildTabSelector(),

          // 조건에 따라 다른 위젯 표시
          Expanded(
            child: viewModel.selectedTab == 'DAILY 퀘스트'
                ? _buildQuestList() // Daily Quest 탭의 리스트
                : const CalendarWidget(), // 다른 탭의 캘린더 위젯
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, {required bool isSelected}) {
    return GestureDetector(
      onTap: () => viewModel.toggleTab(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? ColorSystem.sub : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Obx(() {
      return Container(
        width: Get.width * 0.65,
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        margin: const EdgeInsets.symmetric(vertical: 24.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTab('DAILY 퀘스트',
                isSelected: viewModel.selectedTab == 'DAILY 퀘스트'),
            _buildTab('내 플로깅', isSelected: viewModel.selectedTab == '내 플로깅'),
          ],
        ),
      );
    });
  }

  // 퀘스트 리스트
  Widget _buildQuestList() {
    // Get the current date
    final DateTime now = DateTime.now();

    // Format the date as "yyyy-MM-dd"
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // Use the formatted date to retrieve quests
    final quests = viewModel.questInfoState.dailyQuest[formattedDate];

    if (quests == null || quests.isEmpty) {
      return const Center(
        child: Text(
          '퀘스트가 없습니다.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Obx(() {
      return ListView.builder(
        itemCount: viewModel.questInfoState.dailyQuest[formattedDate]?.length,
        itemBuilder: (context, index) {
          return _buildQuestItem(
              viewModel.questInfoState.dailyQuest[formattedDate]![index]);
        },
      );
    });
  }

  Widget _buildQuestItem(QuestState quest) {
    String title = '';
    double progress = 0;
    String iconPath = '';

    // 퀘스트 유형에 따라 제목, 진행률, 아이콘 설정
    if (quest.targetKmName != null) {
      title = '${quest.targetKmName}km\n 이상 플로깅 하기';
      progress = (quest.myKmNumber ?? 0) / (quest.targetKmName ?? 1);
      iconPath = 'assets/images/quest/quest1.png'; // 플로깅 아이콘 경로
    } else if (quest.targetPickNumber != null) {
      title = '쓰레기 ${quest.targetPickNumber}개\n이상 줍기';
      progress = (quest.myPickNumber ?? 0) / (quest.targetPickNumber ?? 1);
      iconPath = 'assets/images/quest/quest2.png'; // 쓰레기 줍기 아이콘 경로
    } else if (quest.targetLabelNumber != null) {
      title = '리플링\n${quest.targetLabelNumber}개 하기';
      progress = (quest.myLabelNumber ?? 0) / (quest.targetLabelNumber ?? 1);
      iconPath = 'assets/images/quest/quest3.png'; // 리플링 아이콘 경로
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // 아이콘
            Image.asset(iconPath, width: 110, height: 110),
            const SizedBox(width: 16),
            // 제목 및 진행 상태
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      // 진행률 배경 바
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      // 진행률 바
                      FractionallySizedBox(
                        widthFactor: progress.clamp(0, 1), // 진행률 제한
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: ColorSystem.main,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // 진행률 텍스트
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: ColorSystem.main,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(quest.questCredit.toString(),
                  style: FontSystem.Sub2.copyWith(color: ColorSystem.white)),
            ),
          ],
        ),
      ),
    );
  }
}
