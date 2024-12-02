import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view_model/store/store_view_model.dart';

class StoreDetailScreen extends BaseWidget<StoreViewModel>{
  final int point = 1000;

  @override
  Widget buildView(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    final String formattedDate =
    DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 3)));

    return Scaffold(
      appBar: AppBar(
        title: const Text("포인트 교환"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/img/shopping/ab.png',
                  width: screenWidth * 0.7, // 화면 비율에 맞게 조정
                  height: screenHeight * 0.2,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "포인트 교환",
                style: TextStyle(
                  fontSize: screenWidth * 0.05, // 화면 너비에 비례한 폰트 크기
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$point P를 ${point}원으로 교환받을래요!",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text("교환 예정일"),
                trailing: Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              ListTile(
                title: const Text("받으실 계좌"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => _showAccountDialog(context),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/img/shopping/exchange.png',
                  width: screenWidth * 0.85, // 화면 비율에 맞게 조정
                  height: screenHeight * 0.25,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // 포인트 교환 호출
                  await viewModel.requestPointExchange(point);
                  _showResultDialog(context, true); // 성공 여부를 대체로 전달
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, screenHeight * 0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  "교환하기",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context, bool success) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(success ? '성공' : '실패'),
        content: Text(success
            ? '포인트 교환이 완료되었습니다. 3일 이내에 송금됩니다!'
            : '포인트가 부족합니다. 다시 확인해주세요!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  void _showAccountDialog(BuildContext context) {
    final TextEditingController accountController = TextEditingController();
    String selectedBank = "은행 선택";

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "계좌 등록/변경",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedBank,
                items: ["은행 선택", "신한은행", "국민은행", "우리은행"]
                    .map((bank) => DropdownMenuItem(
                  value: bank,
                  child: Text(bank),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedBank = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: accountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "계좌번호 입력",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await viewModel.updateBankAccount(
                    selectedBank,
                    accountController.text.trim(),
                  );
                  Navigator.pop(context);
                  _showResultDialog(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("저장"),
              ),
            ],
          ),
        );
      },
    );
  }
}
