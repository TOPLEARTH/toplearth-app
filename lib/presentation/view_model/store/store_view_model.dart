import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ViewModel 간단 구현
class StoreViewModel extends GetxController {
  Future<void> requestPointExchange(int points) async {
    // 비즈니스 로직 대체
    print("Requesting point exchange for $points points...");
  }

  Future<void> updateBankAccount(String bank, String account) async {
    // 비즈니스 로직 대체
    print("Updating bank account to $bank, $account...");
  }
}

class ShoppingDetailScreen extends StatelessWidget {
  final int point;
  ShoppingDetailScreen({required this.point, Key? key}) : super(key: key);

  final StoreViewModel viewModel = Get.put(StoreViewModel());

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
    DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 3)));

    return Scaffold(
      appBar: AppBar(
        title: const Text("포인트 교환"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "포인트를 교환해보세요!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text("교환 포인트"),
            trailing: Text("$point P", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text("교환 예정일"),
            trailing: Text(formattedDate),
          ),
          const Divider(),
          ListTile(
            title: const Text("받으실 계좌"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => _showAccountDialog(context),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await viewModel.requestPointExchange(point);
                _showResultDialog(context, true);
              },
              child: const Text("교환하기"),
            ),
          ),
        ],
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
            : '포인트가 부족합니다. 다시 확인해주세요.'),
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
              const Text(
                "계좌 등록/변경",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                child: const Text("저장"),
              ),
            ],
          ),
        );
      },
    );
  }
}