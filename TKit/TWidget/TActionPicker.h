//
//  TActionPicker.h
//  oaclient
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDefine.h"
#define f_Tool_Bar_h    44
#define s_pick_null_str @"无数据"

typedef NS_ENUM (NSInteger, TPickType) {
        /// 普通单列 picker
    PickNormalType,
        /// 日期 picker
    PickDateType
};



@protocol TNormalPickerDelegate, TDatePickerDelegate;
@interface TActionPicker : UIActionSheet

/// 选择 picker 回调
typedef BOOL (^ PickBlk)(TActionPicker *picker, NSString *clickItem);
typedef BOOL (^ DatePickBlk)(TActionPicker *picker, NSDate *clickDate);
/// 自定义视图
@property (nonatomic, strong)    UIView                     *view;
@property (nonatomic, weak)      id <TNormalPickerDelegate> normalPickerDelegate;
@property (nonatomic, weak)      id <TDatePickerDelegate>   datePickerDelegate;
/// 数据源
@property (nonatomic, strong)    NSArray *items;
/// 数据源 当选择其中一列后 其他列发生变化时 可手动操作该数据源
@property (nonatomic, strong)    NSMutableArray *realItems;
@property (nonatomic, strong)    VBlock cancelBlk;

// ----------------------- NormalPicker
    /// pickerView
@property (nonatomic, strong)    UIPickerView *_pickerView;
    /// 是否单列 默认 YES
@property (nonatomic, assign)   BOOL singleComponents;
    /// 是否 显示选中的行列  (单列默认:YES 多列默认:NO)
@property (nonatomic, assign)   BOOL isShowSelect;

    /// 选择的行 -- 单列
@property (nonatomic, assign)   NSInteger _selectIndex;
    /// 选择的内容 -- 单列 (多列 为每列选择得内容拼接)
@property (nonatomic, strong)   NSString *_selectItem;

    /// 选择的行 -- 多列 [对应每列所选择的row  内容为 number 或者string  ]
@property (nonatomic, strong)   NSMutableArray *_selectIndexs;


    // ----------------------- DatePicker
@property (nonatomic, strong)    UIDatePicker   *_datePicker;
/// 选择的Date
@property (nonatomic, strong)    NSDate         *_selectDate;

+ (id)pickWithTitle:(NSString *)title;
+ (id)pickWithType:(TPickType)type;
+ (id)pickWithType:(TPickType)type title:(NSString *)title;
// +(id) pickWithType:(TPickType)type title:(NSString*)title height:(float)height;

- (void)setPickTitle:(NSString *)title;

// ------- 普通选择器
    /// 弹出选择器
- (void)showPickerIn:(UIView *)view click:(PickBlk)click;
    /// 弹出选择器
- (void)showPicker:(id)items click:(PickBlk)click;
/// 弹出选择器
- (void)showPicker:(id)items view:(UIView *)view click:(PickBlk)click;

- (void)createToolBar:(NSString *)titleName;

// ------- 日期选择器
/// 设置日期时间
- (void)doSelectDate:(NSDate *)date;
/// 设置日期选择器 大小限制 和日期格式
- (void)setMaxDate:(NSDate *)maxDate minDate:(NSDate *)minDate dateModel:(UIDatePickerMode)dateModel;
/// 弹出日期选择器
- (void)showDatePicker:(DatePickBlk)click;
/// 弹出日期选择器
- (void)showDatePicker:(UIView *)view click:(DatePickBlk)click;

@end

/// 自定普通选择器回调
@protocol TNormalPickerDelegate <NSObject>
@optional
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;

@end

/// 自定义日期选择器回调
@protocol TDatePickerDelegate <NSObject>

@end