#!/bin/bash

echo "🚀 Iniciando build do GymFlow..."

# Limpa builds anteriores
echo "🧹 Limpando builds anteriores..."
flutter clean

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
echo "📲 Seu APK está pronto: gymflow.apk"
echo "💡 Para baixar, clique com o botão direito em 'gymflow.apk' no explorador de arquivos e selecione 'Download'" 