from conans import ConanFile, CMake, tools

class PahomqttclibConan(ConanFile):
    name = "pahomqttc"
    license = "<Put the package license here>"
    author = "<Put your name here> <And your email here>"
    url = "<Package recipe repository url here, for issues about the package>"
    description = "This recipe file used to build and package binaries of pahomqttc repository"
    topics = ("<Put some tag here>", "<here>", "<and here>")
    settings = "os", "compiler", "build_type", "arch"
    options = { "shared": [True, False] }
    default_options = "shared=False"
    generators = "cmake"

    def build(self):
        cmake = CMake(self)
        if (self.settings.os == "Android"):
            cmake.definitions["Platform"] = "android"
        cmake.configure(source_folder=".")
        cmake.build()

    def package(self):
        self.copy("*.h", dst="include", src="src")
        self.copy("*", dst="lib", src="lib", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = [ "paho-mqtt3a" ]
        self.cpp_info.libs = [ "paho-mqtt3a-static" ]
        self.cpp_info.libs = [ "paho-mqtt3c" ]
        self.cpp_info.libs = [ "paho-mqtt3c-static" ]
