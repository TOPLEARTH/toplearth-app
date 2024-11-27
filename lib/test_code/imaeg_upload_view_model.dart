// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:toplearth/core/wrapper/result_wrapper.dart';
// import 'package:toplearth/domain/condition/plogging/upload_plogging_image_condition.dart';
// import 'package:toplearth/domain/usecase/plogging/upload_plogging_image_usecase.dart';
// class ImageUploadViewModel extends GetxController {
//   late final UploadPloggingImageUseCase _uploadPloggingImageUseCase;
//
//   final Rx<File?> selectedImage = Rx<File?>(null);
//   final RxBool isLoading = false.obs;
//
//   void setSelectedImage(File? image) {
//     selectedImage.value = image;
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     _uploadPloggingImageUseCase = Get.find<UploadPloggingImageUseCase>();
//   }
//
//   Future<ResultWrapper> uploadImage(double latitude, double longitude) async {
//     if (selectedImage.value == null) {
//       return ResultWrapper(success: false, message: '이미지를 선택해주세요.');
//     }
//
//     isLoading.value = true;
//
//     try {
//       final response = await _uploadPloggingImageUseCase.execute(
//         UploadPloggingImageCondition(
//           ploddingImage: selectedImage.value!,
//           ploggingId: 5, // 플로깅 ID (예시)
//           latitude: latitude,
//           longitude: longitude,
//         ),
//       );
//
//       isLoading.value = false;
//
//       return ResultWrapper(
//         success: response.success,
//         message: response.message,
//       );
//     } catch (e) {
//       isLoading.value = false;
//       return ResultWrapper(
//         success: false,
//         message: '이미지 업로드 중 오류 발생: $e',
//       );
//     }
//   }
// }
