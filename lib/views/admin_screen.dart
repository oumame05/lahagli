// Écran 3 : Panneau Administrateur
// Affiche toutes les commandes avec actions : appeler, supprimer, changer statut

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lhagli/l10n/app_localizations.dart';
import '../controllers/order_provider.dart';
import '../models/order_model.dart';
import '../utils/constants.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        centerTitle: true,
        title: Text(l10n.adminPanel,
            style: const TextStyle(
                color: AppColors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: AppColors.white),
            tooltip: 'FR / EN',
            onPressed: () => provider.toggleLanguage(),
          ),
        ],
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: provider.getOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.darkBlue));
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.error, size: 48),
                  const SizedBox(height: 8),
                  Text(l10n.errorMessage,
                      style: const TextStyle(color: AppColors.error)),
                ],
              ),
            );
          }
          final List<OrderModel> orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, color: AppColors.grey, size: 64),
                  const SizedBox(height: 16),
                  Text(l10n.noOrders,
                      style: const TextStyle(
                          color: AppColors.grey, fontSize: 16)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) =>
                _OrderCard(order: orders[index]),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<OrderProvider>();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.person, color: AppColors.darkBlue),
                  const SizedBox(width: 8),
                  Text(order.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.darkBlue)),
                ]),
                _StatusBadge(status: order.status),
              ],
            ),
            const Divider(height: 20),
            _InfoRow(icon: Icons.phone, label: l10n.phoneNumber, value: order.phone),
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.route, label: l10n.trip,
                value: '${order.departure} → ${order.destination}'),
            const SizedBox(height: 8),
            _InfoRow(
              icon: order.vehicle == 'car'
                  ? Icons.directions_car
                  : Icons.airplanemode_active,
              label: l10n.vehicle,
              value: order.vehicle == 'car' ? l10n.car : l10n.airplane,
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _InfoRow(icon: Icons.scale, label: l10n.weight,
                  value: '${order.weight.toStringAsFixed(1)} kg')),
              Expanded(child: _InfoRow(icon: Icons.payments, label: l10n.price,
                  value: '${order.price.toStringAsFixed(0)} MRU',
                  valueColor: AppColors.orange, bold: true)),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _ActionButton(
                  icon: Icons.call, label: l10n.call,
                  color: AppColors.success,
                  onPressed: () => _callPhone(context, order.phone, l10n))),
              const SizedBox(width: 8),
              Expanded(child: _ActionButton(
                  icon: Icons.sync, label: l10n.updateStatus,
                  color: AppColors.darkBlue,
                  onPressed: () =>
                      _showStatusDialog(context, order, provider, l10n))),
              const SizedBox(width: 8),
              Expanded(child: _ActionButton(
                  icon: Icons.delete, label: l10n.delete,
                  color: AppColors.error,
                  onPressed: () =>
                      _showDeleteDialog(context, order, provider, l10n))),
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> _callPhone(BuildContext context, String phone,
      AppLocalizations l10n) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.errorMessage),
          backgroundColor: AppColors.error));
    }
  }

  void _showDeleteDialog(BuildContext context, OrderModel order,
      OrderProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.warning, color: AppColors.error),
          const SizedBox(width: 8),
          Text(l10n.confirmDelete),
        ]),
        content: Text(l10n.confirmDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel,
                style: const TextStyle(color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              if (order.id != null) {
                await provider.deleteOrder(order.id!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(l10n.orderDeleted),
                      backgroundColor: AppColors.success));
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(BuildContext context, OrderModel order,
      OrderProvider provider, AppLocalizations l10n) {
    final List<Map<String, dynamic>> statusOptions = [
      {'value': OrderStatus.pending, 'label': l10n.statusPending,
       'icon': Icons.hourglass_empty, 'color': AppColors.grey},
      {'value': OrderStatus.inProgress, 'label': l10n.statusInProgress,
       'icon': Icons.local_shipping, 'color': AppColors.orange},
      {'value': OrderStatus.delivered, 'label': l10n.statusDelivered,
       'icon': Icons.check_circle, 'color': AppColors.success},
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.sync, color: AppColors.darkBlue),
          const SizedBox(width: 8),
          Text(l10n.chooseStatus),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statusOptions.map((option) {
            final bool isCurrent = order.status == option['value'];
            return ListTile(
              leading: Icon(option['icon'] as IconData,
                  color: option['color'] as Color),
              title: Text(option['label'] as String),
              trailing: isCurrent
                  ? const Icon(Icons.check, color: AppColors.success)
                  : null,
              tileColor: isCurrent ? AppColors.lightGrey : null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onTap: () async {
                Navigator.of(ctx).pop();
                if (order.id != null) {
                  await provider.updateOrderStatus(
                      order.id!, option['value'] as String);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel,
                style: const TextStyle(color: AppColors.grey)),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color bgColor; String label; IconData icon;

    switch (status) {
      case OrderStatus.inProgress:
        bgColor = AppColors.orange;
        label = l10n.statusInProgress;
        icon = Icons.local_shipping;
        break;
      case OrderStatus.delivered:
        bgColor = AppColors.success;
        label = l10n.statusDelivered;
        icon = Icons.check_circle;
        break;
      default:
        bgColor = AppColors.grey;
        label = l10n.statusPending;
        icon = Icons.hourglass_empty;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.15),
        border: Border.all(color: bgColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: bgColor),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: bgColor,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 16, color: AppColors.darkBlue),
      const SizedBox(width: 6),
      Text('$label: ',
          style: const TextStyle(color: AppColors.grey, fontSize: 13)),
      Flexible(
        child: Text(value,
            style: TextStyle(
              color: valueColor ?? AppColors.darkBlue,
              fontSize: 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis),
      ),
    ]);
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        elevation: 2,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 18),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(fontSize: 10),
            overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}