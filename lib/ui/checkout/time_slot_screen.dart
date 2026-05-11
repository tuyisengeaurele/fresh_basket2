import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/user_model.dart';
import '../../app/routes.dart';

class TimeSlotScreen extends StatefulWidget {
  final UserAddress address;

  const TimeSlotScreen({super.key, required this.address});

  @override
  State<TimeSlotScreen> createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {
  static const _slots = [
    '8:00 AM – 10:00 AM',
    '10:00 AM – 12:00 PM',
    '12:00 PM – 2:00 PM',
    '2:00 PM – 4:00 PM',
    '4:00 PM – 6:00 PM',
  ];

  int _selectedDay = 0; // 0 = today, 1 = tomorrow
  String? _selectedSlot;

  String _dayLabel(int offset) {
    final d = DateTime.now().add(Duration(days: offset));
    if (offset == 0) return 'Today • ${DateFormat('EEE, MMM d').format(d)}';
    if (offset == 1) return 'Tomorrow • ${DateFormat('EEE, MMM d').format(d)}';
    return DateFormat('EEE, MMM d').format(d);
  }

  bool _isSlotAvailable(String slot) {
    if (_selectedDay > 0) return true;
    // For today, disable slots that have already passed
    final now = TimeOfDay.now();
    final start = int.tryParse(slot.split(':').first) ?? 0;
    return now.hour < start;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Select Time Slot')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Day selector
            Text('Delivery Day', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            Row(
              children: [0, 1].map((offset) {
                final isSelected = _selectedDay == offset;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: offset == 0 ? 8 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _selectedDay = offset;
                        _selectedSlot = null;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.divider,
                          ),
                        ),
                        child: Text(
                          _dayLabel(offset),
                          style: AppTextStyles.titleLarge.copyWith(
                            color:
                                isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Time slots
            Text('Available Slots', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            ..._slots.map((slot) {
              final available = _isSlotAvailable(slot);
              final isSelected = _selectedSlot == slot;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: available
                      ? () => setState(() => _selectedSlot = slot)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: !available
                          ? AppColors.background
                          : isSelected
                              ? AppColors.chipBackground
                              : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.divider,
                        width: isSelected ? 2 : 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 20,
                          color: !available
                              ? AppColors.textHint
                              : isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            slot,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: !available
                                  ? AppColors.textHint
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (!available)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.divider,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Unavailable',
                              style: AppTextStyles.caption,
                            ),
                          ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.primary, size: 20),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        bottomNavigationBar: _selectedSlot == null
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
                    AppRoutes.payment,
                    arguments: {
                      'address': widget.address,
                      'timeSlot':
                          '${_dayLabel(_selectedDay)}, $_selectedSlot',
                    },
                  ),
                  child: const Text('Continue to Payment'),
                ),
              ),
      );
}
