import 'package:firebase_auth/firebase_auth.dart';

// The account that gets the admin panel and can manage transport posts.
// Keep this in sync with `adminEmail()` in firestore.rules, which is what
// actually enforces admin-only writes.
const String adminEmail = 'admin_lu@gmail.com';

bool isAdminUser(User? user) => user != null && user.email == adminEmail;
