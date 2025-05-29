import 'package:auth_app/widgets/custom_bottom.dart';
import 'package:auth_app/widgets/text_field_item.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? email;
  String? password;
  String? user;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
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
                      'Sign up',
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
                                  user = data;
                                });
                              },
                              labelText: 'User Name',
                              iconData: Icons.account_box,
                            ),
                            SizedBox(height: 14),
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
                                final supabase = Supabase.instance.client;
                                if (formKey.currentState!.validate()) {
                                  isLoading = true;
                                  setState(() {});
                                  try {
                                    await signUpMethod(supabase);
                                    if (!context.mounted) return;
                                    showSnackBar(
                                      context,
                                      'Sign up successful! Go login now.',
                                    );
                                  } on AuthException catch (e) {
                                    if (!context.mounted) return;

                                    if (e.message.contains(
                                      'User already registered',
                                    )) {
                                      showSnackBar(
                                        context,
                                        'account already signed up ',
                                      );
                                    } else {
                                      showSnackBar(
                                        context,
                                        'there was an error ',
                                      );
                                    }
                                  }
                                  isLoading = false;
                                  setState(() {});
                                }
                              },

                              text: 'Sing up',
                            ),

                            SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account? '),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    ' Sign in',
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

  Future<void> signUpMethod(SupabaseClient supabase) async {
    final AuthResponse res = await supabase.auth.signUp(
      email: email!,
      password: password!,
      data: {'username': user!},
    );
  }

  // Future<void> userInfo(SupabaseClient supabase) async {
  //   final session = await supabase.auth.currentUser;
  //   final user = session?.userMetadata;
  //   return user.entries;
  // }
}

// onPressed: () async {

//                       },
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
