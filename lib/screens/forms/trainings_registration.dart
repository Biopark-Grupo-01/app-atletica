import 'dart:io';
import 'package:app_atletica/widgets/forms/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/forms/custom_text_field.dart';
import 'package:app_atletica/widgets/forms/custom_text_box.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/services/training_service.dart';
import 'package:app_atletica/services/match_service.dart';
import 'package:app_atletica/models/training_model.dart';
import 'package:app_atletica/models/match_model.dart';

class TrainingsRegistrationForm extends StatefulWidget {
  const TrainingsRegistrationForm({super.key});

  @override
  State<TrainingsRegistrationForm> createState() =>
      _TrainingsRegistrationFormState();
}

class _TrainingsRegistrationFormState extends State<TrainingsRegistrationForm> {
  File? _imageUrl;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _coachController = TextEditingController();
  final TextEditingController _responsibleController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<DropdownMenuItem<String>> type = [
    const DropdownMenuItem(value: 'Treinos', child: Text('Treinos')),
    const DropdownMenuItem(value: 'Amistosos', child: Text('Amistosos')),
  ];

  List<Map<String, dynamic>> _modalities = [];
  bool _loadingModalities = true;
  String? _selectedSport;
  String? _selectedType;
  String? _selectedModalityId;
  bool _isEditing = false;
  String? _editingId;

  @override
  void initState() {
    super.initState();
    _loadModalities();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Os dados de edição são carregados no _loadModalities após as modalidades serem carregadas
  }

  void _loadEditingData(dynamic eventData) {
    setState(() {
      _isEditing = true;
    });

    if (eventData is Training) {
      final training = eventData;
      _editingId = training.id;
      _titleController.text = training.title;
      _descriptionController.text = training.description;
      _placeController.text = training.place;
      _coachController.text = training.coach;
      _responsibleController.text = training.responsible;
      _selectedType = 'Treinos';
      _selectedSport = training.modality;
      
      // Encontrar o modalityId correspondente
      _selectedModalityId = _modalities.firstWhere(
        (mod) => mod['name'] == training.modality, 
        orElse: () => {}
      )['id'];
      
      // Formatar a data (de YYYY-MM-DD para DD/MM/YYYY)
      try {
        final date = DateTime.parse(training.date);
        _dateController.text = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      } catch (e) {
        _dateController.text = training.date;
      }
      
      // Formatar o horário
      _timeController.text = training.time;
      
    } else if (eventData is Match) {
      final match = eventData;
      _editingId = match.id;
      _titleController.text = match.title;
      _descriptionController.text = match.description;
      _placeController.text = match.place;
      _responsibleController.text = match.responsible;
      _selectedType = 'Amistosos';
      _selectedSport = match.modality;
      
      // Encontrar o modalityId correspondente
      _selectedModalityId = _modalities.firstWhere(
        (mod) => mod['name'] == match.modality, 
        orElse: () => {}
      )['id'];
      
      // Formatar a data (de YYYY-MM-DD para DD/MM/YYYY)
      try {
        final date = DateTime.parse(match.date);
        _dateController.text = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      } catch (e) {
        _dateController.text = match.date;
      }
      
      // Formatar o horário
      _timeController.text = match.time;
    }
  }

