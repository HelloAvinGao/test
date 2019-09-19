#!/bin/bash
sudo apt update && sudo apt -y upgrade && sudo apt -y dist-upgrade
apt -y install make mercurial wget yasm nasm vainfo cmake git
mkdir -p ~/vaapi
mkdir -p ~/ffmpeg_build
mkdir -p ~/ffmpeg_sources
mkdir -p ~/bin

# libdrm
cd ~/vaapi
git clone https://anongit.freedesktop.org/git/mesa/drm.git libdrm
cd libdrm
./autogen.sh --prefix=/usr --enable-udev
time make -j$(nproc) VERBOSE=1
sudo make -j$(nproc) install
sudo ldconfig -vvvv


#libva
cd ~/vaapi
git clone https://github.com/01org/libva
cd libva
./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu
time make -j$(nproc) VERBOSE=1
sudo make -j$(nproc) install
sudo ldconfig -vvvv

# gmmlib
mkdir -p ~/vaapi/workspace
cd ~/vaapi/workspace
git clone https://github.com/intel/gmmlib
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE= Release ../gmmlib
make -j$(nproc)
sudo make -j$(nproc) install

# media-driver
cd ~/vaapi/workspace
git clone https://github.com/intel/media-driver
cd media-driver
git submodule init
git pull
mkdir -p ~/vaapi/workspace/build_media
cd ~/vaapi/workspace/build_media
cmake ../media-driver \
-DMEDIA_VERSION="2.0.0" \
-DBS_DIR_GMMLIB=$PWD/../gmmlib/Source/GmmLib/ \
-DBS_DIR_COMMON=$PWD/../gmmlib/Source/Common/ \
-DBS_DIR_INC=$PWD/../gmmlib/Source/inc/ \
-DBS_DIR_MEDIA=$PWD/../media-driver \
-DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu \
-DINSTALL_DRIVER_SYSCONF=OFF \
-DLIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri
time make -j$(nproc) VERBOSE=1
sudo make -j$(nproc) install VERBOSE=1

sudo usermod -a -G video $USER
export LIBVA_DRIVER_NAME=iHD

# intel-vaapi-driver
cd ~/vaapi
git clone https://github.com/intel/intel-vaapi-driver
cd intel-vaapi-driver
./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu
time make -j$(nproc) VERBOSE=1
sudo make -j$(nproc) install

# libva-utils
cd ~/vaapi
git clone https://github.com/intel/libva-utils
cd libva-utils
./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu
time make -j$(nproc) VERBOSE=1
sudo make -j$(nproc) install
sudo systemctl reboot


# Intel-Media-SDK
cd ~/vaapi
git clone https://github.com/Intel-Media-SDK/MediaSDK msdk
cd msdk
git submodule init
git pull
mkdir -p ~/vaapi/build_msdk
cd ~/vaapi/build_msdk
cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_WAYLAND=ON -DENABLE_X11_DRI3=ON -DENABLE_OPENCL=ON  ../msdk
time make -j$(nproc) VERBOSE=1
sudo make install -j$(nproc) VERBOSE=1
sudo ldconfig -vvvv
sudo systemctl reboot

# ffmpeg_sources x264
cd ~/ffmpeg_sources
git clone http://git.videolan.org/git/x264.git -b stable
cd x264/
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --enable-static --enable-pic --bit-depth=all
PATH="$HOME/bin:$PATH" make -j$(nproc) VERBOSE=1
make -j$(nproc) install VERBOSE=1
make -j$(nproc) distclean


# ffmpeg_sources x265
cd ~/ffmpeg_sources
hg clone https://bitbucket.org/multicoreware/x265
cd ~/ffmpeg_sources/x265/build/linux
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make -j$(nproc) VERBOSE=1
make -j$(nproc) install VERBOSE=1
make -j$(nproc) clean VERBOSE=1

# ffmpeg_sources fdk-aac
cd ~/ffmpeg_sources
git clone https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make -j$(nproc)
make -j$(nproc) install
make -j$(nproc) distclean

# ffmpeg_sources libvpx
cd ~/ffmpeg_sources
git clone https://github.com/webmproject/libvpx
cd libvpx
./configure --prefix="$HOME/ffmpeg_build" --enable-runtime-cpu-detect --enable-vp9 --enable-vp8 \
--enable-postproc --enable-vp9-postproc --enable-multi-res-encoding --enable-webm-io --enable-better-hw-compatibility --enable-vp9-highbitdepth --enable-onthefly-bitpacking --enable-realtime-only --cpu=native --as=nasm
time make -j$(nproc)
time make -j$(nproc) install
time make clean -j$(nproc)
time make distclean

# ffmpeg_sources vorbis
cd ~/ffmpeg_sources
git clone https://github.com/xiph/vorbis
cd vorbis
./autogen.sh -ivf
./configure --enable-static --prefix="$HOME/ffmpeg_build"
time make -j$(nproc)
time make -j$(nproc) install
time make clean -j$(nproc)
time make distclean

# FFmpeg
cd ~/ffmpeg_sources
git clone https://github.com/FFmpeg/FFmpeg -b master
cd FFmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig:/opt/intel/mediasdk/lib/pkgconfig" ./configure \
  --pkg-config-flags="--static" \
  --prefix="$HOME/ffmpeg_build" \
  --bindir="$HOME/bin" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-cflags="-I/opt/intel/mediasdk/include" \
  --extra-ldflags="-L/opt/intel/mediasdk/lib" \
  --extra-ldflags="-L/opt/intel/mediasdk/plugins" \
  --enable-libmfx \
  --enable-vaapi \
  --enable-opencl \
  --disable-debug \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libdrm \
  --enable-gpl \
  --enable-runtime-cpudetect \
  --enable-libfdk-aac \
  --enable-libx264 \
  --enable-libx265 \
  --enable-openssl \
  --enable-pic \
  --extra-libs="-lpthread -lm -lz -ldl" \
  --enable-nonfree
PATH="$HOME/bin:$PATH" make -j$(nproc)
make -j$(nproc) install
make -j$(nproc) distclean
hash -r

sudo apt install libmfx* -y
