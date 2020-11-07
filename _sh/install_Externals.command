#!/bin/sh
cd `dirname $0`
echo `basename $0` is in `pwd`

cd ..
_pod=$(pwd)/Pods
_ext=$(pwd)/TKit/Externals

pod update --no-repo-update

rm -f ${_ext}/*/*.h
rm -f ${_ext}/*/*.m


cd ${_pod}/AFNetworking
cp */*.h    ${_ext}/AFNetworking/
cp */*.m    ${_ext}/AFNetworking/


cd ${_pod}/GCJSONKit
cp *.h    ${_ext}/GCJSONKit/
cp *.m    ${_ext}/GCJSONKit/


cd ${_pod}/GDataXML-HTML
cp */*/*.h    ${_ext}/GDataXML-HTML/
cp */*/*.m    ${_ext}/GDataXML-HTML/


cd ${_pod}/NSDate-Extensions
cp *.h    ${_ext}/NSDate-Extensions/
cp *.m    ${_ext}/NSDate-Extensions/


cd ${_pod}/Reachability
cp *.h    ${_ext}/Reachability/
cp *.m    ${_ext}/Reachability/


cd ${_pod}/SDWebImage
cp */*.h    ${_ext}/SDWebImage/
cp */*.m    ${_ext}/SDWebImage/
