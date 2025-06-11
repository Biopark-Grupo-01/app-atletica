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

class NewsRegistrationForm extends StatefulWidget {
  const NewsRegistrationForm({super.key});

  @override
  State<NewsRegistrationForm> createState() => _NewsRegistrationFormState();
}

class _NewsRegistrationFormState extends State<NewsRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

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
                        const Center(
                          child: CustomTitleForms(title: 'CADASTRO DE NOTÍCIA'),
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
