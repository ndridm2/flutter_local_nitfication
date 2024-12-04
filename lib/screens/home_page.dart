import 'package:flutter/material.dart';
import 'package:myapp/services/notification_service.dart';
import 'package:myapp/widgets/date_time_selector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationService _notificationService = NotificationService();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _scheduleNotification() async {
    final DateTime scheduleDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedDate.hour,
      selectedDate.minute,
    );

    if (scheduleDateTime.isBefore(DateTime.now())) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a future date and time'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    await _notificationService.scheduleNotification(scheduleDateTime);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Notification scheduled for ${selectedDate.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _updateDateTime(DateTime newDate, TimeOfDay newTime) {
    setState(() {
      selectedDate = newDate;
      selectedTime = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1934440782.
      appBar: AppBar(
        title: const Text('Example Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Instant Notifications",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _notificationService.showInstantNotification,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12)),
              child: const Text("Send Instant Notification"),
            ),
            const SizedBox(height: 24),
            const Text(
              "Schedule Notifications",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DateTimeSelector(
              selectedDate: selectedDate,
              selectedTime: selectedTime,
              onDateTimeChanged: _updateDateTime,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _scheduleNotification,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12)),
              child: const Text("Schedule Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
