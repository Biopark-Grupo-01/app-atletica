import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para gerenciar o armazenamento e sincronização de dados locais
class LocalStorageService {
  // Chaves para armazenamento local
  static const String _keyNews = 'cached_news';
  static const String _keyEvents = 'cached_events';
  static const String _keyTrainings = 'cached_trainings';
  static const String _keyProducts = 'cached_products';
  static const String _keyCategories = 'cached_categories';
  static const String _keyLastSync = 'last_sync';
  
  // Salvar dados em cache
  static Future<bool> saveData(String key, dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = json.encode(data);
      await prefs.setString(key, jsonData);
      await _updateLastSync();
      return true;
    } catch (e) {
      print('Erro ao salvar dados localmente: $e');
      return false;
    }
  }
  
  // Obter dados do cache
  static Future<dynamic> getData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(key);
      
      if (jsonData == null) {
        return null;
      }
      
      return json.decode(jsonData);
    } catch (e) {
      print('Erro ao obter dados locais: $e');
      return null;
    }
  }
  
  // Atualizar data da última sincronização
  static Future<void> _updateLastSync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().toIso8601String();
      await prefs.setString(_keyLastSync, now);
    } catch (e) {
      print('Erro ao atualizar data de sincronização: $e');
    }
  }
  
  // Verificar se é necessário sincronizar dados
  static Future<bool> shouldSync(Duration maxAge) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSyncStr = prefs.getString(_keyLastSync);
      
      if (lastSyncStr == null) {
        return true;
      }
      
      final lastSync = DateTime.parse(lastSyncStr);
      final now = DateTime.now();
      final difference = now.difference(lastSync);
      
      return difference > maxAge;
    } catch (e) {
      print('Erro ao verificar necessidade de sincronização: $e');
      return true;
    }
  }
  
  // Limpar todos os dados em cache
  static Future<bool> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyNews);
      await prefs.remove(_keyEvents);
      await prefs.remove(_keyTrainings);
      await prefs.remove(_keyProducts);
      await prefs.remove(_keyCategories);
      await prefs.remove(_keyLastSync);
      return true;
    } catch (e) {
      print('Erro ao limpar cache: $e');
      return false;
    }
  }
  
  // Métodos específicos para cada tipo de dado
  
  // Notícias
  static Future<bool> cacheNews(List<dynamic> news) async {
    return saveData(_keyNews, news);
  }
  
  static Future<List<dynamic>?> getCachedNews() async {
    final data = await getData(_keyNews);
    return data != null ? List<dynamic>.from(data) : null;
  }
  
  // Eventos
  static Future<bool> cacheEvents(List<dynamic> events) async {
    return saveData(_keyEvents, events);
  }
  
  static Future<List<dynamic>?> getCachedEvents() async {
    final data = await getData(_keyEvents);
    return data != null ? List<dynamic>.from(data) : null;
  }
  
  // Treinamentos
  static Future<bool> cacheTrainings(List<dynamic> trainings) async {
    return saveData(_keyTrainings, trainings);
  }
  
  static Future<List<dynamic>?> getCachedTrainings() async {
    final data = await getData(_keyTrainings);
    return data != null ? List<dynamic>.from(data) : null;
  }
  
  // Produtos
  static Future<bool> cacheProducts(List<dynamic> products) async {
    return saveData(_keyProducts, products);
  }
  
  static Future<List<dynamic>?> getCachedProducts() async {
    final data = await getData(_keyProducts);
    return data != null ? List<dynamic>.from(data) : null;
  }
  
  // Categorias
  static Future<bool> cacheCategories(List<dynamic> categories) async {
    return saveData(_keyCategories, categories);
  }
  
  static Future<List<dynamic>?> getCachedCategories() async {
    final data = await getData(_keyCategories);
    return data != null ? List<dynamic>.from(data) : null;
  }
}