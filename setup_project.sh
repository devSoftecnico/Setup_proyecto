#!/bin/bash

# Obtener el directorio actual
PROJECT_DIR=$(pwd)

# Verificar que estamos en el directorio del proyecto de Flutter
if [ ! -d "$PROJECT_DIR/android" ]; then
    echo "Este script debe ejecutarse dentro de un proyecto de Flutter."
    exit 1
fi

# 1. Crear key.properties en android/
echo "Creando key.properties en android/..."
cat <<EOL > "$PROJECT_DIR/android/key.properties"
storePassword=310782
keyPassword=310782
keyAlias=upload
storeFile=upload-keystore.jks
EOL

# 2. Copiar archivos proguard-rules.pro y upload-keystore.jks
echo "Copiando archivos desde /Volumes/src/depv_apps/configs/exports/..."
cp /Volumes/src/depv_apps/configs/exports/proguard-rules.pro "$PROJECT_DIR/android/app/"
cp /Volumes/src/depv_apps/configs/exports/upload-keystore.jks "$PROJECT_DIR/android/app/"

# 3. Modificar build.gradle sin sobreescribir namespace y applicationId
echo "Modificando android/app/build.gradle..."
BUILD_GRADLE_PATH="$PROJECT_DIR/android/app/build.gradle"

# Agregar configuraciones al build.gradle si no están presentes
if ! grep -q "compileSdk = 35" "$BUILD_GRADLE_PATH"; then
    echo "Agregando configuración a build.gradle..."
    cat <<EOL >> "$BUILD_GRADLE_PATH"
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile file(keystoreProperties['storeFile'])
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        minifyEnabled true
        shrinkResources false
        signingConfig signingConfigs.release
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'

        ndk {
            debugSymbolLevel 'SYMBOL_TABLE'
        }
    }
}

dependencies {
    implementation "androidx.multidex:multidex:2.0.1"
    implementation 'androidx.media2:media2-session:1.3.0'
}
EOL
fi

# 4. Modificar AndroidManifest.xml
echo "Modificando android/app/src/main/AndroidManifest.xml..."
MANIFEST_PATH="$PROJECT_DIR/android/app/src/main/AndroidManifest.xml"

# Agregar permisos si no están presentes
if ! grep -q "android.permission.INTERNET" "$MANIFEST_PATH"; then
    cat <<EOL >> "$MANIFEST_PATH"
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK" />

EOL
fi

# 5. Modificar pubspec.yaml
echo "Modificando pubspec.yaml..."
PUBSPEC_PATH="$PROJECT_DIR/pubspec.yaml"

# Agregar dev_dependencies y configuraciones de flutter_launcher_icons si no están presentes
if ! grep -q "flutter_launcher_icons" "$PUBSPEC_PATH"; then
    cat <<EOL >> "$PUBSPEC_PATH"
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: "ic_launcher"
  ios: false
  image_path: "lib/assets/images/logo.png"
  min_sdk_android: 21
  web:
    generate: true
    image_path: "lib/assets/images/logo.png"
    background_color: "#hexcode"
    theme_color: "#hexcode"
  windows:
    generate: false
    image_path: "lib/assets/images/logo.png"
    icon_size: 48
  macos:
    generate: false
    image_path: "lib/assets/images/logo.png"

  assets:
    - lib/assets/
    - lib/assets/images/
EOL
fi

# 6. Crear carpetas en lib/
echo "Creando la estructura de carpetas en lib/..."
mkdir -p "$PROJECT_DIR/lib/core/theme"
mkdir -p "$PROJECT_DIR/lib/core/utils"
mkdir -p "$PROJECT_DIR/lib/core/models"
mkdir -p "$PROJECT_DIR/lib/core/services"

mkdir -p "$PROJECT_DIR/lib/features/login/data"
mkdir -p "$PROJECT_DIR/lib/features/login/domain"
mkdir -p "$PROJECT_DIR/lib/features/login/presentation"

mkdir -p "$PROJECT_DIR/lib/features/dashboard/data"
mkdir -p "$PROJECT_DIR/lib/features/dashboard/domain"
mkdir -p "$PROJECT_DIR/lib/features/dashboard/presentation"

# Crear la carpeta para las imágenes
mkdir -p "$PROJECT_DIR/lib/assets/images"

# 7. Crear exports.dart en lib/app/
echo "Creando exports.dart en lib/app/..."
mkdir -p "$PROJECT_DIR/lib/app"
cat <<EOL > "$PROJECT_DIR/lib/app/exports.dart"
// Exportaciones de archivos Dart aquí
EOL

# 8. Crear main.dart y config.dart
echo "Creando main.dart y config.dart en lib/..."
cat <<EOL > "$PROJECT_DIR/lib/main.dart"
import 'package:flutter/material.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Container(), // Reemplaza con tu widget inicial
    );
  }
}
EOL

cat <<EOL > "$PROJECT_DIR/lib/config.dart"
// Configuraciones y constantes globales
class AppConfig {
  static const String apiUrl = 'https://api.example.com';
  static const int timeout = 30; // Timeout en segundos
}
EOL

echo "¡Configuración completada para el proyecto $(basename "$PROJECT_DIR")!"
