import 'package:flutter/material.dart';
import 'package:mobile_app/screens/privacy_policy_screen.dart';
import 'package:mobile_app/services/shared_preferences_service.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  const PrivacyPolicyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Welcome to MysteryMunch!'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Before you start using MysteryMunch, please review our privacy policy.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'We collect:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Location data to find nearby restaurants'),
            const Text('• Basic account information'),
            const SizedBox(height: 16),
            const Text(
              'By continuing, you agree to our privacy policy and terms of service.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('DECLINE'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('ACCEPT'),
        ),
      ],
    );
  }

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PrivacyPolicyDialog(),
    );

    if (result == true) {
      await SharedPreferencesService.setPrivacyPolicyAccepted();
    }

    return result ?? false;
  }
}
