import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../controllers/order_provider.dart';
import '../models/order_model.dart';
import '../utils/constants.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  Future<void> _makeCall(BuildContext context, String phone) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch dialer for $phone')),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching dialer for $phone')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<OrderProvider>();

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.adminTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppConstants.textPrimary),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstants.backgroundGradient,
        ),
        child: SafeArea(
          child: StreamBuilder<List<OrderModel>>(
            stream: provider.ordersStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppConstants.primaryColor),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading orders: ${snapshot.error}',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              }

              final orders = snapshot.data ?? [];

              if (orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: AppConstants.textSecondary.withAlpha(128),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noOrders,
                        style: const TextStyle(
                          color: AppConstants.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  IconData vehicleIcon;
                  switch (order.vehicle) {
                    case 'Car':
                      vehicleIcon = Icons.directions_car_rounded;
                      break;
                    case 'Van':
                      vehicleIcon = Icons.airport_shuttle_rounded;
                      break;
                    case 'Truck':
                      vehicleIcon = Icons.local_shipping_rounded;
                      break;
                    default:
                      vehicleIcon = Icons.fire_truck_rounded;
                  }

                  return Dismissible(
                    key: Key(order.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withAlpha(230),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                    ),
                    onDismissed: (_) {
                      provider.deleteOrder(order.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order deleted')),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppConstants.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          // Vehicle type indicator
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppConstants.primaryColor.withAlpha(26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              vehicleIcon,
                              color: AppConstants.primaryColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Main order info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.location,
                                  style: const TextStyle(
                                    color: AppConstants.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.clientName(order.userName),
                                  style: const TextStyle(
                                    color: AppConstants.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${order.vehicle} • ${order.weight.round()} kg',
                                  style: TextStyle(
                                    color: AppConstants.primaryColor.withAlpha(204),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Price details and actions
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${order.price.toStringAsFixed(0)} ${l10n.currency}',
                                style: const TextStyle(
                                  color: AppConstants.accentColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  // Call Action Button
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.phone_in_talk, color: AppConstants.accentColor, size: 22),
                                    tooltip: l10n.callTooltip,
                                    onPressed: () => _makeCall(context, order.userPhone),
                                  ),
                                  const SizedBox(width: 16),
                                  // Delete Action Button
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                                    tooltip: l10n.deleteTooltip,
                                    onPressed: () {
                                      provider.deleteOrder(order.id);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
