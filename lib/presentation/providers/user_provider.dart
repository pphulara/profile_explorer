import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users.dart';

enum UserStateStatus { initial, loading, loaded, error }

class UserProvider with ChangeNotifier {
  final GetUsers getUsers;

  UserProvider({required this.getUsers});

  UserStateStatus _status = UserStateStatus.initial;
  List _users = [];
  List _filteredUsers = [];
  String _errorMessage = '';
  String? _selectedCountry;
  List _availableCountries = [];

  UserStateStatus get status => _status;
  List get users => _filteredUsers.isNotEmpty ? _filteredUsers : _users;
  String get errorMessage => _errorMessage;
  String? get selectedCountry => _selectedCountry;
  List get availableCountries => _availableCountries;

  Future fetchUsers() async {
    _status = UserStateStatus.loading;
    notifyListeners();

    final result = await getUsers();

    result.fold(
      (failure) {
        _status = UserStateStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (fetchedUsers) {
        _users = fetchedUsers;
        _filteredUsers = [];
        _selectedCountry = null;
        _extractCountries();
        _status = UserStateStatus.loaded;
        notifyListeners();
      },
    );
  }

  void _extractCountries() {
    final countries = _users.map((user) => user.country).toSet().toList();
    countries.sort();
    _availableCountries = countries;
  }

  void filterByCountry(String? country) {
    _selectedCountry = country;
    if (country == null || country.isEmpty) {
      _filteredUsers = [];
    } else {
      _filteredUsers = _users.where((user) => user.country == country).toList();
    }
    notifyListeners();
  }

  void toggleLike(String userId) {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex != -1) {
      _users[userIndex].isLiked = !_users[userIndex].isLiked;
      
      if (_filteredUsers.isNotEmpty) {
        final filteredIndex = _filteredUsers.indexWhere((user) => user.id == userId);
        if (filteredIndex != -1) {
          _filteredUsers[filteredIndex].isLiked = _users[userIndex].isLiked;
        }
      }
      
      notifyListeners();
    }
  }

  UserEntity? getUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }
}