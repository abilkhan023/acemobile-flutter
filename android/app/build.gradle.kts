plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

val servicesJson = file("google-services.json")
if (servicesJson.exists()) {
    apply(plugin = "com.google.gms.google-services")
}

android {
    lint {
        checkReleaseBuilds = false
        abortOnError = false
    }
    namespace = "gg.acegaming.ace_mobile"
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.esportsapp.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildFeatures {
        resValues = true
    }

    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationId = "com.esportsapp.app"
            resValue("string", "app_name", "Ace Gaming Dev")
        }
        create("prod") {
            dimension = "env"
            applicationId = "ace.adamar.solutions"
            resValue("string", "app_name", "Ace Gaming")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
