import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_atletica/utils/utils.dart';

class EventsNewsService {
  static Future<Map<String, List<Map<String, String>>>> loadData(BuildContext context) async {
    final allItems = [
      {
        'imageUrl': 'assets/images/evento01.png',
        'date': '31/04/2025',
        'location': 'Toledo',
        'title': 'Minigames',
        'description': 'Venha Participar de vários jogos da atlética!! Teremos bebidas e muita festa e diversao.',
        'type': 'evento',
      },
      {
        'imageUrl': 'assets/images/evento02.png',
        'date': '31/04/2025',
        'location': 'Toledo',
        'title': 'Estuda Que Passa',
        'description': 'Evento Open Gummy, muita festa e interacao entre os socios da atletica',
        'type': 'evento',
      },
      {
        'imageUrl': 'assets/images/noticia01.png',
        'date': '31/04/2025',
        'location': 'Toledo',
        'title': 'Inscricoes Tigre Branco',
        'description': 'Seja sócio do Tigrao, inscricoes abertas para participar da atletica tigre branco',
        'type': 'noticia',
      },
      {
        'imageUrl': 'assets/images/noticia02.png',
        'date': '31/04/2025',
        'location': 'Toledo',
        'title': 'Estágio Atletica Tigre Branco',
        'description': 'Seja mais que sócio, seja estagiario e nos ajude a organizar os melhores eventos.',
        'type': 'noticia',
      },
    ];

    final trainings = [
      {
        'type': 'TREINOS',
        'category': 'Futebol',
        'date': '31/04/2025',
        'location': 'Toledo',
        'title': 'Treino',
        'description': 'Treino Contra Raposa',
      },
      {
        'type': 'TREINOS',
        'category': 'Futebol',
        'date': '01/05/2025',
        'location': 'Toledo',
        'title': 'Treino Técnico',
        'description': 'Treino entre sócios.',
      },
      {
        'type': 'TREINOS',
        'category': 'Basquete',
        'date': '03/05/2025',
        'location': 'Ginásio Central',
        'title': 'Treino de Arremesso',
        'description': 'Foco em fundamentos e agilidade.',
      },
      {
        'type': 'AMISTOSOS',
        'category': 'Futebol',
        'date': '05/05/2025',
        'location': 'Estádio Tigre',
        'title': 'Amistoso com Raposa',
        'description': 'Jogo preparatório para o torneio.',
      },
      {
        'type': 'AMISTOSOS',
        'category': 'Handebol',
        'date': '06/05/2025',
        'location': 'Quadra Poliesportiva',
        'title': 'Amistoso Interatléticas',
        'description': 'Confronto entre Tigre e Leões.',
      },
      {
        'type': 'AMISTOSOS',
        'category': 'Vôlei',
        'date': '08/05/2025',
        'location': 'Ginásio do Biopark',
        'title': 'Amistoso da Amizade',
        'description': 'Jogo especial com convidados.',
      },
    ];

    final onlyEvents = allItems.where((item) => item['type'] == 'evento').toList();
    final onlyNews = allItems.where((item) => item['type'] == 'noticia').toList();

    return {
      'events': onlyEvents,
      'news': onlyNews,
      'trainings': trainings,
    };
  }
}
