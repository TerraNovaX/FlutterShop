import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/checkout_viewmodel.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();
    final checkoutVm = context.watch<CheckoutViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: cart.isEmpty
            ? const Center(
                child: Text('Votre panier est vide'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Récapitulatif',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: cart.items.map((item) {
                        return ListTile(
                          title: Text(item.title),
                          subtitle: Text(
                            '${item.quantity} x ${item.price.toStringAsFixed(2)} €',
                          ),
                          trailing: Text(
                            '${item.total.toStringAsFixed(2)} €',
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Total : ${cart.total.toStringAsFixed(2)} €',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.right,
                  ),

                  const SizedBox(height: 16),

                  if (checkoutVm.error != null)
                    Text(
                      checkoutVm.error!,
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: checkoutVm.isProcessing
                          ? null
                          : () async {
                              final ok = await context
                                  .read<CheckoutViewModel>()
                                  .checkout(
                                    context.read<CartViewModel>(),
                                  );

                              if (ok && context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Commande validée'),
                                    content: const Text(
                                      'Votre commande a été créée avec succès !',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          context.go('/home');
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                      child: checkoutVm.isProcessing
                          ? const CircularProgressIndicator()
                          : const Text('Payer'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
