import org.gradle.api.Project
import org.gradle.api.tasks.compile.JavaCompile
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

fun Project.androidManifestNamespace(): String? {
    val manifestFile = file("src/main/AndroidManifest.xml")
    if (!manifestFile.exists()) {
        return null
    }

    val packageMatch =
        Regex("""package\s*=\s*"([^"]+)"""")
            .find(manifestFile.readText())

    return packageMatch?.groupValues?.getOrNull(1)
}

fun Project.configureAndroidNamespace() {
    val androidExtension = extensions.findByName("android") ?: return
    val getNamespace =
        androidExtension.javaClass.methods.firstOrNull {
            it.name == "getNamespace" && it.parameterCount == 0
        } ?: return

    val currentNamespace = getNamespace.invoke(androidExtension) as? String
    if (!currentNamespace.isNullOrBlank()) {
        return
    }

    val manifestNamespace = androidManifestNamespace() ?: return
    val setNamespace =
        androidExtension.javaClass.methods.firstOrNull {
            it.name == "setNamespace" && it.parameterCount == 1
        } ?: return

    setNamespace.invoke(androidExtension, manifestNamespace)
}

subprojects {
    pluginManager.withPlugin("com.android.library") {
        configureAndroidNamespace()
    }
    pluginManager.withPlugin("com.android.application") {
        configureAndroidNamespace()
    }

    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = "11"
        targetCompatibility = "11"
    }
    tasks.withType<KotlinCompile>().configureEach {
        kotlinOptions.jvmTarget = "11"
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
