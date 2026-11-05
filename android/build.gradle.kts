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

// Some plugins (e.g. flutter_thermal_printer 1.2.4) pin an outdated
// compileSdk in their own android/build.gradle, lower than what their
// own transitive dependencies (e.g. universal_ble, AndroidX libs) require.
// That mismatch fails AGP's checkDebugAarMetadata task. Force every
// Android subproject to a consistent, sufficiently high compileSdk.
// :app is already evaluated by this point (evaluationDependsOn above),
// so apply immediately for it and via afterEvaluate for the rest.
subprojects {
    fun applyCompileSdk() {
        extensions.findByType(com.android.build.gradle.BaseExtension::class.java)?.let {
            it.compileSdkVersion(36)
        }
    }
    if (state.executed) applyCompileSdk() else afterEvaluate { applyCompileSdk() }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
