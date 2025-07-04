import 'package:flutter/foundation.dart' show kIsWeb;

// Configurações do ambiente da aplicação
class AppConfig {
  // URLs de API
  static String get _host => kIsWeb ? 'localhost' : '192.168.1.2';
  static String get devApiUrl => 'http://$_host:3001/api';
  static const String prodApiUrl = 'api.atletica.com/api';
  
  // Flag para usar dados mockados mesmo em ambiente de produção (para testes)
  static const bool useMockData = false;
  
  // Configuração da aplicação
  static const String appName = 'App Atlética';
  static const String appVersion = '1.0.0';
  
  // Definição do ambiente atual (altere para 'production' quando necessário)
  static const Environment environment = Environment.development;
  
  // Retorna a URL da API com base no ambiente
  static String get apiUrl {
    switch (environment) {
      case Environment.development:
        return devApiUrl;
      case Environment.production:
        return prodApiUrl;
    }
  }
}

// Enumeração para ambientes
enum Environment {
  development,
  production,
}
