import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/forms/custom_text_field.dart';
import 'package:app_atletica/widgets/forms/custom_text_box.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';

class EventRegistrationForm extends StatefulWidget {
  const EventRegistrationForm({super.key});

  @override
  State<EventRegistrationForm> createState() => _EventRegistrationFormState();
}

class _EventRegistrationFormState extends State<EventRegistrationForm> {
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
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const CustomTitleForms(title: 'CADASTRO DE EVENTO'),
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
                        CustomTextField(label: 'Título', icon: Icons.edit),
                        CustomTextField(
                          label: 'Data',
                          icon: Icons.calendar_today,
                        ),
                        CustomTextField(
                          label: 'Valor',
                          icon: Icons.attach_money,
                        ),
                        CustomTextField(
                          label: 'Local',
                          icon: Icons.location_on,
                        ),
                        const SizedBox(height: 15),
                        CustomTextBox(),
                        const SizedBox(height: 25),
                        Center(
                          child: CustomButton(
                            text: 'Salvar',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushNamed(context, '/home');
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
