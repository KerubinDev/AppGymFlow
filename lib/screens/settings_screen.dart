import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Tema'),
            subtitle: const Text('Alterar tema do aplicativo'),
            onTap: () => _showThemeDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            subtitle: const Text('Configurar lembretes'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Em desenvolvimento')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'GymFlow',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.fitness_center,
                  size: 50,
                  color: Colors.blue,
                ),
                children: const [
                  Text('Um aplicativo para acompanhamento de treinos'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolher Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Sistema'),
                value: ThemeMode.system,
                groupValue: Provider.of<ThemeProvider>(context).themeMode,
                onChanged: (value) {
                  if (value != null) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Claro'),
                value: ThemeMode.light,
                groupValue: Provider.of<ThemeProvider>(context).themeMode,
                onChanged: (value) {
                  if (value != null) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Escuro'),
                value: ThemeMode.dark,
                groupValue: Provider.of<ThemeProvider>(context).themeMode,
                onChanged: (value) {
                  if (value != null) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
} 