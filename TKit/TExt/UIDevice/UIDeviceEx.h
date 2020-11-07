//
//  UIDeviceEx
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#pragma mark - -------- 设备尺寸宏定义 ----------

#import "UIDevice-Capabilities.h"
#import "UIDevice-Hardware.h"
#import "UIDevice-Orientation.h"


#define D_Family        [[UIDevice currentDevice] deviceFamily]
#define D_Platform      [[UIDevice currentDevice] platformType]

#define Is_4InchDisplay ([UIScreen mainScreen].bounds.size.height > 481)
// ([[UIDevice currentDevice] deviceFamily] == UIDeviceFamilyiPhone && [UIScreen mainScreen].bounds.size.height != 480)

#define Device_size     [UIScreen mainScreen].bounds.size

#ifdef IS_SUPPORT_IPAD
  #define f_Device_w    (D_Family == UIDeviceFamilyiPad ? Device_size.height : Device_size.width)
  #define f_Device_h    (D_Family == UIDeviceFamilyiPad ? Device_size.width : Device_size.height)
#else
  #define f_Device_w    Device_size.width
  #define f_Device_h    Device_size.height
#endif

#define f_NavBar_h      [(UINavigationController *)[[UIApplication sharedApplication].keyWindow rootViewController] navigationBar].height

#define d_dev_scale     ([UIScreen mainScreen].scale / 2.f)
#define f_dev_scale(real) (real * d_dev_scale)

///除去状态栏之后的窗口高度
//#define f_StatusBar_h           20//[UIApplication sharedApplication].statusBarFrame.size.height    // 20
//#define f_StatusBar_Change_h    ( (f_StatusBar_h > 20) ?  (f_StatusBar_h - 20) :  -20 )           ///状态栏变化高度
#define f_StatusBar_h           20 //[UIApplication sharedApplication].statusBarFrame.size.height    // 20
#define f_StatusBar_Change_h    ( ([UIApplication sharedApplication].statusBarFrame.size.height > 20) ?  (f_StatusBar_h - 20) :  -20 )           ///状态栏变化高度

#define f_Screen_h              ( f_Device_h - ([UIApplication sharedApplication].statusBarFrame.size.height) )

/// 设备和系统判断
#define f_CurrentSystemVersion  ([[UIDevice currentDevice].systemVersion floatValue])
#define Is_Simulator            TARGET_IPHONE_SIMULATOR
#define Is_Ios_5                (f_CurrentSystemVersion >= 5.0 && f_CurrentSystemVersion < 6.0)
#define Is_Ios_6                (f_CurrentSystemVersion >= 6.0 && f_CurrentSystemVersion < 7.0)
#define Is_Ios_7                (f_CurrentSystemVersion >= 7.0 && f_CurrentSystemVersion < 8.0)
#define Is_Ios_8                (f_CurrentSystemVersion >= 8.0 && f_CurrentSystemVersion < 9.0)

#define Is_up_Ios_5             (f_CurrentSystemVersion >= 5.0)
#define Is_up_Ios_6             (f_CurrentSystemVersion >= 6.0)
#define Is_up_Ios_7             (f_CurrentSystemVersion >= 7.0)
#define Is_up_Ios_8             (f_CurrentSystemVersion >= 8.0)

#define _OS_MAX_VER             __IPHONE_OS_VERSION_MAX_ALLOWED
#define _OS_MIN_VER             __IPHONE_OS_VERSION_MIN_REQUIRED

#define f_Keyboard_Offset       (Is_4InchDisplay ? 0 : 40)
#define f_IPhone5_offset_h      (Is_4InchDisplay ? 88 : 0)