import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduan_test/core/services/shared_pref_services.dart';
import 'package:graduan_test/features/posts/models/post.dart';
import 'package:graduan_test/features/posts/services/post_service.dart';
import 'package:graduan_test/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService postService = PostService();
  late Future<List<Post>> futurePosts;
  final hasToken = SharedPreferencesService().hasToken();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  _createPost() async {
    final title = _titleController.text;
    try {
      await postService.createPost(title: title);
      setState(() {
        futurePosts = postService.fetchPosts();
      });
    } catch (e) {
      log(e.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _editProfile() {
    if (!hasToken) {
      _routingToLogin();
    } else {
      Navigator.pushNamed(context, '/profile');
    }
  }

  _handleFloatingButton() {
    if (!hasToken) {
      _routingToLogin();
    } else {
      showBottomSheet();
    }
  }

  _routingToLogin() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.person_outline_sharp,
                size: 30,
              ),
              tooltip: 'Profile',
              onPressed: _editProfile),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleFloatingButton,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Post>>(
        future: postService.fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available'));
          } else {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(posts[index].title!),
                  subtitle: Text(
                    formatDate(posts[index].createdAt!.toString()),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<dynamic> showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 15.0,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Post',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _createPost();
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Post'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
