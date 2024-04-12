#!/usr/bin/env bash

set -e
set -o pipefail
set -u

repo_dir=$(
  cd "$(dirname "$0")"
  pwd
)

cd "${repo_dir}"

install_dir=${repo_dir}/build/install/usr/local

# build mpi
if [ -d build ]; then
  rm -rf build
fi
mkdir -p ${install_dir}

cd build

cmake ..
make -j$(nproc)
sudo make install

# build ffmpeg
git clone git://source.ffmpeg.org/ffmpeg.git -b release/4.2 --depth=1
cd ffmpeg
cp ${repo_dir}/ffmpeg_patches/ffmpeg4.2_nvmpi.patch ./ffmpeg_nvmpi.patch
git apply ffmpeg_nvmpi.patch
./configure \
  --enable-nvmpi \
  --enable-gpl \
  --disable-stripping \
  --enable-avresample \
  --disable-filter=resample \
  --enable-avisynth \
  --enable-gnutls \
  --enable-ladspa \
  --enable-libaom \
  --enable-libass \
  --enable-libbluray \
  --enable-libbs2b \
  --enable-libcaca \
  --enable-libcodec2 \
  --enable-libflite \
  --enable-libfontconfig \
  --enable-libfreetype \
  --enable-libfribidi \
  --enable-libgme \
  --enable-libgsm \
  --enable-libjack \
  --enable-libmp3lame \
  --enable-libmysofa \
  --enable-libopenjpeg \
  --enable-libopenmpt \
  --enable-libopus \
  --enable-libpulse \
  --enable-librsvg \
  --enable-librubberband \
  --enable-libshine \
  --enable-libsnappy \
  --enable-libsoxr \
  --enable-libspeex \
  --enable-libssh \
  --enable-libtheora \
  --enable-libtwolame \
  --enable-libvidstab \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libwavpack \
  --enable-libwebp \
  --enable-libx265 \
  --enable-libxml2 \
  --enable-libxvid \
  --enable-libzmq \
  --enable-libzvbi \
  --enable-lv2 \
  --enable-omx \
  --enable-openal \
  --enable-opengl \
  --enable-sdl2 \
  --enable-libdc1394 \
  --enable-libdrm \
  --enable-libiec61883 \
  --enable-chromaprint \
  --enable-frei0r \
  --enable-libx264 \
  -enable-shared \
  --prefix=${install_dir}
make -j$(nproc)
make install
