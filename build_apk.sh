#!/bin/bash

echo "🚀 Iniciando build do GymFlow..."

# Cria novo projeto
echo "📁 Criando novo projeto..."
cd ..
rm -rf temp_app
flutter create -t app temp_app

# Copia os arquivos necessários
echo "📋 Copiando arquivos..."
cp -r AppGymFlow/lib/* temp_app/lib/
cp AppGymFlow/pubspec.yaml temp_app/

# Entra no projeto temporário
cd temp_app

# Get dependencies
echo "📦 Instalando dependências..."
flutter pub get

# Build APK
echo "🛠️ Gerando APK..."
flutter build apk --debug

# Verifica se o build foi bem sucedido
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    # Copia o APK para o projeto original
    echo "📱 Preparando APK para download..."
    cp build/app/outputs/flutter-apk/app-debug.apk ../AppGymFlow/gymflow.apk
    
    echo "✅ Build concluído com sucesso!"
    echo "⬇️ Iniciando download automático..."
    
    # Volta para o diretório original e inicia o download
    cd ../AppGymFlow
    download gymflow.apk
    
    # Limpa o projeto temporário
    cd ..
    rm -rf temp_app
else
    echo "❌ Erro ao gerar o APK"
    cd ../AppGymFlow
    exit 1
fi 