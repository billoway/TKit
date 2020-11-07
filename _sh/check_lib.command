#!/bin/sh

cd `dirname $0`
echo `basename $0` is in `pwd`

cd ../build/


# ```````````````````````````````````````
cd debug_os

lipo libTKit_lib.a -thin arm64 -output  _arm64.TKit
lipo libTKit_lib.a -thin armv7 -output  _armv7.TKit

mkdir  _arm64
cd _arm64
ar -x  ../_arm64.TKit
cd ..

mkdir  _armv7
cd _armv7
ar -x  ../_armv7.TKit
cd ..

# ```````````````````````````````````````
cd ..
cd release_os

lipo libTKit_lib.a -thin arm64 -output  _arm64.TKit
lipo libTKit_lib.a -thin armv7 -output  _armv7.TKit

mkdir  _arm64
cd _arm64
ar -x  ../_arm64.TKit
cd ..

mkdir  _armv7
cd _armv7
ar -x  ../_armv7.TKit
cd ..

# ```````````````````````````````````````
cd ..
cd debug_sim

lipo libTKit_lib.a -thin x86_64 -output  _x86_64.TKit
lipo libTKit_lib.a -thin i386 -output  _i386.TKit

mkdir  _i386
cd _i386
ar -x  ../_i386.TKit
cd ..

mkdir  _x86_64
cd _x86_64
ar -x  ../_x86_64.TKit
cd ..
