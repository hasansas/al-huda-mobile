import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../app_config.dart';
import '../data_model/blog_mode.dart';
import '../helpers/shared_value_helper.dart';

class BlogProvider with ChangeNotifier {
  List<BlogModel> _blogs = [];

  List<BlogModel> get blogs {
    return _blogs;
  }

  Future<void> fetchBlogs() async {
    final url = ("${AppConfig.BASE_URL}/blog-list");
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "System-Key": AppConfig.system_key
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List<BlogModel> loadedBlogs = [];
      jsonData['blogs']['data'].forEach((blogData) {
        loadedBlogs.add(BlogModel.fromJson(blogData));
      });
      _blogs = loadedBlogs;
      notifyListeners();
    } else {
      print('Failed to load blogs');
    }
  }
}
