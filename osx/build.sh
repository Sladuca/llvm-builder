#!/usr/bin/env bash
set -ex

cd "$(dirname "$0")"

rm -rf out
mkdir -p out
cd out

git clone https://github.com/Sladuca/llvm.git
echo "$( cd llvm && git rev-parse HEAD )  https://github.com/Sladuca/llvm.git" >> version.md
git clone https://github.com/Sladuca/clang.git llvm/tools/clang
echo "$( cd llvm/tools/clang && git rev-parse HEAD )  https://github.com/Sladuca/clang.git" >> version.md
git clone https://github.com/Sladuca/clang-tools-extra.git llvm/tools/clang/tools/extra
echo "$( cd llvm/tools/clang/tools/extra && git rev-parse HEAD )  https://github.com/Sladuca/clang-tools-extra.git" >> version.md
git clone https://github.com/Sladuca/compiler-rt.git llvm/projects/compiler-rt
echo "$( cd llvm/projects/compiler-rt && git rev-parse HEAD )  https://github.com/Sladuca/compiler-rt.git" >> version.md
git clone https://github.com/Sladuca/lld.git llvm/tools/lld
echo "$( cd llvm/tools/lld && git rev-parse HEAD )  https://github.com/Sladuca/lld.git" >> version.md

mkdir -p llvm/build
pushd llvm/build
cmake -DCMAKE_BUILD_TYPE="Release" -G "Ninja" ..
ninja llvm-ar
ninja clang
ninja llc
ninja lld
ninja llvm-objcopy
ninja llvm-objdump

popd

rm -rf deploy
mkdir -p deploy/lib
cp version.md deploy
cp -rf llvm/build/bin deploy
cp -rf llvm/build/lib/clang deploy/lib
tar -C deploy -jcf solana-llvm-osx.tar.bz2 .
