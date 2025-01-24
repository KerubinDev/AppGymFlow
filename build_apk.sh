#!/bin/bash

echo "🚀 Iniciando build do GymFlow..."

# Get dependencies
echo "📦 Instalando dependências..."
flutter pub get

# Build APK
echo "🛠️ Gerando APK..."
flutter build apk --debug

# Verifica se o build foi bem sucedido
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    # Copia o APK para a raiz do projeto
    echo "📱 Preparando APK para download..."
    cp build/app/outputs/flutter-apk/app-debug.apk ./gymflow.apk
    
    echo "✅ Build concluído com sucesso!"
    echo "⬇️ Iniciando download automático..."
    
    # Inicia o download automaticamente
    download gymflow.apk
else
    echo "❌ Erro ao gerar o APK"
    exit 1
fi 