import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// val localProperties = Properties().apply {
//     val localPropertiesFile = rootProject.file("local.properties")
//     if (localPropertiesFile.exists()) {
//         load(localPropertiesFile.inputStream())
//     }
// }

// val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
// val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("keystore/key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    compileSdk = flutter.compileSdkVersion
    namespace = "dev.theolm.invoicer"
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    defaultConfig {
        applicationId = "dev.theolm.invoicer"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storeFile = file("../keystore/keystore.jks")
            keyAlias = System.getenv("ALIAS") ?: keystoreProperties["keyAlias"] as String?
            storePassword = System.getenv("PASS") ?: keystoreProperties["keyPassword"] as String?
            keyPassword = System.getenv("PASS") ?: keystoreProperties["keyPassword"] as String?
        }
    }

    buildTypes {
        release {
            //signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

