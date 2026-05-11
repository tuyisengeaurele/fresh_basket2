import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/order_model.dart';
import '../../providers/order_provider.dart';
import 'widgets/delivery_stages_bar.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  GoogleMapController? _mapController;
  Duration _eta = const Duration(hours: 2);
  Timer? _etaTimer;
  final _defaultLocation = const LatLng(-1.9441, 30.0619); // Kigali

  @override
  void initState() {
    super.initState();
    context.read<OrderProvider>().watchOrder(widget.orderId);
    _startEtaCountdown();
  }

  void _startEtaCountdown() {
    _etaTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_eta.inSeconds > 0 && mounted) {
        setState(() => _eta -= const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    _etaTimer?.cancel();
    _mapController?.dispose();
    context.read<OrderProvider>().stopTracking();
    super.dispose();
  }

  Set<Marker> _buildMarkers(OrderModel? order) {
    final markers = <Marker>{};
    if (order?.driverLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: LatLng(
            order!.driverLocation!.latitude,
            order.driverLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Your Delivery Driver'),
        ),
      );
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            order.driverLocation!.latitude,
            order.driverLocation!.longitude,
          ),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderProvider>().activeOrder;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(order != null
            ? 'Order ${order.displayId}'
            : 'Order Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent_outlined),
            tooltip: 'Call Support',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Call support: +250 788 000 000')),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Map
          SizedBox(
            height: 280,
            child: GoogleMap(
              onMapCreated: (ctrl) => _mapController = ctrl,
              initialCameraPosition: CameraPosition(
                target: _defaultLocation,
                zoom: 14,
              ),
              markers: _buildMarkers(order),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
            ),
          ),

          // Details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ETA Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            color: Colors.white, size: 32),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimated Time',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              Formatters.countdown(_eta),
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: Colors.white,
                                fontSize: 28,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (order != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              order.status.label,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stages bar
                  if (order != null)
                    DeliveryStagesBar(
                      status: order.status,
                      createdAt: order.createdAt,
                    ),
                  const SizedBox(height: 24),

                  // Delivery address
                  if (order != null) ...[
                    Text('Delivery Address', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.address.fullAddress,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
