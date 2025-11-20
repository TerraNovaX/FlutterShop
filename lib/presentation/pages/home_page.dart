import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/viewmodels/auth_viewmodel.dart';
import '../../presentation/viewmodels/catalog_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<CatalogViewModel>().loadProducts());
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final catalog = context.watch<CatalogViewModel>();

    final email = auth.user?.email ?? 'Utilisateur';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalogue"),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                email,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.go('/cart'),
          ),
        ],
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
              onChanged: catalog.updateSearchQuery,
            ),
          ),
          Expanded(
            child: catalog.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: catalog.products.length,
                    itemBuilder: (context, index) {
                      final product = catalog.products[index];
                      return ListTile(
                        leading: Image.network(
                          product.image,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${product.price.toStringAsFixed(2)} € • ${product.category}',
                        ),
                        onTap: () {
                          context.push('/product/${product.id}');
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
