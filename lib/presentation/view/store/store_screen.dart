import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/presentation/view_model/store/store_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_app_bar.dart';

class Product {
  final String imagePath;
  final String title;
  final int point;

  const Product(this.imagePath, this.title, this.point);

  Widget get imageWidget {
    return Image.asset(
      imagePath,
      height: 80.0,
      fit: BoxFit.cover,
    );
  }
}

final List<Product> products = [
  Product('assets/images/store/3000.png', '피우다 사랑 상품권', 3000),
  Product('assets/images/store/5000.png', '피우다 사랑 상품권', 5000),
  Product('assets/images/store/10000.png', '피우다 사랑 상품권', 10000),
  Product('assets/images/store/20000.png', '피우다 사랑 상품권', 20000),
];

class StoreScreen extends BaseScreen<StoreViewModel> {
  const StoreScreen({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const DefaultAppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "포인트를 사용하여 원하는 상품을 교환하세요!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductItem(context, product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.STORE_DETAIL,
          arguments: {
            'title': product.title,
            'point': product.point,
            'imagePath': product.imagePath,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: product.imageWidget,
            ),
            const SizedBox(height: 8.0),
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),
            Text(
              '${product.point}P',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
