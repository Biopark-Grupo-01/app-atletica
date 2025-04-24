import 'package:flutter/material.dart';
import 'package:app_atletica/widgets/custom_button.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void _recoverPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Simulação de recuperação de senha (substituir por chamada de API)
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });

        // Exemplo: Mostrar um snackbar para confirmar o envio
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Instruções de recuperação enviadas para o email!')),
        );

        Navigator.pop(context); // Volta para a tela de login
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Recuperação de Senha',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Digite seu email cadastrado e enviaremos instruções para redefinir sua senha.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Insira um email válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary)
                  : CustomButton(
                      text: 'Recuperar Senha',
                      onPressed: _recoverPassword,
                    ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/'),
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}