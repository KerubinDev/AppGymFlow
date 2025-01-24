import 'package:flutter/material.dart';
import '../config/routes.dart';
import '../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo e título
              const Icon(
                Icons.fitness_center,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 48.0),
              Text(
                'Bem-vindo ao FitTracker',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              Text(
                'Acompanhe seus treinos e evolua com a gente',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48.0),

              // Botões de ação
              CustomButton(
                text: 'Começar',
                onPressed: () => Navigator.pushReplacementNamed(context, Routes.dashboard),
                isPrimary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 