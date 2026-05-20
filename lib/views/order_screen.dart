// Écran 2 : Formulaire de commande
// L'utilisateur remplit les détails de sa livraison et voit le prix calculé

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lhagli/l10n/app_localizations.dart';
import '../controllers/order_provider.dart';
import '../utils/constants.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _onConfirmOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<OrderProvider>();

    if (provider.departure == provider.destination &&
        provider.departure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.sameCityError),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await provider.confirmOrder();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.orderConfirmed),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        centerTitle: true,
        title: Text(
          l10n.newOrder,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: AppColors.white),
            tooltip: 'FR / EN',
            onPressed: () => provider.toggleLanguage(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildClientHeader(provider),
              const SizedBox(height: 16),
              _buildLocationCard(l10n, provider),
              const SizedBox(height: 16),
              _buildVehicleCard(l10n, provider),
              const SizedBox(height: 16),
              _buildWeightCard(l10n, provider),
              const SizedBox(height: 16),
              _buildPriceCard(l10n, provider),
              const SizedBox(height: 24),
              _buildActionButtons(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientHeader(OrderProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.darkBlue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.person, color: AppColors.orange, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.currentUser?.name ?? '',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  provider.currentUser?.phone ?? '',
                  style: const TextStyle(color: AppColors.grey, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(AppLocalizations l10n, OrderProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.route, color: AppColors.darkBlue),
                const SizedBox(width: 8),
                Text(
                  l10n.trip,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.darkBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCityDropdown(
              label: l10n.departure,
              icon: Icons.flight_takeoff,
              value: provider.departure,
              onChanged: (city) => provider.setDeparture(city),
              l10n: l10n,
            ),
            const SizedBox(height: 12),
            const Center(
              child: Icon(Icons.arrow_downward, color: AppColors.orange, size: 28),
            ),
            const SizedBox(height: 12),
            _buildCityDropdown(
              label: l10n.destination,
              icon: Icons.flight_land,
              value: provider.destination,
              onChanged: (city) => provider.setDestination(city),
              l10n: l10n,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required ValueChanged<String?> onChanged,
    required AppLocalizations l10n,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.grey),
        prefixIcon: Icon(icon, color: AppColors.darkBlue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBlue, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
      ),
      hint: Text(l10n.selectCity),
      items: mauritanianCities
          .map((city) => DropdownMenuItem(value: city, child: Text(city)))
          .toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? l10n.fieldRequired : null,
    );
  }

  Widget _buildVehicleCard(AppLocalizations l10n, OrderProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car, color: AppColors.darkBlue),
                const SizedBox(width: 8),
                Text(
                  l10n.vehicleType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.darkBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildVehicleOption(
                    label: l10n.car,
                    icon: Icons.directions_car,
                    value: 'car',
                    groupValue: provider.vehicleType,
                    onChanged: (v) => provider.setVehicleType(v!),
                    subtitle: '80 MRU/km\n+ 15 MRU/kg',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildVehicleOption(
                    label: l10n.airplane,
                    icon: Icons.airplanemode_active,
                    value: 'airplane',
                    groupValue: provider.vehicleType,
                    onChanged: (v) => provider.setVehicleType(v!),
                    subtitle: '150 MRU/km\n+ 50 MRU/kg',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleOption({
    required String label,
    required IconData icon,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
    required String subtitle,
  }) {
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.darkBlue.withOpacity(0.1)
              : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.darkBlue : AppColors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40,
                color: isSelected ? AppColors.darkBlue : AppColors.grey),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.darkBlue : AppColors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.grey),
                textAlign: TextAlign.center),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.darkBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightCard(AppLocalizations l10n, OrderProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.scale, color: AppColors.darkBlue),
                const SizedBox(width: 8),
                Text(l10n.weight,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.darkBlue,
                    )),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.weight,
                labelStyle: const TextStyle(color: AppColors.grey),
                prefixIcon:
                    const Icon(Icons.scale, color: AppColors.darkBlue),
                suffixText: 'kg',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.darkBlue, width: 2),
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
              onChanged: (value) {
                final double weight = double.tryParse(value) ?? 0.0;
                provider.setWeight(weight);
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.fieldRequired;
                }
                final double? weight = double.tryParse(value);
                if (weight == null || weight <= 0) return l10n.weightInvalid;
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(AppLocalizations l10n, OrderProvider provider) {
    final double price = provider.calculatedPrice;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.darkBlue,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calculate, color: AppColors.orange, size: 28),
                const SizedBox(width: 12),
                Text(l10n.estimatedPrice,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
            Text(
              price > 0 ? '${price.toStringAsFixed(0)} MRU' : '-- MRU',
              style: const TextStyle(
                color: AppColors.orange,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _onConfirmOrder,
          icon: _isLoading
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.white, strokeWidth: 2))
              : const Icon(Icons.check_circle),
          label: Text(l10n.confirmOrder),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            shadowColor: AppColors.orange.withOpacity(0.4),
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _isLoading
              ? null
              : () {
                  setState(() { _weightController.clear(); });
                  context.read<OrderProvider>().setDeparture(null);
                  context.read<OrderProvider>().setDestination(null);
                  context.read<OrderProvider>().setWeight(0.0);
                  context.read<OrderProvider>().setVehicleType('car');
                },
          icon: const Icon(Icons.edit),
          label: Text(l10n.editOrder),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkBlue,
            side: const BorderSide(color: AppColors.darkBlue, width: 2),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}