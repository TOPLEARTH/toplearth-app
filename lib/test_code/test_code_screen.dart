// // import 'package:flutter/material.dart';
// // import 'package:toplearth/MessagePage.dart';
// // import 'package:toplearth/test_code/NaverMapScreen.dart';
// // import 'package:toplearth/app/config/color_system.dart';
// // import 'package:toplearth/app/config/font_system.dart';
// // import 'package:toplearth/core/view/base_screen.dart';
// // import 'package:toplearth/local_push_notifications.dart';
// // import 'package:get/get.dart';
// // import 'package:toplearth/presentation/view/group/group_screen.dart';
// // import 'package:toplearth/presentation/view/home/home_screen.dart';
// // import 'package:toplearth/presentation/view/matching/matching_screen.dart';
// // import 'package:toplearth/presentation/view/my_page/my_page_screen.dart';
// // import 'package:toplearth/presentation/view/root/widget/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
// // import 'package:toplearth/presentation/view/store/store_screen.dart';
// // import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
// // class TestCodeScreen extends StatefulWidget {
// //   const TestCodeScreen({super.key});
// //
// //   @override
// //   State<TestCodeScreen> createState() => _TestCodeScreenState();
// // }
// //
// // class _TestCodeScreenState extends State<TestCodeScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     LocalPushNotifications.init(); // 푸시 알림 초기화
// //     LocalPushNotifications.notificationStream.stream.listen((payload) {
// //       if (payload.isNotEmpty) {
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) => MessagePage(payload: payload),
// //           ),
// //         );
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: ColorSystem.white,
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             const Text(
// //               'Toplearth Root Screen',
// //               style: FontSystem.H6,
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 LocalPushNotifications.showSimpleNotification(
// //                   title: '투플러스',
// //                   body: '10시 플로깅 대전 매칭에 성공했습니다!',
// //                   payload: '일반 알림 데이터',
// //                 );
// //               },
// //               child: const Text("일반 푸시 알림"),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 // NaverMapScreen으로 이동
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => NaverMapScreen(),
// //                   ),
// //                 );
// //               },
// //               child: const Text("네이버 맵 열기"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:toplearth/test_code/imaeg_upload_view_model.dart';
//
// class ImageUploadScreen extends StatelessWidget {
//   const ImageUploadScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final ImageUploadViewModel viewModel = Get.put(ImageUploadViewModel());
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('이미지 업로드 테스트')),
//       body: Center(
//         child: Obx(() {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   final picker = ImagePicker();
//                   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//                   if (pickedFile != null) {
//                     viewModel.setSelectedImage(File(pickedFile.path));
//                   }
//                 },
//                 child: const Text('이미지 선택'),
//               ),
//               if (viewModel.selectedImage.value != null)
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Image.file(viewModel.selectedImage.value!, height: 150),
//                 ),
//               viewModel.isLoading.value
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                 onPressed: () async {
//                   final result = await viewModel.uploadImage(37.5665, 126.9780); // Example coordinates
//                   if (result.success) {
//                     Get.snackbar('성공', result.message ?? '이미지 업로드에 성공했습니다.');
//                   } else {
//                     Get.snackbar('실패', result.message ?? '이미지 업로드에 실패했습니다.');
//                   }
//                 },
//                 child: const Text('이미지 업로드'),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
//
//
// // import 'dart:io'; // 도형 성공코드
// //
// // import 'package:dio/dio.dart';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// //
// // class ImageUploadScreen extends StatefulWidget {
// //   const ImageUploadScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// // }
// //
// // class _ImageUploadScreenState extends State<ImageUploadScreen> {
// //   File? _selectedImage;
// //
// //   Future<void> _pickImage() async {
// //     final picker = ImagePicker();
// //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
// //
// //     if (pickedFile != null) {
// //       setState(() {
// //         _selectedImage = File(pickedFile.path);
// //       });
// //     }
// //   }
// //
// //   Future<void> _uploadImage() async {
// //     if (_selectedImage == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('이미지를 선택해주세요.')),
// //       );
// //       return;
// //     }
// //
// //     try {
// //       final dio = Dio();
// //       const String url = 'http://api.toplearth.com/api/v1/plogging/5/image';
// //       // API_SERVER_URL=http://api.toplearth.com
// //       final formData = FormData.fromMap({
// //         'ploggingImage': await MultipartFile.fromFile(
// //           _selectedImage!.path,
// //           filename: '${DateTime.now()}.png',
// //           contentType: DioMediaType('image', 'png'),
// //         ),
// //         'latitude': 37.5665,
// //         'longitude': 126.9780,
// //       });
// //
// //       print('formData: $formData'); // formData: FormData(<String, dynamic>{'ploggingImage': MultipartFile, 'latitude': 37.5665, 'longitude': 126.978}
// //       print('sendingData: ${formData.fields}'); // sendingData: [MapEntry<String, String>('latitude', '37.5665'), MapEntry<String, String>('longitude', '126.978')]
// //
// //       final response = await dio.post(
// //         url,
// //         data: formData,
// //         options: Options(
// //           headers: {
// //             'Authorization': 'Bearer eyJKV1QiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VySWQiOiI1MGZlMTRkMS1iY2JkLTQ3MWQtYTJjNi05ODA1NzYwZDcwOTkiLCJ1c2VyUm9sZSI6IlVTRVIiLCJpYXQiOjE3MzI1MzQ2MTAsImV4cCI6MTczNTEyNjYxMH0.-eINVFV57_WlKsnfic0arx2XXNk6fMC9IstR3KpL5vczrrrFs54fnY_SEpw-1QmvDnVyBWWSwQDhiQGAhRtsIA', // Access Token 설정
// //             'Content-Type': 'multipart/form-data',
// //           },
// //         ),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         print('resp: ${response}'); // 'resp: {"message":"이미지 업로드 성공"}
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('이미지 업로드 성공')),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('업로드 실패: ${response.statusCode}')),
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('오류 발생: $e')),
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('이미지 업로드 테스트')),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             ElevatedButton(
// //               onPressed: _pickImage,
// //               child: const Text('이미지 선택'),
// //             ),
// //             if (_selectedImage != null)
// //               Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Image.file(_selectedImage!, height: 150),
// //               ),
// //             ElevatedButton(
// //               onPressed: _uploadImage,
// //               child: const Text('이미지 업로드'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// // import 'dart:io';
// //
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:toplearth/core/provider/base_connect.dart';
// // import 'package:http_parser/http_parser.dart';
// // final mediaType = MediaType('image', 'png');
// //
// // class ImageUploadProvider extends BaseConnect {
// //   Future<Response<dynamic>> uploadImage({
// //     required File image,
// //     required double latitude,
// //     required double longitude,
// //   }) async {
// //     FormData formData = FormData({
// //       'ploggingImage': MultipartFile(
// //         image.path, // 파일 경로
// //         filename: '${DateTime.now().toIso8601String()}.png', // 파일 이름
// //         contentType: 'image/png', // Content-Type을 String으로 명시
// //       ),
// //       'latitude': latitude, // 위도
// //       'longitude': longitude, // 경도
// //     });
// //
// //     return post(
// //       'http://api.toplearth.com/api/v1/plogging/5/image', // 상대 경로
// //       formData,
// //       headers: {
// //         'Authorization': 'Bearer eyJKV1QiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VySWQiOiI1MGZlMTRkMS1iY2JkLTQ3MWQtYTJjNi05ODA1NzYwZDcwOTkiLCJ1c2VyUm9sZSI6IlVTRVIiLCJpYXQiOjE3MzI1MzQ2MTAsImV4cCI6MTczNTEyNjYxMH0.-eINVFV57_WlKsnfic0arx2XXNk6fMC9IstR3KpL5vczrrrFs54fnY_SEpw-1QmvDnVyBWWSwQDhiQGAhRtsIA',
// //         'Content-Type': 'multipart/form-data',
// //       },
// //     );
// //   }
// // }
//
// // class ImageUploadScreen extends StatefulWidget {
// //   const ImageUploadScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// // }
// //
// // class _ImageUploadScreenState extends State<ImageUploadScreen> {
// //   File? _selectedImage; // 선택된 이미지 파일
// //   final ImageUploadProvider _imageUploadProvider = ImageUploadProvider(); // Provider 인스턴스
// //
// //   // 이미지 선택
// //   Future<void> _pickImage() async {
// //     final picker = ImagePicker();
// //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
// //
// //     if (pickedFile != null) {
// //       setState(() {
// //         _selectedImage = File(pickedFile.path); // 선택된 파일을 상태에 저장
// //       });
// //     }
// //   }
// //
// //   // 이미지 업로드
// //   Future<void> _uploadImage() async {
// //     if (_selectedImage == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('이미지를 선택해주세요.')),
// //       );
// //       return;
// //     }
// //
// //     try {
// //       final response = await _imageUploadProvider.uploadImage(
// //         image: _selectedImage!,
// //         latitude: 37.5665,
// //         longitude: 126.9780,
// //       );
// //
// //       if (response.statusCode == 200) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('이미지 업로드 성공')),
// //         );
// //         print('Response: ${response.body}');
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('업로드 실패: ${response.statusCode}')),
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('오류 발생: $e')),
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('이미지 업로드 테스트')),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             ElevatedButton(
// //               onPressed: _pickImage,
// //               child: const Text('이미지 선택'),
// //             ),
// //             if (_selectedImage != null)
// //               Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Image.file(_selectedImage!, height: 150),
// //               ),
// //             ElevatedButton(
// //               onPressed: _uploadImage,
// //               child: const Text('이미지 업로드'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }