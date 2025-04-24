import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:app_atletica/widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  bool isLoading = false;

  void _validateFields() {
    setState(() {
      nameError = nameController.text.isEmpty ? 'Por favor, insira seu nome' : null;
      emailError = emailController.text.isEmpty
          ? 'Por favor, insira seu email'
          : (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)
              ? 'Insira um email válido'
              : null);
      passwordError = passwordController.text.isEmpty
          ? 'Por favor, insira sua senha'
          : (passwordController.text.length < 6
              ? 'A senha deve ter pelo menos 6 caracteres'
              : null);
      confirmPasswordError = confirmPasswordController.text.isEmpty
          ? 'Por favor, confirme sua senha'
          : (confirmPasswordController.text != passwordController.text
              ? 'As senhas não correspondem'
              : null);
    });
  }

  void _register() {
    _validateFields();
    if ([nameError, emailError, passwordError, confirmPasswordError].every((error) => error == null)) {
      setState(() {
        isLoading = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro realizado com sucesso!')),
        );

        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/brasao.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(178, 1, 28, 58),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/aaabe.png',
                    scale: 0.8,
                  ),
                  SizedBox(height: 60),
                  Text(
                    'Registrar-se',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 60),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome Completo',
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber, width: 2),
                      ),
                      errorText: nameError,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.white),
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber, width: 2),
                      ),
                      errorText: emailError,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber, width: 2),
                      ),
                      errorText: passwordError,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirme sua senha',
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber, width: 2),
                      ),
                      errorText: confirmPasswordError,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 60),
                  isLoading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : CustomButton(
                          text: 'Registrar-se',
                          onPressed: _register,
                        ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/'),
                    child: Text('Já tem uma conta? Login'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}