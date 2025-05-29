import 'package:auth_app/screens/edit_user_form.dart';
import 'package:auth_app/widgets/custom_bottom.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String? username;
  bool showEditingForm = false;

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  Future<void> fetchUserInfo() async {
    final user =  Supabase.instance.client.auth.currentUser;
    final metadata =  user?.userMetadata;

    setState(() {
      username = metadata?['username'] ?? 'Unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('User Info'), backgroundColor: Colors.blue),
        body: Center(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hello'),
                SizedBox(height: 26),

                Text('Ur user name is : $username '),
                SizedBox(height: 26),
                CustomBottom(
                  text: showEditingForm ? 'Close' : 'Edit user name',
                  onTab: () {
                    setState(() {
                      showEditingForm = !showEditingForm;
                    });
                  },
                ),
                if (showEditingForm) ...[
                  SizedBox(height: 20),
                  EditUserForm(onUsernameUpdated: fetchUserInfo),
                ],
                SizedBox(height: 26),
                CustomBottom(text: 'Sign out'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
