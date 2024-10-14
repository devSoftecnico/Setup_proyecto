# Reglas generales
# Mantener los nombres de clases, métodos, etc. de Flutter para evitar errores
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# Mantener las clases de Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Reglas para permitir la reflexión
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Mantener clases con anotaciones específicas
-keepclassmembers class ** {
    @androidx.annotation.Keep *;
}
-keep @androidx.annotation.Keep class *

# Reglas para Kotlin
-keepclassmembers class kotlin.Metadata { *; }

# Reglas para multidex
-keep class androidx.multidex.** { *; }

-keep class com.ryanheise.** { *; }

# Reglas para Firebase (si utilizas Firebase)
-keepattributes Signature
-keepattributes Exceptions
-keepattributes *Annotation*

-keepnames class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Reglas para Retrofit/Gson (si las utilizas)
-keep class com.google.gson.stream.** { *; }
-dontwarn com.google.gson.**

-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keepattributes Signature

# Si estás utilizando Glide (biblioteca para cargar imágenes), añade estas reglas
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.module.AppGlideModule

# Reglas para excluir archivos del directorio META-INF
-ignorewarnings

# Reglas personalizadas para tu aplicación
# Añade reglas específicas para bibliotecas adicionales que utilices aquí.
