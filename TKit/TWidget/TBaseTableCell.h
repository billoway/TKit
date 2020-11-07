//
//  TableViewCell.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#pragma mark - -------- CELL_TYPE 预定义方法名 动态匹配单元格布局方法----------

#define s_testCell @"testCell:"

/// 当 table 为多个分区时,cell处于 section 中的位置
typedef NS_OPTIONS (NSUInteger, CellLocalModel) {
    /// section 的顶部
    CellLocalTop = 1,
    /// section 的中间
    CellLocalMiddle = 2,
    /// section 的底部
    CellLocalBottom = 3
};

#import <UIKit/UIKit.h>
#import "TWebImgView.h"
//#import "FTCoreTextView.h"

/********
*    cell 通用类:
*    _identifier 作为cell 的布局和数据刷新方法
*
*    - (void)testCell:(id)item
*    {
*    // 数据刷新
*    if (item) {
*    [self._mLabel1 setText:[NSString stringWithFormat:@"显示标题 =>%d", _indexPath.section]];
*    return;
*    }
*
*    // 布局
*    self._mLabel1.frame = CGRectMake(20, 5, f_Device_w, 20);
*    self._mLine.frame = CGRectMake(0, 50 - 0.5, f_Device_w, 0.5);
*    }
*
********/
@interface TBaseTableCell : UITableViewCell

/// 复用标志
@property (nonatomic, strong) NSString *_identifier;

/// 当 table 为多个分区时,cell处于 section 中的位置
@property (nonatomic, assign) CellLocalModel cellLocalModel;
/// 当前cell 的 indexPath
@property (nonatomic, assign) NSIndexPath *indexPath;

@property (strong, nonatomic) UIView *_bgView;

@property (strong, nonatomic) UIImageView   *_mBgImg1;
@property (strong, nonatomic) UIImageView   *_mBgImg2;
@property (strong, nonatomic) UIImageView   *_mBgImg3;
@property (strong, nonatomic) UIImageView   *_mBgImg4;
@property (strong, nonatomic) UIImageView   *_mBgImg5;

@property (strong, nonatomic) TWebImgView   *_mWebImg1;
@property (strong, nonatomic) TWebImgView   *_mWebImg2;
@property (strong, nonatomic) TWebImgView   *_mWebImg3;
@property (strong, nonatomic) TWebImgView   *_mWebImg4;
@property (strong, nonatomic) TWebImgView   *_mWebImg5;

@property (strong, nonatomic) UIImageView   *_mImg1;
@property (strong, nonatomic) UIImageView   *_mImg2;
@property (strong, nonatomic) UIImageView   *_mImg3;
@property (strong, nonatomic) UIImageView   *_mImg4;
@property (strong, nonatomic) UIImageView   *_mImg5;

@property (strong, nonatomic) UILabel   *_mLabel1;
@property (strong, nonatomic) UILabel   *_mLabel2;
@property (strong, nonatomic) UILabel   *_mLabel3;
@property (strong, nonatomic) UILabel   *_mLabel4;
@property (strong, nonatomic) UILabel   *_mLabel5;
@property (strong, nonatomic) UILabel   *_mLabel6;
@property (strong, nonatomic) UILabel   *_mLabel7;

@property (strong, nonatomic) UIButton  *_mBtn1;
@property (strong, nonatomic) UIButton  *_mBtn2;
@property (strong, nonatomic) UIButton  *_mBtn3;
@property (strong, nonatomic) UIButton  *_mBtn4;
@property (strong, nonatomic) UIButton  *_mBtn5;

@property (strong, nonatomic) IBOutlet UIImageView *_mLine;

@property (nonatomic, strong) IBOutlet UIView *_contentView;

+ (TBaseTableCell *)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

/// 根据布局方法名布局
- (void)layoutCellWithTypeSEL:(NSString *)type item:(id)item;

/// 根据 reuserIdentifier 布局方法名布局
- (void)layoutCellWithItem:(id)item;

@end

/// create view and add
@interface TBaseTableCell (createAndAddToContentview)

- (UIImageView *)newImage;
- (TWebImgView *)newWebImage;
- (UILabel *)newLabel;
- (UILabel *)newLabelEx;
//- (FTCoreTextView *)newCoreText;
- (UIButton *)newButton;
- (void) setBackColor:(UIColor*)color cellH:(float)cellH;

@end