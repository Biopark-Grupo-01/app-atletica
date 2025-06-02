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

class TrainingsRegistrationForm extends StatefulWidget {
  const TrainingsRegistrationForm({super.key});

  @override
  State<TrainingsRegistrationForm> createState() =>
      _TrainingsRegistrationFormState();
}

class _TrainingsRegistrationFormState extends State<TrainingsRegistrationForm> {
  File? _imageUrl;
  final _formKey = GlobalKey<FormState>();

  final List<DropdownMenuItem<String>> type = [
    const DropdownMenuItem(value: 'Treinos', child: Text('Treinos')),
    const DropdownMenuItem(value: 'Amistosos', child: Text('Amistosos')),
  ];

  final List<DropdownMenuItem<String>> sports = [
    const DropdownMenuItem(value: 'Futebol', child: Text('Futebol')),
    const DropdownMenuItem(value: 'Basquete', child: Text('Basquete')),
    const DropdownMenuItem(value: 'Volei', child: Text('Vôlei')),
    const DropdownMenuItem(value: 'Handebol', child: Text('Handebol')),
    const DropdownMenuItem(value: 'Natacao', child: Text('Natação')),
    const DropdownMenuItem(value: 'Tenis', child: Text('Tênis')),
  ];

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
                          child: const CustomTitleForms(
                            title: 'CADASTRO DE TREINOS E AMISTOSOS',
                          ),
                        ),
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
                        const SizedBox(height: 20),
                        CustomTextField(label: 'Título', icon: Icons.create),
                        CustomTextField(
                          label: 'Data',
                          icon: Icons.calendar_today,
                        ),
                        CustomTextField(
                          label: 'Local',
                          icon: Icons.location_on,
                        ),
                        const SizedBox(height: 15),
                        CustomDropdown(
                          label: 'Esporte',
                          icon: Icons.sports_baseball,
                          items: sports,
                        ),
                        const SizedBox(height: 15),
                        CustomDropdown(
                          label: 'Tipo',
                          icon: Icons.interests,
                          items: type,
                        ),
                        const SizedBox(height: 15),
                        CustomTextBox(),
                        const SizedBox(height: 25),
                        Center(
                          child: CustomButton(
                            text: 'Salvar',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
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
