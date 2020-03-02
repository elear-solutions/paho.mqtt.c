from conans import ConanFile, CMake, tools

class PahomqttclibConan(ConanFile):
    name = "pahomqttc"
    version = "1.2.1"
    description = "This recipe file used to build and package binaries of pahomqttc repository"
    topics = ("<Put some tag here>", "<here>", "<and here>")
    url = "https://github.com/elear-solutions/paho.mqtt.c"
    license = "<Put the package license here>"
    generators = "cmake"
    settings = "os", "compiler", "build_type", "arch"
    options = {
        "shared": [True, False],
    }
    default_options = {key: False for key in options.keys()}
    default_options ["shared"] = False

    def build(self):
        cmake = CMake(self)
        cmake.definitions["Platform"] = self.settings.os
        cmake.configure(source_folder=".")
        cmake.build()
        cmake.install()

    def package(self):
        self.copy("*.h", dst="include", src="package/include")
        self.copy("*", dst="lib", src="package/lib", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = [ "paho-mqtt3a", "paho-mqtt3a-static", "paho-mqtt3c", "paho-mqtt3c-static" ]
