import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/viewmodels/catalog_viewmodel.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<CatalogViewModel>().loadProducts());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CatalogViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue'),

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher un produit',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: vm.updateSearchQuery,
            ),
          ),
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: vm.products.length,
                    itemBuilder: (context, index) {
                      final product = vm.products[index];
                      return ListTile(
                        leading: Image.network(
                          product.image,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.title),
                        subtitle: Text(
                          '${product.price.toStringAsFixed(2)} € • ${product.category}',
                        ),
                        onTap: () {
                          context.go('/product/${product.id}');
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
