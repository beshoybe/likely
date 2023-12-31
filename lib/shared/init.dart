import 'package:firebase_core/firebase_core.dart';
import 'package:grad/firebase_options.dart';

Future<void> init() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
