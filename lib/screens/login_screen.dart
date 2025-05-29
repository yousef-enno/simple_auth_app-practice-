import 'package:auth_app/screens/info_screen.dart';
import 'package:auth_app/screens/sign_up_screen.dart';
import 'package:auth_app/widgets/custom_bottom.dart';
import 'package:auth_app/widgets/text_field_item.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  final supabase = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: Color(0xFFf6f7f8),
          body: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(height: 125),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign in',
                      style: TextStyle(color: Colors.black, fontSize: 36),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 22,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFieldItem(
                              onChanged: (data) {
                                setState(() {
                                  email = data;
                                });
                              },
                              labelText: 'Email',
                              iconData: Icons.email,
                            ),
                            SizedBox(height: 14),
                            TextFieldItem(
                              onChanged: (data) {
                                setState(() {
                                  password = data;
                                });
                              },
                              labelText: 'Password',
                              iconData: Icons.lock,
                            ),
                            SizedBox(height: 14),
                            CustomBottom(
                              onTab: () async {
                                if (formKey.currentState!.validate()) {
                                  isLoading = true;
                                  setState(() {});
                                  try {
                                    await signInMethod(supabase);
                                    if (!context.mounted) return;
                                    showSnackBar(context, 'Done');
                                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return InfoScreen();
                                    },
                                  ),
                                );
                                  } on AuthApiException catch (e) {
                                    if (e.message.contains(
                                      'Invalid login credentials',
                                    )) {
                                      showSnackBar(
                                        context,
                                        'invalid Email or Password',
                                      );
                                    }
                                  }
                                  isLoading = false;
                                  setState(() {});
                                     
                                }

                             
                              },

                              text: 'Sign in',
                            ),

                            SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('You don\'t have account? '),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return SignUpScreen();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    ' Sign up',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInMethod(SupabaseClient supabase) async {
    final AuthResponse res = await supabase.auth.signInWithPassword(
      email: email!,
      password: password!,
    );
    final Session? session = res.session;
    final User? user = res.user;
  }
}
