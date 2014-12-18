require 'formula'

class Simbody < Formula
  homepage 'https://simtk.org/home/simbody'
  url 'https://github.com/simbody/simbody/archive/Simbody-3.5.tar.gz'
  sha1 'b2724c75c399865e1b9112db6c1cf785177591cd'
  head 'https://github.com/simbody/simbody.git', :branch => 'master'

  depends_on 'cmake' => :build
  depends_on 'doxygen' => :build

  def install
    ENV.m64

    cmake_args = std_cmake_args.select { |arg| arg.match(/CMAKE_BUILD_TYPE/).nil? }
    cmake_args << "-DCMAKE_BUILD_TYPE=Release"

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "doxygen"
      system "make", "install"
    end
  end
end
