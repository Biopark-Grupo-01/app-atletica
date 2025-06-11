import 'package:flutter/material.dart';
import 'package:app_atletica/services/api_service.dart';

/// Widget que será exibido quando houver erro de conexão com o back-end
class ConnectionErrorWidget extends StatelessWidget {
  final Function onRetry;
  final String message;

  const ConnectionErrorWidget({
    super.key,
    required this.onRetry,
    this.message = 'Não foi possível conectar ao servidor. Verifique sua conexão com a internet.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 80.0,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'Erro de Conexão',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            if (ApiService.useMockData)
              Text(
                'Usando dados de demonstração',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => onRetry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
