import 'package:auth_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ5dHVxeG96ZGxsY2V4emlxb3pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3MTA1NjcsImV4cCI6MjA2MzI4NjU2N30.xsZ1E84UiCB7D7ecFiAZsXN_zbq3HfZQYGa2zWcySPI',
    url: 'https://rytuqxozdllcexziqozg.supabase.co',
  );
  runApp(AuthApp());
}

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
