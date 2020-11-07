#!/bin/sh
# TKit.lib 编译脚本

# iOS 8.1                                -sdk iphoneos8.1
# Simulator - iOS 8.1             -sdk iphonesimulator8.1
# cocoapods0.39


# 工程编译路径
cd `dirname $0`
echo `basename $0` is in `pwd`

project_path=$(pwd)
lib_path=$project_path/build/lib/
wspace_name=TKit-0.8.xcworkspace

#--------- delete # rm -r -f  build

mkdir build
mkdir build/lib
mkdir build/lib/TKit_inc


# # ******************************  真机库处理  1.编译 2.解压  a库  3.打包 a库  4.脱脂 a库  5.合并armv7和arm64
cd $project_path
mkdir build/release_os
os_release_path=${project_path}/build/release_os
xcodebuild -workspace ${wspace_name} -scheme TKit -configuration release -sdk iphoneos  CONFIGURATION_BUILD_DIR=${os_release_path} ONLY_ACTIVE_ARCH=NO


# # # ******************************  真机库处理  1.编译 2.解压  a库  3.打包 a库  4.脱脂 a库  5.合并armv7和arm64
cd $project_path
mkdir build/debug_os
os_debug_path=${project_path}/build/debug_os
xcodebuild -workspace ${wspace_name} -scheme TKit -configuration debug -sdk iphoneos  CONFIGURATION_BUILD_DIR=${os_debug_path} ONLY_ACTIVE_ARCH=NO


# # # ******************************  模拟器库处理  1.编译 2.解压  a库  3.打包 a库  4.脱脂 a库  5.合并i386和x86_64
cd $project_path
mkdir build/debug_sim
sim_debug_path=${project_path}/build/debug_sim
xcodebuild -workspace ${wspace_name} -scheme TKit -configuration debug  -sdk iphonesimulator  CONFIGURATION_BUILD_DIR=${sim_debug_path} ONLY_ACTIVE_ARCH=NO



# ````````````````````````````````  真机库处理  1.编译 2.解压  a库  3.打包 a库  4.脱脂 a库  5.合并armv7和arm64
cd $os_release_path
mkdir armv7 & mkdir arm64

cd armv7

lipo ../libTKit.a 						-thin armv7 -output  _armv7.TKit
lipo ../libSDWebImage.a 				-thin armv7 -output  _armv7.SDWebImage
lipo ../libAFNetworking.a 				-thin armv7 -output  _armv7.AFNetworking

ar -x  _armv7.TKit
ar -x  _armv7.SDWebImage
ar -x  _armv7.AFNetworking

rm Pods-dummy.o
# rm SDWebImage-dummy.o
# rm AFNetworking-dummy.o

ar  rcs   TKit-armv7.a   *.o # 打包
lipo  -create  TKit-armv7.a  -output  ../TKit-armv7.a  #脱脂
cd ..


cd arm64
lipo ../libTKit.a 						-thin arm64 -output  _arm64.TKit
lipo ../libSDWebImage.a 				-thin arm64 -output  _arm64.SDWebImage
lipo ../libAFNetworking.a 				-thin arm64 -output  _arm64.AFNetworking

ar -x  _arm64.TKit
ar -x  _arm64.SDWebImage
ar -x  _arm64.AFNetworking

rm Pods-dummy.o
# rm SDWebImage-dummy.o
# rm AFNetworking-dummy.o

ar  rcs   TKit-arm64.a   *.o # 打包
lipo  -create  TKit-arm64.a  -output  ../TKit-arm64.a  #脱脂
cd ..

# rm -r -f armv7
# rm -r -f arm64

#合并文件
lipo  -create  TKit-armv7.a TKit-arm64.a  -output  $lib_path/TKit-os-release.a

# 删除编译缓存
# rm -r $build_path
mv libTKit.a $lib_path/TKit-os-release.a


# ````````````````````````````````  真机库处理  1.编译 2.解压  a库  3.打包 a库  4.脱脂 a库  5.合并armv7和arm64
cd $os_debug_path

mkdir armv7
mkdir arm64

cd armv7

