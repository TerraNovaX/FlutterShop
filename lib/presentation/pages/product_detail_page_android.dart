import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart'; 

import '../../presentation/viewmodels/cart_viewmodel.dart';
import '../../presentation/viewmodels/product_viewmodel.dart';

class ProductDetailPageAndroid extends StatefulWidget {
  final int productId;

  const ProductDetailPageAndroid({super.key, required this.productId});

  @override
  State<ProductDetailPageAndroid> createState() =>
      _ProductDetailPageAndroidState();
}

class _ProductDetailPageAndroidState extends State<ProductDetailPageAndroid> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<ProductViewModel>().loadProduct(widget.productId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();
    final cart = context.watch<CartViewModel>();

    final Widget content = vm.isLoading
        ? const Center(child: CircularProgressIndicator())
        : vm.product == null
            ? const Center(child: Text('Produit introuvable'))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        vm.product!.image,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      vm.product!.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${vm.product!.price.toStringAsFixed(2)} €',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(vm.product!.category),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      vm.product!.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Ajouter au panier'),
                        onPressed: vm.product == null
                            ? null
                            : () {
                                cart.addProduct(vm.product!);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${vm.product!.title} ajouté au panier !',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail produit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: vm.product == null
                ? null
                : () {
                    final product = vm.product!;
                    Share.share(
                      'Regarde ce produit : ${product.title}\nhttps://mon-site.com/product/${product.id}',
                      subject: 'Partager un produit',
                    );
                  },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.go('/cart'),
          ),
        ],
      ),
      body: content,
    );
  }
}
