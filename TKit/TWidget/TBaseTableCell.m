//
//  TableViewCell.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TBaseTableCell.h"
#import "TExt.h"
#import "TWebImgView.h"

@interface TBaseTableCell ()

@end

@implementation TBaseTableCell

- (void)testCell:(id)item
{
    if (item) {
        [self._mLabel1 setText:[NSString stringWithFormat:@"显示标题 =>%ld", (long)self.indexPath.section]];
        [self._mLabel2 setText:[NSString stringWithFormat:@"显示描述 显示详情 显示更多内容 =>%ld", (long)self.indexPath.row]];
        return;
    }
    
    self._mLabel1 = [self newLabel];
    self._mLabel1.frame = CGRectMake(20, 5, f_Device_w - 40, 20);
    [self._mLabel1 dosetText:nil font:16 color:@"000000"];
    
    self._mLabel2 = [self newLabel];
    self._mLabel2.frame = CGRectMake(20, 30, f_Device_w - 40, 20);
    [self._mLabel2 dosetText:nil font:16 color:@"000000"];
    self._mLabel2.textAlignment = NSTextAlignmentRight;
    
    self._mLine = [self newImage];
    self._mLine.frame = CGRectMake(0, 50 - 0.5, f_Device_w, 0.5);
    self._mLine.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - -------- refresh Cell With Type ----------

- (void)layoutCellWithItem:(id)item;
{
    [self layoutCellWithTypeSEL:self._identifier item:item];
}

- (void)layoutCellWithTypeSEL:(NSString *)type item:(id)item
{
    SEL cellLayout = (SEL)NSSelectorFromString(type);

    if (!cellLayout || ![self respondsToSelector:cellLayout]) {
        DLog(" Warning ==> cell type 【method：%@】 not found !!!", type);
        return;
    }

    // 传入数据, 赋值并布局
    SuppressPerformSelectorLeakWarning([self performSelector:cellLayout withObject:item]);
}


#pragma mark - -------- private method ----------

+ (TBaseTableCell *)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [[TBaseTableCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        self.opaque = NO;
//        self.contentView.opaque = NO;
        
//        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
//        [self setBackgroundView:nil];
        
        self._identifier = reuseIdentifier;
    }

    return self;
}

- (void)set_identifier:(NSString *)identifier
{
    __identifier = identifier;
    // 无数据的样式布局
    SEL create = (SEL)NSSelectorFromString(identifier);

    if ([self respondsToSelector:create]) {
        SuppressPerformSelectorLeakWarning([self performSelector:create withObject:nil]);
    }
}

@end

@implementation TBaseTableCell (createAndAddToContentview)

// --- UIImageView factory
- (UIView *)newBgView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.contentView addSubview:bgView];
    return bgView;
}

// --- UIImageView factory
- (UIImageView *)newImage
{
    UIImageView *tImgView = [[UIImageView alloc] initWithFrame:CGRectZero];

    [self.contentView addSubview:tImgView];
    return tImgView;
}

// --- newWebImage factory
- (TWebImgView *)newWebImage
{
    TWebImgView *tImgView = nil;

    tImgView = [[TWebImgView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:tImgView];
    return tImgView;
}

// --- UILabel factory
- (UILabel *)newLabel
{
    UILabel *tLabel = nil;

    tLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tLabel.backgroundColor = [UIColor clearColor];
    [tLabel setFont:[UIFont FontOfSize:15.f]];
    [tLabel setNumberOfLines:1];
    [self.contentView addSubview:tLabel];

    return tLabel;
}

// --- UILabelEx factory
- (UILabel *)newLabelEx
{
    UILabel *tLabel = nil;

    tLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tLabel.backgroundColor = [UIColor clearColor];
    [tLabel setFont:[UIFont FontOfSize:15.f]];
    [tLabel setNumberOfLines:1];
    [self.contentView addSubview:tLabel];

    return tLabel;
}

//// --- FTCoreTextView factory
//- (FTCoreTextView *)newCoreText
//{
//    FTCoreTextView *coreTextView = [[FTCoreTextView alloc] initWithFrame:CGRectZero];
//
//    coreTextView.autoresizesSubviews = YES;
//    [coreTextView setBackgroundColor:[UIColor clearColor]];
//    [self.contentView addSubview:coreTextView];
//    return coreTextView;
//}

// --- UIButton factory
- (UIButton *)newButton
{
    UIButton *tButton = nil;

    tButton = [[UIButton alloc] initWithFrame:CGRectZero];
    tButton.clipsToBounds = YES;
    [tButton.titleLabel setFont:[UIFont FontOfSize:15.f]];
    [tButton setShowsTouchWhenHighlighted:NO];
    [tButton setAdjustsImageWhenHighlighted:NO];
    [self.contentView addSubview:tButton];

    return tButton;
}


- (void) setBackColor:(UIColor*)color cellH:(float)cellH;
{
    if (Is_up_Ios_7) {
        self.backgroundColor = color;
        self.contentView.backgroundColor = color;
    }else{
        self._bgView = [self newBgView];
        self._bgView.backgroundColor = color;
        self._bgView.frame = CGRectMake(0, 0, self.width, cellH);
    }

//    if ([color isKindOfClass:[UIColor class]]) {
//        if (Is_up_Ios_7) {
//            self.backgroundColor = color;
//            self.contentView.backgroundColor = color;
//        }else{
//            self._bgView = [self newBgView];
//            self._bgView.backgroundColor = color;
//            self._bgView.frame = CGRectMake(0, 0, self.width, self.height);
//        }
//        
//    }else if ([color isKindOfClass:[NSString class]]){
//        if (Is_up_Ios_7) {
//            self.backgroundColor = [UIColor hexColor:color];
//            self.contentView.backgroundColor = [UIColor hexColor:color];
//        }else{
//            self._bgView = [self newBgView];
//            self._bgView.backgroundColor = [UIColor hexColor:color];
//            self._bgView.frame = CGRectMake(0, 0, self.width, self.height);
//        }
//    }
}

-(void) setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.contentView.backgroundColor = backgroundColor;
}

@end