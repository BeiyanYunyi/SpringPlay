import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
  id("org.springframework.boot")
  id("io.spring.dependency-management")
  id("org.graalvm.buildtools.native")
  kotlin("jvm")
  kotlin("plugin.spring")
}

group = "us.beiyan.yunyi"
version = "1.0-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_17

repositories {
  mavenCentral()
  maven { setUrl("https://jitpack.io") }
}

dependencies {
  implementation(libs.spring.boot.starter)
  implementation(Spring.boot.web)
  implementation(libs.kotlin.reflect)
  implementation(Kotlin.stdlib.jdk8)
  implementation(KotlinX.coroutines.core)
  implementation(KotlinX.coroutines.reactor)
  implementation(Spring.boot.actuator)
  testImplementation(Spring.boot.test)
}

tasks.test {
  useJUnitPlatform()
}

tasks.withType<KotlinCompile> {
  kotlinOptions.jvmTarget = "17"
}

springBoot {
  mainClass.value("us.beiyan.yunyi.ApplicationKt")
}

java {
  sourceCompatibility = JavaVersion.VERSION_17
}



graalvmNative {
  binaries {
    all {
      javaLauncher = javaToolchains.launcherFor {
        languageVersion = JavaLanguageVersion.of(17)
        vendor = JvmVendorSpec.matching("Oracle GraalVM")
      }
    }
  }
}



