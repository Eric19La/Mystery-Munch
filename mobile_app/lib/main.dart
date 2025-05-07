import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'controllers/filter_provider.dart';
import 'services/shared_preferences_service.dart';
import 'widgets/privacy_policy_dialog.dart';
import 'package:flutter/services.dart';

// Global key for the navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Main function to run the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  await dotenv.load(); // Load environment variables from .env file

  // Run the app with the filter provider
  runApp(
    ChangeNotifierProvider(
      create: (_) => FilterProvider(),
      child: const MyApp(),
    ),
  );
}

// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Mystery Munch',
      theme: ThemeData(colorSchemeSeed: Colors.amber[50]),
      debugShowCheckedModeBanner: false,
      home: const PrivacyPolicyWrapper(),
    );
  }
}

class PrivacyPolicyWrapper extends StatefulWidget {
  const PrivacyPolicyWrapper({super.key});

  @override
  State<PrivacyPolicyWrapper> createState() => _PrivacyPolicyWrapperState();
}

class _PrivacyPolicyWrapperState extends State<PrivacyPolicyWrapper> {
  @override
  void initState() {
    super.initState();
    _checkPrivacyPolicy();
  }

  Future<void> _checkPrivacyPolicy() async {
    final hasAccepted =
        await SharedPreferencesService.hasAcceptedPrivacyPolicy();
    if (!hasAccepted && mounted) {
      final accepted = await PrivacyPolicyDialog.show(context);
      if (!accepted && mounted) {
        // If user declines, show a message and exit the app
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                title: const Text('Privacy Policy Required'),
                content: const Text(
                  'You must accept the privacy policy to use MysteryMunch.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      SystemNavigator.pop();
                    },
                    child: const Text('EXIT'),
                  ),
                ],
              ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
