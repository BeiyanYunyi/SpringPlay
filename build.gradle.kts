import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
  alias(libs.plugins.org.springframework.boot)
  alias(libs.plugins.io.spring.dependency.management)
  alias(libs.plugins.org.graalvm.buildtools.native)
  alias(libs.plugins.org.jetbrains.kotlin.jvm)
  alias(libs.plugins.org.jetbrains.kotlin.plugin.spring)
}

group = "us.beiyan.yunyi"
version = "1.0-SNAPSHOT"

repositories {
  mavenCentral()
  maven { setUrl("https://jitpack.io") }
}

dependencies {
  implementation(libs.spring.boot.starter)
  implementation(libs.spring.boot.starter.web)
  implementation(libs.kotlin.reflect)
  implementation(libs.kotlin.stdlib.jdk8)
  implementation(libs.kotlinx.coroutines.core)
  implementation(libs.kotlinx.coroutines.reactor)
  implementation(libs.spring.boot.starter.actuator)
  implementation(libs.hibernate.core)
  implementation(libs.spring.boot.starter.data.jpa)
  implementation(libs.h2)
  testImplementation(libs.spring.boot.starter.test)
}

tasks.test {
  useJUnitPlatform()
}

tasks.withType<KotlinCompile> {
  kotlin.compilerOptions {
    jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21)
  }
}

springBoot {
  mainClass.value("us.beiyan.yunyi.ApplicationKt")
}

java {
  sourceCompatibility = JavaVersion.VERSION_21
}


graalvmNative {
  binaries {
    all {
      javaLauncher = javaToolchains.launcherFor {
        languageVersion = JavaLanguageVersion.of(21)
        vendor = JvmVendorSpec.matching("GraalVM")
      }
    }
  }
}



