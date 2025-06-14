import 'package:flutter/material.dart';

/// Um handler global para tratamento de erros não capturados na aplicação
class GlobalErrorHandler {
  // Callback padrão
  static Function(FlutterErrorDetails) _defaultOnError = FlutterError.presentError;
  
  // Flag para indicar se o handler está inicializado
  static bool _initialized = false;
  
  // Inicializa o handler de erro global
  static void initialize({bool showDialog = true}) {
    if (_initialized) return;
    
    // Guarda o callback original
    _defaultOnError = FlutterError.onError ?? FlutterError.presentError;
    
    // Define o novo handler
    FlutterError.onError = (FlutterErrorDetails details) {
      // Sempre imprime o erro no console
      _defaultOnError(details);
      
      // Registra o erro (aqui seria possível enviar para serviços como Firebase Crashlytics)
      _reportError(details.exception, details.stack, details.context.toString());
      
      // Mostra um diálogo, se configurado
      if (showDialog && details.context != null) {
        _showErrorDialog(details);
      }
    };
    
    _initialized = true;
  }
  
  // Relata o erro para um serviço externo (simulado)
  static void _reportError(dynamic error, StackTrace? stackTrace, String context) {
    // Em produção, aqui seria o código para enviar o erro para um serviço de monitoramento
    print('ERRO REPORTADO: $error');
    print('CONTEXTO: $context');
    if (stackTrace != null) {
      print('STACK TRACE: $stackTrace');
    }
  }
  
  // Mostra um diálogo de erro para o usuário
  static void _showErrorDialog(FlutterErrorDetails details) {
    // Aqui seria necessário um BuildContext, então normalmente precisaríamos 
    // usar um GlobalKey ou um NavigatorObserver para obter o BuildContext atual.
    // Essa implementação é apenas um exemplo.
    
    // Neste caso, precisaríamos de uma maneira de mostrar um diálogo sem contexto,
    // o que poderia ser feito com um Overlay personalizado no MaterialApp
    print('Erro que seria mostrado em diálogo: ${details.exception}');
  }
  
  // Método para capturar e tratar erros especificamente na zona de execução
  static Future<void> runWithCaptureErrors(Function() callback) async {
    // Captura erros que ocorrem durante a execução assíncrona
    await runZonedGuarded(
      callback,
      (error, stackTrace) {
        _reportError(error, stackTrace, 'Erro capturado em zona isolada');
      },
    );
  }
  
  // Função auxiliar para runZonedGuarded
  static Future<void> runZonedGuarded(Function() body, Function(dynamic, StackTrace) onError) async {
    try {
      await body();
    } catch (e, stack) {
      onError(e, stack);
    }
  }
}