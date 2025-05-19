import 'dart:io';
import 'package:app_atletica/widgets/forms/profile_custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';

class ProfileRegistrationForm extends StatefulWidget {
  const ProfileRegistrationForm({super.key});

  @override
  State<ProfileRegistrationForm> createState() =>
      _ProfileRegistrationFormState();
}

class _ProfileRegistrationFormState extends State<ProfileRegistrationForm> {
  File? _imageUrl;
  final _formKey = GlobalKey<FormState>();

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
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: const CustomTitleForms(
                            title: 'CADASTRO DE PERFIL',
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
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
                        CustomTextFieldProfile(
                          label: 'Nome: ',
                          icon: Icons.create,
                        ),
                        CustomTextFieldProfile(
                          label: 'CPF: ',
                          icon: Icons.create,
                        ),
                        CustomTextFieldProfile(
                          label: 'E-mail: ',
                          icon: Icons.create,
                        ),
                        CustomTextFieldProfile(
                          label: 'Senha: ',
                          icon: Icons.create,
                        ),
                        DropdownButtonFormField<String>(
                          value: null,
                          decoration: InputDecoration(
                            labelText: 'Cargo',
                            labelStyle: TextStyle(color: AppColors.white),
                            
                          ),
                          dropdownColor: AppColors.blue,
                          style: TextStyle(color: AppColors.white),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.white,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'NaoAssociado',
                              child: Text('Não associado'),
                            ),
                            DropdownMenuItem(
                              value: 'Associado',
                              child: Text('Associado'),
                            ),
                            DropdownMenuItem(
                              value: 'Diretoria',
                              child: Text('Diretoria'),
                            ),
                          ],
                          onChanged: (String? newValue) {
                          },
                        ),
                        const SizedBox(height: 45),
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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          // Handle bottom navigation tap
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/trainings');
              break;
            case 2:
              Navigator.pushNamed(context, '/store');
              break;
            case 3:
              Navigator.pushNamed(context, '/events');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
