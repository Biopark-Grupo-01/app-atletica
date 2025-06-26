import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_atletica/services/auth_service.dart';
import 'package:app_atletica/models/ticket_model.dart';

class TicketService {
  static const String _baseUrl = 'http://localhost:3001/api/tickets';

  // Headers com autenticação
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Listar todos os tickets
  static Future<List<TicketModel>> getAllTickets() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        
        // Verifica se a resposta é um array direto ou um objeto com 'data'
        List<dynamic> ticketsList;
        if (decodedBody is List) {
          ticketsList = decodedBody;
        } else if (decodedBody is Map && decodedBody['data'] is List) {
          ticketsList = decodedBody['data'] as List;
        } else {
          return [];
        }
        
        return ticketsList.map((json) => TicketModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar tickets: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar tickets: $e');
      return [];
    }
  }

  // Buscar tickets por evento
  static Future<List<TicketModel>> getTicketsByEvent(String eventId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/event/$eventId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        
        // Verifica se a resposta é um array direto ou um objeto com 'data'
        List<dynamic> ticketsList;
        if (decodedBody is List) {
          ticketsList = decodedBody;
        } else if (decodedBody is Map && decodedBody['data'] is List) {
          ticketsList = decodedBody['data'] as List;
        } else {
          return [];
        }
        
        return ticketsList.map((json) => TicketModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar tickets do evento: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar tickets do evento: $e');
      return [];
    }
  }

  // Buscar tickets disponíveis por evento
  static Future<List<TicketModel>> getAvailableTicketsByEvent(String eventId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/event/$eventId/available'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        
        // Verifica se a resposta é um array direto ou um objeto com 'data'
        List<dynamic> ticketsList;
        if (decodedBody is List) {
          ticketsList = decodedBody;
        } else if (decodedBody is Map && decodedBody['data'] is List) {
          ticketsList = decodedBody['data'] as List;
        } else {
          // Se não há tickets ou estrutura inesperada, retorna lista vazia
          return [];
        }
        
        return ticketsList.map((json) => TicketModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar tickets disponíveis: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar tickets disponíveis: $e');
      print('Stack trace: ${StackTrace.current}');
      // Retorna lista vazia em caso de erro para não quebrar a UI
      return [];
    }
  }

  // Buscar tickets do usuário
  static Future<List<TicketModel>> getUserTickets(String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/user/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        
        // Verifica se a resposta é um array direto ou um objeto com 'data'
        List<dynamic> ticketsList;
        if (decodedBody is List) {
          ticketsList = decodedBody;
        } else if (decodedBody is Map && decodedBody['data'] is List) {
          ticketsList = decodedBody['data'] as List;
        } else {
          // Se não há tickets, retorna lista vazia
          return [];
        }
        
        return ticketsList.map((json) => TicketModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        // Usuário não tem tickets, retorna lista vazia
        return [];
      } else {
        throw Exception('Erro ao carregar tickets do usuário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar tickets do usuário: $e');
      print('Stack trace: ${StackTrace.current}');
      // Retorna lista vazia em caso de erro para não quebrar a UI
      return [];
    }
  }

  // Criar ticket (para admin)
  static Future<TicketModel> createTicket({
    required String name,
    required String description,
    required double price,
    required String eventId,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'name': name,
        'description': description,
        'price': price,
        'eventId': eventId,
      };

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return TicketModel.fromJson(data);
      } else {
        throw Exception('Erro ao criar ticket: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao criar ticket: $e');
      throw Exception('Erro ao criar ticket');
    }
  }

  // Reservar ticket
  static Future<TicketModel> reserveTicket(String ticketId, String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/$ticketId/reserve/$userId'),
        headers: headers,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return TicketModel.fromJson(data);
      } else {
        throw Exception('Erro ao reservar ticket: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao reservar ticket: $e');
      throw Exception('Erro ao reservar ticket');
    }
  }

  // Comprar ticket (atualizar status para sold)
  static Future<TicketModel> buyTicket(String ticketId, String userId) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'status': 'sold',
        'userId': userId,
      };

      final response = await http.put(
        Uri.parse('$_baseUrl/$ticketId/status'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TicketModel.fromJson(data);
      } else {
        throw Exception('Erro ao comprar ticket: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao comprar ticket: $e');
      throw Exception('Erro ao comprar ticket');
    }
  }

  // Comprar ticket completo (reserva + compra em uma operação)
  static Future<TicketModel> purchaseTicket(String ticketId, String userId) async {
    try {
      // Primeiro reserva o ticket
      return await reserveTicket(ticketId, userId);
      
    } catch (e) {
      print('Erro ao comprar ticket completo: $e');
      throw Exception('Erro ao comprar ticket');
    }
  }

  // Atualizar status do ticket (para admin)
  static Future<TicketModel> updateTicketStatus({
    required String ticketId,
    String? status,
    String? userStatus,
    String? userId,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = <String, dynamic>{};
      
      if (status != null) body['status'] = status;
      if (userStatus != null) body['userStatus'] = userStatus;
      if (userId != null) body['userId'] = userId;

      final response = await http.put(
        Uri.parse('$_baseUrl/$ticketId/status'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TicketModel.fromJson(data);
      } else {
        throw Exception('Erro ao atualizar status do ticket: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao atualizar status do ticket: $e');
      throw Exception('Erro ao atualizar status do ticket');
    }
  }

  // Marcar ticket como pago
  static Future<TicketModel> markTicketAsPaid(String ticketId) async {
    return updateTicketStatus(
      ticketId: ticketId,
      userStatus: 'paid',
    );
  }

  // Marcar ticket como usado
  static Future<TicketModel> markTicketAsUsed(String ticketId) async {
    return updateTicketStatus(
      ticketId: ticketId,
      userStatus: 'used',
    );
  }

  // Marcar ticket como expirado
  static Future<TicketModel> markTicketAsExpired(String ticketId) async {
    return updateTicketStatus(
      ticketId: ticketId,
      userStatus: 'expired',
    );
  }

  // Cancelar ticket
  static Future<TicketModel> cancelTicket(String ticketId) async {
    return updateTicketStatus(
      ticketId: ticketId,
      status: 'cancelled',
    );
  }

  // Tornar ticket disponível novamente
  static Future<TicketModel> makeTicketAvailable(String ticketId) async {
    return updateTicketStatus(
      ticketId: ticketId,
      status: 'available',
      userId: null,
    );
  }

  // Deletar ticket (para admin)
  static Future<bool> deleteTicket(String ticketId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$_baseUrl/$ticketId'),
        headers: headers,
      );

      return response.statusCode == 204;
    } catch (e) {
      print('Erro ao deletar ticket: $e');
      return false;
    }
  }
}