  Future<void> _loadModalities() async {
    setState(() {
      _loadingModalities = true;
    });
    final service = TrainingService();
    final modalities = await service.getTrainingModalities();
    setState(() {
      _modalities = modalities;
      _loadingModalities = false;
    });
    
    // Recarregar dados de edição após modalidades carregadas
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && !_isEditing) {
      _loadEditingData(arguments);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageUrl = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Removido MaterialApp para evitar banner de debug
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
                              ? 'EDITAR TREINOS E AMISTOSOS'
                              : 'CADASTRO DE TREINOS E AMISTOSOS',
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: SizedBox(
                              width: double.infinity,
                              height: 250,
                              child: Image.network(
                                _imageUrl != null
                                    ? _imageUrl!.path
                                    : 'https://via.placeholder.com/350x150',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.lightGrey,
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          label: 'Título',
                          icon: Icons.create,
                          controller: _titleController,
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
                        CustomDropdown(
                          label: 'Tipo',
                          icon: Icons.interests,
                          items: type,
                          value: _selectedType,
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Opacity(
                          opacity: _selectedType == 'Treinos' ? 1.0 : 0.5,
                          child: TextFormField(
                            controller: _coachController,
                            enabled: _selectedType == 'Treinos',
                            decoration: InputDecoration(
                              labelText: 'Técnico',
                              prefixIcon: Icon(Icons.person, color: AppColors.white),
                              labelStyle: TextStyle(color: AppColors.white),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: _selectedType == 'Treinos' ? AppColors.white : Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.yellow, width: 2),
                              ),
                              fillColor: _selectedType == 'Treinos' ? Colors.transparent : Colors.grey.withValues(alpha: 0.15),
                              filled: true,
                            ),
                            style: TextStyle(color: _selectedType == 'Treinos' ? AppColors.white : Colors.grey),
                            readOnly: _selectedType != 'Treinos',
                            cursorColor: _selectedType == 'Treinos' ? AppColors.yellow : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _responsibleController,
                          decoration: InputDecoration(
                            labelText: 'Responsável',
                            prefixIcon: Icon(Icons.how_to_reg, color: AppColors.white),
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
                        ),
                        const SizedBox(height: 24),
                        CustomDropdown(
                          label: 'Esporte',
                          icon: Icons.sports_baseball,
                          items: _loadingModalities
                              ? [const DropdownMenuItem<String>(value: '', child: Text('Carregando...'))]
                              : _modalities
                                  .map((mod) => DropdownMenuItem<String>(
                                        value: mod['name'] ?? '',
                                        child: Text(mod['name'] ?? ''),
                                      ))
                                  .toList(),
                          value: _selectedSport,
                          onChanged: (value) {
                            setState(() {
                              _selectedSport = value;
                              _selectedModalityId = _modalities.firstWhere((mod) => mod['name'] == value, orElse: () => {})['id'];
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        CustomTextBox(controller: _descriptionController),
                        const SizedBox(height: 32),
                        Center(
                          child: CustomButton(
                            text: _isEditing ? 'Atualizar' : 'Salvar',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedType == 'Treinos') {
                                  final service = TrainingService();
                                  bool success;
                                  
                                  if (_isEditing) {
                                    // Atualizar treino existente
                                    success = await service.updateTraining(
                                      trainingId: _editingId!,
                                      title: _titleController.text,
                                      description: _descriptionController.text,
                                      place: _placeController.text,
                                      startDate: _dateController.text.split('/').reversed.join('-'),
                                      startTime: _timeController.text.padLeft(8, '0'),
                                      coach: _coachController.text,
                                      responsible: _responsibleController.text,
                                      trainingModalityId: _selectedModalityId ?? '',
                                    );
                                  } else {
                                    success = await service.createTraining(
                                      title: _titleController.text,
                                      description: _descriptionController.text,
                                      place: _placeController.text,
                                      startDate: _dateController.text.split('/').reversed.join('-'),
                                      startTime: _timeController.text.padLeft(8, '0'),
                                      coach: _coachController.text,
                                      responsible: _responsibleController.text,
                                      trainingModalityId: _selectedModalityId ?? '',
                                    );
                                  }
                                  
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(_isEditing 
                                          ? 'Treino atualizado com sucesso!' 
                                          : 'Treino cadastrado com sucesso!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    await Future.delayed(const Duration(milliseconds: 800));
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(_isEditing 
                                          ? 'Erro ao atualizar treino.' 
                                          : 'Erro ao criar treino.'),
                                      ),
                                    );
                                  }
                                } else if (_selectedType == 'Amistosos') {
                                  final service = MatchService();
                                  bool success;
                                  
                                  if (_isEditing) {
                                    // Atualizar amistoso existente
                                    success = await service.updateMatch(
                                      matchId: _editingId!,
                                      title: _titleController.text,
                                      description: _descriptionController.text,
                                      place: _placeController.text,
                                      startDate: _dateController.text.split('/').reversed.join('-'),
                                      startTime: _timeController.text.padLeft(8, '0'),
                                      responsible: _responsibleController.text,
                                      trainingModalityId: _selectedModalityId ?? '',
                                    );
                                  } else {
                                    success = await service.createMatch(
                                      title: _titleController.text,
                                      description: _descriptionController.text,
                                      place: _placeController.text,
                                      startDate: _dateController.text.split('/').reversed.join('-'),
                                      startTime: _timeController.text.padLeft(8, '0'),
                                      responsible: _responsibleController.text,
                                      trainingModalityId: _selectedModalityId ?? '',
                                    );
                                  }
                                  
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(_isEditing 
                                          ? 'Amistoso atualizado com sucesso!' 
                                          : 'Amistoso cadastrado com sucesso!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    await Future.delayed(const Duration(milliseconds: 800));
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(_isEditing 
                                          ? 'Erro ao atualizar amistoso.' 
                                          : 'Erro ao criar amistoso.'),
                                      ),
                                    );
                                  }
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
