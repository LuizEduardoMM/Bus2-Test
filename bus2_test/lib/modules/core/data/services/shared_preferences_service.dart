import 'dart:convert';

import 'package:bus2_test/modules/core/data/services/prefences_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';
import '../models/user_model.dart';

@Singleton(as: PreferencesService)
class SharedPreferencesService implements PreferencesService {
  static const String _favoritesKey = 'favorites';

  @override
  Future<void> saveFavorite(User user) async {
    final prefs = await SharedPreferences.getInstance();

    final List<User> favorites = await getFavorites();

    if (favorites.any((u) => u.uuid == user.uuid)) {
      return;
    }

    final newUserModel = UserModel.fromEntity(user);

    favorites.add(newUserModel);

    final jsonList = favorites.map((u) {
      return jsonEncode((u as UserModel).toJson());
    }).toList();

    await prefs.setStringList(_favoritesKey, jsonList);
  }

  @override
  Future<void> removeFavorite(String userId) async {
    final prefs = await SharedPreferences.getInstance();

    final List<User> favorites = await getFavorites();

    favorites.removeWhere((u) => u.uuid == userId);

    final jsonList = favorites.map((u) {
      return jsonEncode((u as UserModel).toJson());
    }).toList();

    await prefs.setStringList(_favoritesKey, jsonList);
  }

  @override
  Future<List<User>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favoritesKey) ?? [];

    return jsonList.map((json) => UserModel.fromJson(jsonDecode(json))).toList();
  }
}
