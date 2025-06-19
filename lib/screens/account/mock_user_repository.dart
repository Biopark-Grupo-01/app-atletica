import 'dart:async';
import '../../models/user_model.dart';


class MockUserRepository {
  static final MockUserRepository _instance = MockUserRepository._internal();

  factory MockUserRepository() => _instance;

  MockUserRepository._internal();

  UserModel? _user;

  Future<void> saveUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _user = user;
  }

  Future<UserModel?> getUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _user;
  }

  Future<void> updateUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _user = user;
  }
}
