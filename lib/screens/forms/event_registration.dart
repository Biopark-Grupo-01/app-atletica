import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/services/events_news_service.dart';

class EventRegistrationForm extends StatefulWidget {
  const EventRegistrationForm({super.key});

  @override
  State<EventRegistrationForm> createState() => _EventRegistrationFormState();
}

class _EventRegistrationFormState extends State<EventRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  bool _isEditing = false;
  String? _editingId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Carrega dados de edição se fornecidos
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, String> && !_isEditing) {
      _loadEditingData(arguments);
    }
  }

  void _loadEditingData(Map<String, String> eventData) {
    setState(() {
      _isEditing = true;
      _editingId = eventData['id'];
      _titleController.text = eventData['title'] ?? '';
      _descriptionController.text = eventData['description'] ?? '';
      _placeController.text = eventData['location'] ?? '';
      _priceController.text = eventData['price'] ?? '';
      
      // Formatar data para exibição (de ISO para DD/MM/YYYY)
      if (eventData['date'] != null && eventData['date']!.isNotEmpty) {
        try {
          final dateTime = DateTime.parse(eventData['date']!);
          _dateController.text = '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
          _timeController.text = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
        } catch (e) {
          print('Erro ao parsear data: $e');
          _dateController.text = eventData['date'] ?? '';
        }
      }
    });
  }

  Future<void> _pickImage() async {
    // Mostra um modal para escolher entre galeria e câmera
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.blue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Selecionar Imagem',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1080,
                      imageQuality: 85,
                    );
                    if (picked != null) {
                      final compressedImage = await _compressImage(File(picked.path));
                      setState(() {
                        _imageFile = compressedImage;
                      });
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Imagem selecionada da galeria!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.photo_library,
                        size: 50,
                        color: AppColors.yellow,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Galeria',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1080,
                      imageQuality: 85,
                    );
                    if (picked != null) {
                      final compressedImage = await _compressImage(File(picked.path));
                      setState(() {
                        _imageFile = compressedImage;
                      });
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Foto capturada com sucesso!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: AppColors.yellow,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Câmera',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<File> _compressImage(File file) async {
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      file.path.replaceAll('.jpg', '_compressed.jpg').replaceAll('.png', '_compressed.jpg'),
      quality: 85,
      format: CompressFormat.jpeg,
    );
    return compressedFile != null ? File(compressedFile.path) : file;
  }

  String _formatDateTimeToISO(String date, String time) {
    try {
      // Converte data de DD/MM/YYYY para YYYY-MM-DD
      final dateParts = date.split('/');
      final formattedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
      
      // Converte hora de formato de 12h para 24h se necessário
      final timeParts = time.replaceAll(RegExp(r'[^\d:]'), '').split(':');
      String hour = timeParts[0].padLeft(2, '0');
      String minute = timeParts[1].padLeft(2, '0');
      
      // Se o horário contém AM/PM, ajusta a hora
      if (time.toLowerCase().contains('pm') && hour != '12') {
        hour = (int.parse(hour) + 12).toString();
      } else if (time.toLowerCase().contains('am') && hour == '12') {
        hour = '00';
      }
      
      // Retorna no formato ISO 8601 (UTC)
      return '${formattedDate}T${hour}:${minute}:00Z';
    } catch (e) {
      print('Erro ao formatar data/hora: $e');
      // Fallback para data atual (horário local)
      return DateTime.now().toIso8601String();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: CustomTitleForms(
                            title: _isEditing 
                              ? 'EDITAR EVENTO'
                              : 'CADASTRO DE EVENTO',
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Campo para adicionar imagem
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.image, color: AppColors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Imagem do Evento',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _isLoading ? null : _pickImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _imageFile != null ? Colors.transparent : AppColors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.white.withValues(alpha: 0.3),
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: _imageFile != null
                                      ? Stack(
                                          children: [
                                            Image.file(
                                              _imageFile!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: AppColors.lightGrey,
                                                  child: const Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.image_not_supported,
                                                          size: 50,
                                                          color: Colors.grey,
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          'Erro ao carregar imagem',
                                                          style: TextStyle(color: Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _imageFile = null;
                                                  });
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Imagem removida'),
                                                      backgroundColor: Colors.orange,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.withValues(alpha: 0.8),
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_photo_alternate_outlined,
                                                size: 50,
                                                color: AppColors.white,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Toque para adicionar uma imagem',
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '(Opcional)',
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Título',
                            prefixIcon: Icon(Icons.create, color: AppColors.white),
                            labelStyle: TextStyle(color: AppColors.white),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.yellow, width: 2),
                            ),
                          ),
                          style: TextStyle(color: AppColors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Data',
                            prefixIcon: Icon(Icons.calendar_today, color: AppColors.white),
                            labelStyle: TextStyle(color: AppColors.white),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.yellow, width: 2),
                            ),
                          ),
                          style: TextStyle(color: AppColors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: AppColors.yellow,
                                      onPrimary: Colors.black,
                                      onSurface: AppColors.blue,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _timeController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Horário',
                            prefixIcon: Icon(Icons.access_time, color: AppColors.white),
                            labelStyle: TextStyle(color: AppColors.white),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.yellow, width: 2),
                            ),
                          ),
                          style: TextStyle(color: AppColors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: AppColors.yellow,
                                      onPrimary: Colors.black,
                                      onSurface: AppColors.blue,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              _timeController.text = picked.format(context);
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Valor (R\$)',
                            prefixIcon: Icon(Icons.attach_money, color: AppColors.white),
                            labelStyle: TextStyle(color: AppColors.white),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.yellow, width: 2),
                            ),
                          ),
                          style: TextStyle(color: AppColors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            if (double.tryParse(value.replaceAll(',', '.')) == null) {
                              return 'Digite um valor válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _placeController,
                          decoration: InputDecoration(
                            labelText: 'Local',
                            prefixIcon: Icon(Icons.location_on, color: AppColors.white),
                            labelStyle: TextStyle(color: AppColors.white),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.yellow, width: 2),
                            ),
                          ),
                          style: TextStyle(color: AppColors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Label fora do campo com ícone
                        Row(
                          children: const [
                            Icon(Icons.description, color: AppColors.white),
                            SizedBox(width: 8),
                            Text(
                              'Descrição',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.yellow, width: 2),
                            ),
                          ),
                          style: const TextStyle(color: AppColors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: CustomButton(
                            text: _isLoading 
                              ? (_isEditing ? 'Atualizando...' : 'Salvando...') 
                              : (_isEditing ? 'Atualizar' : 'Salvar'),
                            onPressed: _isLoading
                                ? () {}
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _isLoading = true);
                                      
                                      // Converte o preço para double
                                      final double price = double.tryParse(
                                        _priceController.text.replaceAll(',', '.')
                                      ) ?? 0.0;
                                      
                                      // Formata data e hora para ISO 8601
                                      final String isoDateTime = _formatDateTimeToISO(
                                        _dateController.text,
                                        _timeController.text,
                                      );
                                      
                                      bool success;
                                      if (_isEditing) {
                                        // Atualizar evento existente
                                        success = await EventsNewsService().updateEventWithImage(
                                          eventId: _editingId!,
                                          title: _titleController.text,
                                          description: _descriptionController.text,
                                          date: isoDateTime,
                                          location: _placeController.text,
                                          price: price.toString(),
                                          imageFile: _imageFile,
                                        );
                                      } else {
                                        // Criar evento novo
                                        success = await EventsNewsService().createEventWithImage(
                                          title: _titleController.text,
                                          description: _descriptionController.text,
                                          date: isoDateTime,
                                          location: _placeController.text,
                                          price: price.toString(),
                                          imageFile: _imageFile,
                                        );
                                      }
                                      
                                      setState(() => _isLoading = false);
                                      if (!mounted) return;
                                      
                                      if (success) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(_isEditing 
                                              ? 'Evento atualizado com sucesso!' 
                                              : 'Evento cadastrado com sucesso!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(_isEditing 
                                              ? 'Erro ao atualizar evento!' 
                                              : 'Erro ao cadastrar evento!'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }
}
