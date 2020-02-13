from conans import ConanFile, CMake, tools

class PahomqttclibConan(ConanFile):
    name = "pahomqttc"
    version = "0.0.1"
    description = "This recipe file used to build and package binaries of pahomqttc repository"
    topics = ("<Put some tag here>", "<here>", "<and here>")
    url = "https://github.com/elear-solutions/paho.mqtt.c"
    license = "<Put the package license here>"
    generators = "cmake"
    settings = "os", "compiler", "build_type", "arch"
    options = {
        "shared": [True, False],
        "fPIC": [True, False]
    }
    default_options = {key: False for key in options.keys()}
    default_options ["shared"] = False
    default_options ["fPIC"] = True

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def configure(self):
        del self.settings.compiler.libcxx
        del self.settings.compiler.cppstd

    def _configure_cmake(self):
        if tools.cross_building(self.settings) and self.settings.os != "Windows":
            host = tools.get_gnu_triplet(str(self.settings.os), str(self.settings.arch))
            tools.replace_in_file("../CMakeLists.txt",
                                  "execute_process(COMMAND ./configure ",
                                  "execute_process(COMMAND ./configure --host %s " % host)
        cmake = CMake(self)
        cmake.configure(source_folder=".")
        return cmake

    def build(self):
        cmake = self._configure_cmake()
        cmake.build()
        cmake.install()

    def package(self):
        self.copy("*.h", dst="include/pahomqttc", src="package/include/pahomqttc")
        self.copy("*", dst="lib", src="package/lib", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = [ "paho-mqtt3a", "paho-mqtt3a-static", "paho-mqtt3c", "paho-mqtt3c-static" ]
