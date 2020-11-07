#!/bin/sh
# TKit.lib 编译脚本

# iOS 8.1                                -sdk iphoneos8.1
# Simulator - iOS 8.1             -sdk iphonesimulator8.1
# cocoapods0.39


# 工程编译路径
cd `dirname $0`
echo `basename $0` is in `pwd`

project_path=$(pwd)/../
lib_path=${project_path}/../TKit_lib_0.8/

wspace_name=TKit-0.8.xcworkspace

# # # ```````````````````````````````  编译
cd ..
rm -r -f  build
mkdir build


# # ******************************  发布－真机库处理  1.编译
cd $project_path
mkdir build/release_os
os_release_path=${project_path}/build/release_os
xcodebuild -workspace ${wspace_name} -scheme TKit_lib -configuration release -sdk iphoneos  CONFIGURATION_BUILD_DIR=${os_release_path} ONLY_ACTIVE_ARCH=NO


# # # ******************************  调试－真机库处理  1.编译
cd $project_path
mkdir build/debug_os
os_debug_path=${project_path}/build/debug_os
xcodebuild -workspace ${wspace_name} -scheme TKit_lib -configuration debug -sdk iphoneos  CONFIGURATION_BUILD_DIR=${os_debug_path} ONLY_ACTIVE_ARCH=NO


# # # ******************************  调试－模拟器库处理  1.编译
cd $project_path
mkdir build/debug_sim
sim_debug_path=${project_path}/build/debug_sim
xcodebuild -workspace ${wspace_name} -scheme TKit_lib -configuration debug  -sdk iphonesimulator  CONFIGURATION_BUILD_DIR=${sim_debug_path} ONLY_ACTIVE_ARCH=NO




# # # ```````````````````````````````  安装
rm -rf $lib_path/*

mkdir $lib_path/inc/
mkdir $lib_path/lib/
mkdir $lib_path/resource/

mkdir $lib_path/lib/Release
mkdir $lib_path/lib/Debug


# install 静态库
lipo -create  $os_debug_path/libTKit_lib.a  $sim_debug_path/libTKit_lib.a -output  $lib_path/lib/Debug/libTKit.a
cp  $os_release_path/libTKit_lib.a $lib_path/lib/Release/libTKit.a

# install 资源
cp -r  	$project_path/TKit/TWidget/PullToRefresh.bundle    		${lib_path}/resource/

# install 头文件
cp  $os_release_path/TKit_lib/*.h  	$lib_path/inc/

# 设置权限
chmod -R 777  $lib_path/

