import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../data/models/user_model.dart';
import '../../data/services/firebase_service.dart';
import '../../providers/auth_provider.dart';
import '../../app/routes.dart';

class AddressPickerScreen extends StatefulWidget {
  const AddressPickerScreen({super.key});

  @override
  State<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
  List<UserAddress> _addresses = [];
  UserAddress? _selected;
  bool _showForm = false;
  bool _locating = false;

  // Form controllers
  final _labelCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _sectorCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      setState(() {
        _addresses = user.addresses;
        if (_addresses.isNotEmpty) _selected = _addresses.first;
      });
    }
  }

  Future<void> _detectLocation() async {
    setState(() => _locating = true);
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        _streetCtrl.text = p.street ?? '';
        _sectorCtrl.text = p.subLocality ?? '';
        _districtCtrl.text = p.locality ?? '';
        _cityCtrl.text = p.administrativeArea ?? 'Kigali';
        _labelCtrl.text = 'Current Location';
      }
    } catch (e) {
      if (mounted) SnackbarHelper.showError(context, 'Could not detect location.');
    }
    if (mounted) setState(() => _locating = false);
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    final address = UserAddress(
      id: const Uuid().v4(),
      label: _labelCtrl.text.trim().isEmpty ? 'Home' : _labelCtrl.text.trim(),
      street: _streetCtrl.text.trim(),
      sector: _sectorCtrl.text.trim(),
      district: _districtCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
    );

    final updated = List<UserAddress>.from(user.addresses)..add(address);
    await FirebaseService.users.doc(user.id).update({
      'addresses': updated.map((a) => a.toMap()).toList(),
    });

    context.read<AuthProvider>().updateUser(user.copyWith(addresses: updated));
    setState(() {
      _addresses = updated;
      _selected = address;
      _showForm = false;
    });
    _clearForm();
  }

  void _clearForm() {
    _labelCtrl.clear();
    _streetCtrl.clear();
    _sectorCtrl.clear();
    _districtCtrl.clear();
    _cityCtrl.clear();
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _streetCtrl.dispose();
    _sectorCtrl.dispose();
    _districtCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Delivery Address'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Saved addresses
            if (_addresses.isNotEmpty) ...[
              Text('Saved Addresses', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 12),
              ..._addresses.map((addr) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _AddressTile(
                      address: addr,
                      isSelected: _selected?.id == addr.id,
                      onTap: () => setState(() => _selected = addr),
                    ),
                  )),
              const SizedBox(height: 16),
            ],

            // Add new address
            if (!_showForm)
              OutlinedButton.icon(
                onPressed: () => setState(() => _showForm = true),
                icon: const Icon(Icons.add_location_outlined, size: 20),
                label: const Text('Add New Address'),
              ),

            if (_showForm) ...[
              Text('New Address', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _labelCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Label (e.g. Home, Work)',
                        prefixIcon: Icon(Icons.label_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _streetCtrl,
                            validator: (v) => v?.isEmpty == true
                                ? 'Street is required'
                                : null,
                            decoration: const InputDecoration(
                              labelText: 'Street / Plot',
                              prefixIcon: Icon(Icons.signpost_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: _locating ? null : _detectLocation,
                          icon: _locating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white),
                                )
                              : const Icon(Icons.my_location_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _sectorCtrl,
                      validator: (v) =>
                          v?.isEmpty == true ? 'Sector is required' : null,
                      decoration: const InputDecoration(
                        labelText: 'Sector',
                        prefixIcon: Icon(Icons.place_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _districtCtrl,
                      validator: (v) =>
                          v?.isEmpty == true ? 'District is required' : null,
                      decoration: const InputDecoration(
                        labelText: 'District',
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cityCtrl,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() => _showForm = false);
                              _clearForm();
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveAddress,
                            child: const Text('Save Address'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        bottomNavigationBar: _selected == null
            ? null
            : Container(
                padding: EdgeInsets.fromLTRB(
                    16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.divider)),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.timeSlot,
                    arguments: _selected,
                  ),
                  child: const Text('Continue to Time Slot'),
                ),
              ),
      );
}

class _AddressTile extends StatelessWidget {
  final UserAddress address;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressTile({
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.chipBackground : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider,
              width: isSelected ? 2 : 0.8,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.location_on_rounded
                    : Icons.location_on_outlined,
                color:
                    isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address.label, style: AppTextStyles.titleLarge),
                    const SizedBox(height: 2),
                    Text(
                      address.fullAddress,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.primary, size: 20),
            ],
          ),
        ),
      );
}
