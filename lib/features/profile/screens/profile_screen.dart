import 'package:flutter/material.dart';
import 'package:graduan_test/features/profile/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  dynamic _userInfo;

  _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await ProfileService().updateUserInfo(name: _nameController.text);
        if (response == 'Updated') {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
      setState(() {});
    }
  }

  _logout() async {
    final response = await ProfileService().logout();
    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged out successfully')),
      );
      setState(() {});
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/'));
    }
  }

  _fetchUserInfo() async {
    try {
      var userInfo = await ProfileService().fetchUserInfo();
      setState(() {
        _userInfo = userInfo;
        _nameController.text = userInfo.name!;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user info')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _userInfo == null
                  ? Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: Column(
                        spacing: 16.0,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: _userInfo.email,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _nameController,
                            builder: (context, value, child) {
                              final isChanged = value.text != _userInfo.name;
                              return ElevatedButton(
                                onPressed: isChanged ? _updateProfile : null,
                                child: Text('Update'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _logout,
                child: Text('Logout', style: TextStyle(color: Colors.red, fontSize: 16.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
