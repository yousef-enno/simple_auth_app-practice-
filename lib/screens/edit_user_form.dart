import 'package:auth_app/widgets/text_field_item.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditUserForm extends StatefulWidget {
  const EditUserForm({super.key, required this.onUsernameUpdated});
  final VoidCallback onUsernameUpdated;
  @override
  State<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    final user = Supabase.instance.client.auth.currentUser;
    final metadata = user?.userMetadata;

    final currentUsername = metadata?['username'] ?? '';

    _usernameController.text = currentUsername;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    }

    return Column(
      children: [
        Form(
          child: TextFieldItem(
            labelText: 'Username',
            iconData: Icons.edit,
            controller: _usernameController,
          ),
        ),
        SizedBox(height: 12),
        IconButton(
          onPressed: () async {
            final newUsername = _usernameController.text.trim();
            if (newUsername.isNotEmpty) {
              await Supabase.instance.client.auth.updateUser(
                UserAttributes(data: {'username': newUsername}),
              );
              await Supabase.instance.client.auth.refreshSession();
              widget.onUsernameUpdated();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Username updated successfully')),
              );
            }
          },
          icon: Icon(Icons.check),
        ),
      ],
    );
  }
}
