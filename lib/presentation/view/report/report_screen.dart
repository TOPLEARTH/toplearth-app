import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_report_view_model.dart';

class ReportScreen extends BaseScreen<PloggingReportViewModel> {
  const ReportScreen({super.key});

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("신고하기"),
      centerTitle: true,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return _ReportBody(viewModel: viewModel);
  }
}

class _ReportBody extends StatefulWidget {
  final PloggingReportViewModel viewModel;

  const _ReportBody({required this.viewModel, Key? key}) : super(key: key);

  @override
  State<_ReportBody> createState() => _ReportBodyState();
}

class _ReportBodyState extends State<_ReportBody> {
  int selectedReason = -1; // 선택된 신고 사유 (-1: 선택되지 않음)
  TextEditingController detailController = TextEditingController(); // 추가 사유 입력
  bool isButtonEnabled = false; // 버튼 활성화 상태
  final int ploggingId = Get.arguments?.ploggingId ?? 0; // 전달받은 ploggingId

  final List<String> reasons = [
    "부적절한 내용",
    "스팸 또는 광고",
    "허위 정보",
    "기타",
  ];

  void checkButtonEnabled() {
    setState(() {
      isButtonEnabled = selectedReason != -1 &&
          (selectedReason != 3 || detailController.text.trim().isNotEmpty);
    });
  }

  Future<void> submitReport() async {
    final reason = reasons[selectedReason];
    final detail = selectedReason == 3 ? detailController.text.trim() : "";

    final result = await widget.viewModel.reportPlogging(
      ploggingId,
    );

    if (result.success) {
      _showDialog(
        title: "신고 완료",
        content: "신고가 성공적으로 접수되었습니다.",
        onConfirm: () {
          Get.back(); // Close the report screen
          Get.back(); // Navigate back to the previous screen
        },
      );
    } else {
      _showDialog(
        title: "신고 실패",
        content: result.message ?? "신고 요청을 처리하지 못했습니다. 다시 시도해주세요.",
      );
    }
  }

  void _showDialog(
      {required String title,
      required String content,
      VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: onConfirm ?? () => Navigator.of(context).pop(),
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "신고 사유를 선택해주세요:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // 신고 사유 선택 (라디오 버튼)
          ...List.generate(reasons.length, (index) {
            return RadioListTile<int>(
              title: Text(reasons[index]),
              value: index,
              groupValue: selectedReason,
              onChanged: (value) {
                setState(() {
                  selectedReason = value!;
                  if (selectedReason != 3) {
                    detailController.clear(); // 기타 사유 입력 초기화
                  }
                  checkButtonEnabled();
                });
              },
            );
          }),
          const SizedBox(height: 16),
          if (selectedReason == 3)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "추가 사유를 입력해주세요:",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: detailController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "여기에 추가 사유를 작성하세요.",
                  ),
                  onChanged: (value) => checkButtonEnabled(),
                ),
              ],
            ),
          const Spacer(),
          RoundedRectangleTextButton(
            width: MediaQuery.of(context).size.width,
            height: 50,
            onPressed: isButtonEnabled ? submitReport : null,
            backgroundColor:
                isButtonEnabled ? const Color(0xFFFF6830) : Colors.grey,
            text: "신고하기",
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
