import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';

abstract class UserRemoteDataSource {
  Future<List> getUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<List> getUsers() async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: AppConstants.connectionTimeout),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final results = jsonResponse['results'] as List;
        return results.map((user) => UserModel.fromJson(user)).toList();
      } else {
        throw ServerException('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to fetch users: ${e.toString()}');
    }
  }
}