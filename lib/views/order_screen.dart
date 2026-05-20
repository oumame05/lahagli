import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../controllers/order_provider.dart';
import '../utils/constants.dart';
import 'admin_screen.dart';
import 'register_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _weightController = TextEditingController(text: '100');

  String _selectedVehicle = 'Car';
  double _weight = 100.0;

  @override
  void initState() {
    super.initState();
    _weightController.addListener(_onWeightTextChanged);
  }

  @override
  void dispose() {
    _weightController.removeListener(_onWeightTextChanged);
    _weightController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onWeightTextChanged() {
    final val = double.tryParse(_weightController.text);
    if (val != null && val != _weight) {
      setState(() {
        _weight = val.clamp(1.0, 10000.0);
      });
    }
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<OrderProvider>();
      final success = await provider.placeOrder(
        location: _locationController.text.trim(),
        vehicle: _selectedVehicle,
        weight: _weight,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.orderSuccess),
              backgroundColor: AppConstants.accentColor,
            ),
          );
          // Reset form inputs except destination if needed, let's just clear
          _locationController.clear();
          setState(() {
            _weight = 100.0;
            _weightController.text = '100';
            _selectedVehicle = 'Car';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit request. Please try again.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<OrderProvider>();

    // Redirect if somehow accessed without registering
    if (!provider.isRegistered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
      });
      return const SizedBox();
    }

    final double price = provider.calculatePrice(_selectedVehicle, _weight);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: AppConstants.primaryColor),
            tooltip: l10n.adminPanelButton,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              provider.logout();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstants.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome banner
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppConstants.primaryColor.withAlpha(51),
                        child: const Icon(Icons.person, color: AppConstants.primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.clientName(provider.currentUser!.name),
                            style: const TextStyle(
                              color: AppConstants.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            provider.currentUser!.phone,
                            style: const TextStyle(
                              color: AppConstants.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    l10n.createOrderTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Location Input Card
                  _buildSectionCard(
                    child: TextFormField(
                      controller: _locationController,
                      style: const TextStyle(color: AppConstants.textPrimary),
                      decoration: InputDecoration(
                        labelText: l10n.locationLabel,
                        labelStyle: const TextStyle(color: AppConstants.textSecondary),
                        prefixIcon: const Icon(Icons.pin_drop_outlined, color: AppConstants.primaryColor),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.locationError;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Vehicle Selector Header
                  Text(
                    l10n.vehicleLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Vehicle Selector Cards Row
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: AppConstants.vehicleBaseRates.keys.map((vehicle) {
                        final isSelected = _selectedVehicle == vehicle;
                        IconData icon;
                        switch (vehicle) {
                          case 'Car':
                            icon = Icons.directions_car_rounded;
                            break;
                          case 'Van':
                            icon = Icons.airport_shuttle_rounded;
                            break;
                          case 'Truck':
                            icon = Icons.local_shipping_rounded;
                            break;
                          default:
                            icon = Icons.fire_truck_rounded;
                        }

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedVehicle = vehicle;
                            });
                          },
                          child: Container(
                            width: 105,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppConstants.primaryColor : AppConstants.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? Colors.transparent : Colors.white10,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppConstants.primaryColor.withAlpha(102),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icon,
                                  color: isSelected ? Colors.white : AppConstants.primaryColor,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  vehicle,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.white : AppConstants.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Weight Control Card
                  Text(
                    l10n.weightLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.scale, color: AppConstants.primaryColor),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.weightDisplay(_weight.round()),
                                style: const TextStyle(
                                  color: AppConstants.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              height: 36,
                              child: TextField(
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppConstants.textPrimary, fontSize: 14),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white10),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppConstants.primaryColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black26,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppConstants.primaryColor,
                            inactiveTrackColor: Colors.white10,
                            thumbColor: Colors.white,
                            overlayColor: AppConstants.primaryColor.withAlpha(51),
                          ),
                          child: Slider(
                            value: _weight,
                            min: 1.0,
                            max: 2000.0,
                            onChanged: (val) {
                              setState(() {
                                _weight = val;
                                _weightController.text = val.round().toString();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Real-time Pricing Summary Card (Dynamic Pricing display)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppConstants.cardColor, AppConstants.primaryColor.withAlpha(26)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppConstants.primaryColor.withAlpha(51)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.calculatedPrice,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppConstants.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${price.toStringAsFixed(2)} ${l10n.currency}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.accentColor,
                              ),
                            ),
                          ],
                        ),
                        provider.isLoading
                            ? const CircularProgressIndicator(color: AppConstants.primaryColor)
                            : ElevatedButton.icon(
                                onPressed: _submitOrder,
                                icon: const Icon(Icons.send_rounded, size: 18),
                                label: Text(l10n.placeOrderButton),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConstants.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }
}