lipo ../libTKit.a 						-thin armv7 -output  _armv7.TKit
lipo ../libSDWebImage.a 				-thin armv7 -output  _armv7.SDWebImage
lipo ../libAFNetworking.a 				-thin armv7 -output  _armv7.AFNetworking

ar -x  _armv7.TKit
ar -x  _armv7.SDWebImage
ar -x  _armv7.AFNetworking

rm Pods-dummy.o
# rm SDWebImage-dummy.o
# rm AFNetworking-dummy.o

ar  rcs   TKit-armv7.a   *.o # 打包
lipo  -create  TKit-armv7.a  -output  ../TKit-armv7.a  #脱脂
cd ..


cd arm64
lipo ../libTKit.a 						-thin arm64 -output  _arm64.TKit
lipo ../libSDWebImage.a 				-thin arm64 -output  _arm64.SDWebImage
lipo ../libAFNetworking.a 				-thin arm64 -output  _arm64.AFNetworking

ar -x  _arm64.TKit
ar -x  _arm64.SDWebImage
ar -x  _arm64.AFNetworking

rm Pods-dummy.o
# rm SDWebImage-dummy.o
# rm AFNetworking-dummy.o

ar  rcs   TKit-arm64.a   *.o # 打包
lipo  -create  TKit-arm64.a  -output  ../TKit-arm64.a  #脱脂
cd ..

# rm -r -f armv7
# rm -r -f arm64

#合并文件
lipo  -create  TKit-armv7.a TKit-arm64.a  -output  $lib_path/TKit-os-debug.a

# 删除编译缓存
# rm -r $build_path
mv libTKit.a $lib_path/TKit-os-debug.a



# ````````````````````````````````  模拟器库处理  1.编译 2.解压  a库  3.打包 a库  4.脱脂 a库  5.合并i386和x86_64
cd $sim_debug_path


mkdir i386
mkdir x86_64

cd i386

lipo ../libTKit.a 						-thin i386 -output  _i386.TKit
lipo ../libSDWebImage.a 				-thin i386 -output  _i386.SDWebImage
lipo ../libAFNetworking.a 				-thin i386 -output  _i386.AFNetworking

ar -x  _i386.TKit
ar -x  _i386.SDWebImage
ar -x  _i386.AFNetworking

rm Pods-dummy.o
# rm SDWebImage-dummy.o
# rm AFNetworking-dummy.o

ar  rcs   TKit-i386.a   *.o # 打包
lipo  -create  TKit-i386.a  -output  ../TKit-i386.a  #脱脂
cd ..



cd x86_64

lipo ../libTKit.a 						-thin x86_64 -output  _x86_64.TKit
lipo ../libSDWebImage.a 				-thin x86_64 -output  _x86_64.SDWebImage
lipo ../libAFNetworking.a 				-thin x86_64 -output  _x86_64.AFNetworking

ar -x  _x86_64.TKit
ar -x  _x86_64.SDWebImage
ar -x  _x86_64.AFNetworking

rm Pods-dummy.o
# rm SDWebImage-dummy.o
# rm AFNetworking-dummy.o

ar  rcs   TKit-x86_64.a   *.o # 打包
lipo  -create  TKit-x86_64.a  -output  ../TKit-x86_64.a  #脱脂
cd ..


# rm -r -f i386
# rm -r -f x86_64


#合并文件
lipo  -create  TKit-i386.a TKit-x86_64.a  -output  $lib_path/TKit-sim.a


# ````````````````````````````````  模拟器库和真机库合并
cd $lib_path
cp  TKit-os-release.a 	  TKit-release.a
lipo  -create  TKit-sim.a  TKit-os-debug.a 		-output  TKit-debug.a

# 删除库文件缓存
rm TKit-sim.a && rm TKit-os-release.a && rm TKit-os-debug.a


# 拷贝头文件和资源
cp 		${os_release_path}/TKit/*.h   							${lib_path}/TKit_inc/
# cp 		${build_path}/*.h   								${lib_path}/TKit_inc/
cp -r  	$project_path/TKit/TWidget/PullToRefresh.bundle    		${lib_path}/

# 最后一次编译  等拷贝完资源和头文件之后 再删除编译缓存
# rm -r $build_path
