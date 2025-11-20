import 'dart:io' show Platform;
import 'package:flutter/widgets.dart';

import 'product_detail_page_android.dart';
import 'product_detail_page_ios.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return ProductDetailPageIos(productId: productId);
    } else {
      return ProductDetailPageAndroid(productId: productId);
    }
  }
}