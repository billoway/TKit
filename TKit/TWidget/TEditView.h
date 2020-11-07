//
//  BaseInfoView.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//



#define f_Cell_TextAlignment_Center_w   -100
#define f_Cell_Default_Left_w           -1
#define f_TextfieldTag                  100

#import <UIKit/UIKit.h>

@class TEditView;
/// 编辑类页面 自定义table 委托
@protocol TEditDelegate <NSObject>

@required
/// 每个分区中行个数
- (NSInteger)rowCountInSection:(NSInteger)section table:(TEditView *)table;
/// 点击某行  返回是否可以编辑
- (BOOL)didSelectCurrRow:(NSInteger)row table:(TEditView *)table;

@optional
/// 分区个数
- (NSInteger)sectionCount:(TEditView *)table;

/// 返回某一行自定义view   当左边为标题 中间为文字时 无须实现
- (UIView *)viewForCurrRow:(NSInteger)row table:(TEditView *)table;
/// 返回某一行自定义view   当左边为标题 中间为文字时 无须实现
- (UIColor *)contentColorCurrRow:(NSInteger)row table:(TEditView *)table;
/// 返回某一行自定义leftview  如果不实现 leftview 默认为 标题
- (UIView *)leftViewForCurrRow:(NSInteger)row table:(TEditView *)table;
/// 返回某一行自定义rightview
- (UIView *)rightViewForCurrRow:(NSInteger)row table:(TEditView *)table;
/// 返回某一行自定义left 宽度  当左边为标题 文字时 宽度有变化 需要实现
- (CGFloat)leftWidthForCurrRow:(NSInteger)row table:(TEditView *)table;
/// 返回某一行自定义right 宽度
- (CGFloat)rightWidthForCurrRow:(NSInteger)row table:(TEditView *)table;
/// 返回某一行自定义cell 高度
- (CGFloat)rowHeightForCurrRow:(NSInteger)row table:(TEditView *)table;
/// 返回某一行自定义section 高度
- (CGFloat)sectionHeight:(NSInteger)section table:(TEditView *)table;
/// 重画 line
- (void)lineLayout:(UIView*)tLine table:(TEditView *)table;

/// 某一行选择完毕 离开时调用
- (void)doneSelectCurrRow:(NSInteger)row table:(TEditView *)table;
/// 编辑某一行 返回是否允许改变textfield的值
- (BOOL)shouldChangeRow:(NSInteger)row range:(NSRange)range replacementString:(NSString *)string table:(TEditView *)table;
/// 某一行的line frame
- (CGRect)cellLineFrame:(NSInteger)row table:(TEditView *)table defaultFrame:(CGRect)defaultFrame;

@end

@class DicExt;

/// 编辑类页面 自定义table 标准样式  左边标题 中间输入内容  右边图标或者开关
@interface TEditView : UIScrollView <UITextFieldDelegate>


/// 是否允许编辑 默认:YES
@property (nonatomic, assign) BOOL editable;
/// 是否显示 请输入... 字样 默认:YES
@property (nonatomic, assign) BOOL showReplace;
/// 是否整行显示备注内容,不显示标题(仅当标题包含 "备注" 关键字)   默认:YES
@property (nonatomic, assign) BOOL showFullRemark;
/// 是否含有边框 默认:YES
@property (nonatomic, assign) BOOL hasBorder;
/// 是否充满顶部 默认:NO
@property (nonatomic, assign) BOOL isFullView;


/// 表数据源  titles:有序字典 key: 左边title value: 中间编辑部分内容
@property (nonatomic, strong) DicExt *titles;

/// 工厂方法
+ (id)editViewWithFrame:(CGRect)frame delegate:(id <TEditDelegate>)delegate;

/// 更新某一行列表的值
- (void)setText:(NSString *)param row:(NSInteger)row;

/// 获取row对应的 UITextField对象
- (UITextField *)getTextFieldAtRow:(NSInteger)currRow;

/// 获取row对应的 值
- (NSString *)getValueAtRow:(NSInteger)currRow;

/// 使用自身的数据源 刷新
- (void)refreshTable;

#pragma mark - -------- 设置默认数据等 ----------

+ (void)defaultSetting;
/// 获取 分区左边长度
@property (nonatomic, readonly) float f_Section_Left;
/// 获取 分区顶部长度
@property (nonatomic, readonly) float f_Section_Top;
/// 获取 分区背景阴影
@property (nonatomic, readonly) float f_Section_bg_shadow_w;
/// 获取 分区宽度
@property (nonatomic, readonly) float f_Section_w;

@end

@interface TEditView (EditView)

/// 单元格 背景图片 (带阴影)  [默认图片名称: round_bg_1@2x.png ]
+ (void)regist_EditSectionBgImage:(UIImage *)image;

/// 单元格 背景图片阴影宽    [默认宽度: 1.f]
+ (void)regist_EditSectionBgShadowWidth:(float)width;

/// 分区顶部长   [默认:10.f]
+ (void)regist_EditSectionTop:(float)top;

/// 分区左边长   [默认:15.f]
+ (void)regist_EditSectionLeft:(float)left;

/// 单元格左边标题的宽   [默认:80]
+ (void)regist_EditCellLeftWidth:(float)width;

/// 单元格左边标题的最大宽 如果设置此变量 当有标题实际宽超出默认LeftWidth 会自动设置所有LeftWidth  [默认:80]
+ (void)regist_EditCellMaxLeftWidth:(float)width;

/// 单元格高度   [默认:44]
+ (void)regist_EditCellHeight:(float)height;

/// 单元格内容 左边长   [默认:10]
+ (void)regist_EditCellContentLeft:(float)left;

/// 单元格 左边字体   [默认:[UIFont FontOfSize:15.f]]
+ (void)regist_EditCellLeftFont:(UIFont *)font;

/// 单元格内容 字体   [默认:[UIFont FontOfSize:15.f]]
+ (void)regist_EditCellContentFont:(UIFont *)font;

/// 单元格 左边字体颜色   [默认:[UIColor hexColor:@"8190a2"]]
+ (void)regist_EditCellLeftColor:(UIColor *)color;

/// 单元格内容 字体颜色   [默认:[UIColor hexColor:@"3f4f63"]]
+ (void)regist_EditCellContentColor:(UIColor *)color;

/// 单元格 分割线    [默认:[UIImage getImage:@"line_h2_a"]]
+ (void)regist_EditCellLineImg:(UIImage *)image;

@end