import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Last updated: ${DateTime.now().toString().split(' ')[0]}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Information We Collect',
              'MysteryMunch collects the following information:\n\n'
                  '• Location Data: We collect your location to find nearby restaurants and provide location-based services.\n'
                  '• Device Information: Basic device information to ensure proper app functionality.\n'
                  '• User Account Information: When you create an account, we collect your email address and basic profile information.',
            ),
            _buildSection(
              'How We Use Your Information',
              'We use the collected information to:\n\n'
                  '• Provide location-based restaurant recommendations\n'
                  '• Improve our services and user experience\n'
                  '• Send you important updates about the app\n'
                  '• Maintain and improve app security',
            ),
            _buildSection(
              'Data Storage and Security',
              'Your data is stored securely using Firebase services. We implement appropriate security measures to protect your personal information.',
            ),
            _buildSection(
              'Third-Party Services',
              'We use the following third-party services:\n\n'
                  '• Google Maps: For location services and maps\n'
                  '• Firebase: For authentication and data storage\n'
                  'These services have their own privacy policies.',
            ),
            _buildSection(
              'Your Rights',
              'You have the right to:\n\n'
                  '• Access your personal data\n'
                  '• Request deletion of your data\n'
                  '• Opt-out of location services\n'
                  '• Contact us with privacy concerns',
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () async {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'support@mysterymunch.com',
                    queryParameters: {'subject': 'Privacy Policy Inquiry'},
                  );
                  if (await canLaunchUrl(emailLaunchUri)) {
                    await launchUrl(emailLaunchUri);
                  }
                },
                child: const Text('Contact Us'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }
}
