#!/bin/bash

echo "🚀 Iniciando build do GymFlow..."

# Cria novo projeto
echo "📁 Criando novo projeto..."
cd ..
rm -rf app_gym_flow
flutter create -t app app_gym_flow

# Copia os arquivos do projeto atual
echo "📋 Copiando arquivos..."
cp -r AppGymFlow/lib/* app_gym_flow/lib/
cp AppGymFlow/pubspec.yaml app_gym_flow/

# Entra no novo projeto
cd app_gym_flow

# Get dependencies
echo "📦 Instalando dependências..."
flutter pub get

# Build APK
echo "🛠️ Gerando APK..."
flutter build apk --debug

# Copia o APK para a raiz do projeto
echo "📱 Preparando APK para download..."
cp build/app/outputs/flutter-apk/app-debug.apk ./gymflow.apk

echo "✅ Build concluído!"
echo "📲 Seu APK está pronto em: app_gym_flow/gymflow.apk"
echo "💡 Para baixar, clique com o botão direito em 'gymflow.apk' no explorador de arquivos e selecione 'Download'" 