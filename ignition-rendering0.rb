class IgnitionRendering0 < Formula
  desc "Rendering library for robotics applications"
  homepage "https://bitbucket.org/ignitionrobotics/ign-rendering"
  url "https://bitbucket.org/ignitionrobotics/ign-rendering/get/5b69fe76e650c3d9c087edf50cee10bec0a22e05.tar.gz"
  version "0.0.0~20180823~5b69fe7"
  sha256 "7334dcffffa5674d7905dc6168d7c12fc82279f2f1736ef7ce86664071c43f5c"

  head "https://bitbucket.org/ignitionrobotics/ign-rendering", :branch => "default", :using => :hg

  bottle do
    root_url "http://gazebosim.org/distributions/ign-rendering/releases"
    sha256 "6d991b7724f7392e7d93a3ce71b53e24dbcdf633dea89be69ccc2505b1447042" => :high_sierra
    sha256 "3eccaf18af2cb2f3d4f337486ae107bdf2c5017a52de650a3bbf294ad833ae63" => :sierra
    sha256 "2b1b85aa8c51a8fb22ea901a7a46d607a12ca2df5b50e3e7d1a806493537ece8" => :el_capitan
  end

  depends_on "cmake" => :build

  depends_on "freeimage"
  depends_on "ignition-cmake1"
  depends_on "ignition-common2"
  depends_on "ignition-math5"
  depends_on "ogre1.9"
  depends_on "pkg-config"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <ignition/rendering/PixelFormat.hh>
      int main(int _argc, char** _argv)
      {
        ignition::rendering::PixelFormat pf = ignition::rendering::PF_UNKNOWN;
        return ignition::rendering::PixelUtil::IsValid(pf);
      }
    EOS
    ENV.append_path "PKG_CONFIG_PATH", "#{Formula["qt"].opt_lib}/pkgconfig"
    system "pkg-config", "ignition-rendering0"
    cflags   = `pkg-config --cflags ignition-rendering0`.split(" ")
    ldflags  = `pkg-config --libs ignition-rendering0`.split(" ")
    system ENV.cc, "test.cpp",
                   *cflags,
                   *ldflags,
                   "-lc++",
                   "-o", "test"
    system "./test"
  end
end
