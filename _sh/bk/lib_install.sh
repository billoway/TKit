# TKit.lib 安装脚本

cd `dirname $0`
echo `basename $0` is in `pwd`

lib_path=$(pwd)/build/lib       #编译路径
pods_path=$(pwd)/Pods           # pod 路径
tkit_path=$(pwd)/../TKit_lib_0.7   # tkit 静态库 路径


rm -rf $tkit_path/*

mkdir $tkit_path/inc/
mkdir $tkit_path/lib/
mkdir $tkit_path/resource/

mkdir $tkit_path/inc/AFNetworking/
mkdir $tkit_path/inc/SDWebImage/
# mkdir $tkit_path/inc/Reachability/
# mkdir $tkit_path/inc/NSDate-Extensions/
# mkdir $tkit_path/inc/GDataXML-HTML/

mkdir $tkit_path/lib/Release
mkdir $tkit_path/lib/Debug



# install 静态库
mv  $lib_path/TKit-release.a 	$tkit_path/lib/Release/libTKit.a
mv  $lib_path/TKit-debug.a 		$tkit_path/lib/Debug/libTKit.a

# install 资源
cp -r  	$lib_path/*.bundle    		$tkit_path/resource/
# cp -r  	$lib_path/*.xcdatamodeld   	$tkit_path/resource/
# cp		$lib_path/*.plist   		$tkit_path/resource/

# install 头文件
cp  $lib_path/TKit_inc/*.h  	$tkit_path/inc/

cp $pods_path/AFNetworking/*/*.h 		$tkit_path/inc/AFNetworking/
cp $pods_path/SDWebImage/*/*.h 			$tkit_path/inc/SDWebImage/
# cp $pods_path/Reachability/*.h 			$tkit_path/inc/Reachability/
# cp $pods_path/NSDate-Extensions/*.h 	$tkit_path/inc/NSDate-Extensions/
# cp $pods_path/GDataXML-HTML/*/*/*.h 	$tkit_path/inc/GDataXML-HTML/

chmod -R 777  $tkit_path/
