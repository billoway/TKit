//
//  BaseInfoView.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//
#define ALPHA           @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define NUMBERS         @"0123456789"
#define ALPHANUM        @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "
#define NUMBERSPERIOD   @"0123456789."

#define f_KeyBoard_H    216


    /// 分区 背景图片 (带阴影)  [默认图片名称: t_edit_round_bg@2x.png ]
static UIImage *img_Section_Bg;
    /// 单元格 分割线    [默认:[UIImage getImage:@"line_h2_a.png"]]
static UIImage *img_Cell_Line;

    /// 分区 背景图片阴影宽    [默认宽度: 1.f]
static float f_Section_bg_shadow_w;
    /// 分区顶部长   [默认:10.f]
static float f_Section_Top;
    /// 分区左边长   [默认:15.f]
static float f_Section_Left;

    /// 单元格高度   [默认:50]
static float f_Cell_h;
    /// 单元格左边标题的宽   [默认:80]
static float f_Cell_Left_w;
    /// 单元格左边标题的最大宽 如果设置此变量 当有标题实际宽超出默认LeftWidth 会自动设置所有LeftWidth  [默认:80]
static float f_Cell_Max_Left_w;
    /// 单元格内容 左边长   [默认:10]
static float f_Cell_Content_left;

    /// 单元格 左边字体   [默认:[UIFont FontOfSize:15.f]]
static UIFont *font_Cell_Left;
    /// 单元格内容 字体   [默认:[UIFont FontOfSize:15.f]]
static UIFont *font_Cell_Content;

    /// 单元格 左边字体颜色   [默认:[UIColor hexColor:@"8190a2"]]
static UIColor *color_Cell_Left;
    /// 单元格内容 字体颜色   [默认:[UIColor hexColor:@"3f4f63"]]
static UIColor *color_Cell_Content;

#import "TEditView.h"
#import "TExt.h"

@interface TEditView ()
{
    float _currY;
}
@property (nonatomic, weak) id <TEditDelegate> _dataSource;

///  键盘弹出
@property (nonatomic, strong) VBlock showBlk;
///  键盘隐藏
@property (nonatomic, strong) VBlock hideBlk;
///  键盘frame 变化
@property (nonatomic, strong) FBlock changeBlk;

@end
@implementation TEditView

/// new
+ (id)editViewWithFrame:(CGRect)frame delegate:(id <TEditDelegate>)delegate
{
    if (!font_Cell_Left) {
        [self defaultSetting];
    }

    TEditView *editView = [[TEditView alloc] initWithFrame:frame];
    editView.showReplace = YES;
    editView.showFullRemark = YES;
    editView.editable = YES;
    editView.hasBorder = YES;
    editView.backgroundColor = [UIColor clearColor];

    editView._dataSource = delegate;
    [editView addNotification];
    return editView;
}

/// 使用自身的数据源 刷新
- (void)refreshTable
{
    [self removeSubviews];
    [self createContentView];
}

- (void)setTitles:(DicExt *)titles
{
    if (!titles) {
        return;
    }

    _titles = titles;

    [self removeSubviews];
    [self createContentView];
}

/// 更新某一行列表的值
- (void)setText:(NSString *)param row:(NSInteger)row
{
    [self.titles.allValues replaceObjectAtIndex:row withObject:param];

    UITextField *tTextField = (UITextField *)[self viewWithTag:row + f_TextfieldTag];
    tTextField.text = param;
}

/// 获取row对应的 UITextField对象
- (UITextField *)getTextFieldAtRow:(NSInteger)currRow
{
    UITextField *tTextField = (UITextField *)[self viewWithTag:currRow + f_TextfieldTag];

    if ([tTextField isKindOfClass:[UITextField class]]) {
        return tTextField;
    }

    return nil;
}

    /// 获取row对应的 值
- (NSString *)getValueAtRow:(NSInteger)currRow
{
    return [self.titles objectAtIndex:currRow];
}

#pragma mark - -------- 页面 ----------
/// 创建内容视图
- (void)createContentView
{
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];

    // 背景
    _currY = f_Section_Top;
    if (self.isFullView) {
        _currY = 0;
    }
    // 分区个数  默认为1
    NSInteger section = 1;

    if ([self._dataSource respondsToSelector:@selector(sectionCount:)]) {
        section = [self._dataSource sectionCount:self];
    }

    // 当前 row 下标  确保 多分区时 row 是累加的
    NSInteger currRow = 0;

    for (NSInteger i = 0; i < section; ) {
        NSInteger rowCount = [self._dataSource rowCountInSection:i table:self];
        [self createSectionView:i++ startRow:currRow];
        currRow += rowCount;
    }

//    self.contentSize = CGSizeMake(self.width, _currY);
    @synchronized(self) {
        self.contentSize = CGSizeMake(self.width, _currY);
    }
}


// 创建一个分区
- (void)createSectionView:(NSInteger)section startRow:(NSInteger)startRow
{
    // 当前row
    NSInteger rowCount = [self._dataSource rowCountInSection:section table:self];
    
    float   tCellH = f_Cell_h;  // 单元格默认高度
    float   tSectionW = self.width - 2 * f_Section_Left;
    float   tSectionH = 0;
    float   tSectionLeft = f_Cell_Content_left;
    
    // section 背景 载体
    CGRect      frame = CGRectMake(f_Section_Left, _currY, tSectionW, tSectionH);
    UIImageView *backView = [UIImageView newImgView:frame];
    backView.userInteractionEnabled = YES;
    if (self.hasBorder) {
        backView.image = img_Section_Bg;
        tSectionW = self.width - 2 * f_Section_Left;
    }else{
        backView.left = 0;
        backView.width = self.width;
        [backView setBorderWidth:0.5 coror:[UIColor hexColor:@"cccccc"]];
        backView.backgroundColor = [UIColor whiteColor];
        
        tSectionW = self.width;
        tSectionLeft = 2*f_Cell_Content_left;
    }
    
    [self addSubview:backView];
    
    float       tCellY = 0.f;
    NSInteger   currRow = 0;
    
    for (NSInteger i = 0; i < rowCount; i++) {
        currRow = startRow + i;
        
        // --- 自定义 cellH
        if ([self._dataSource respondsToSelector:@selector(rowHeightForCurrRow:table:)]) {
            tCellH = [self._dataSource rowHeightForCurrRow:currRow table:self];
        }
        
        // --- custom cellView
        UIView *cellView;
        
        if ([self._dataSource respondsToSelector:@selector(viewForCurrRow:table:)]) {
            cellView = [self._dataSource viewForCurrRow:currRow table:self];
            
            if (cellView) {
                float customH = cellView.height;
                if (self.isFullView) {
                    cellView.frame = CGRectMake(0, tCellY, self.width, customH);
                }else{
                    cellView.frame = CGRectMake(f_Section_bg_shadow_w, tCellY, self.f_Section_w, customH);
                }
                // 分区最后一行 去除阴影高度
                if (i==rowCount-1) {
                    cellView.height -= f_Section_bg_shadow_w;
                }
                
                [backView addSubview:cellView];
                
                tCellY += customH;
                tSectionH += customH;
                continue;
                // 如果有自定义view  直接继续下一轮cell 创建
            }
        }
        
        // --- UITextField
        UITextField *tTextField = nil;
        tTextField = [[UITextField alloc] init];
        tTextField.frame = CGRectMake(tSectionLeft, tCellY, tSectionW - 2 * tSectionLeft, tCellH);
        tTextField.backgroundColor = [UIColor clearColor];
        tTextField.delegate = self;
        tTextField.tag = f_TextfieldTag + currRow;
        [tTextField setFont:font_Cell_Content];
        [tTextField setTextColor:color_Cell_Content];
        [tTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter]; // 垂直居中
        tTextField.leftViewMode = UITextFieldViewModeAlways;
        tTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        tTextField.returnKeyType = UIReturnKeyDone;
        [backView addSubview:tTextField];
        tTextField.text = [self.titles objectAtIndex:currRow];
        if ([self._dataSource respondsToSelector:@selector(contentColorCurrRow:table:)]) {
            id color = [self._dataSource contentColorCurrRow:currRow table:self];
            tTextField.textColor = color;
        }
        
        if (self.showReplace && self.editable) {
            tTextField.placeholder = [NSString stringWithFormat:@"请输入%@", [[self.titles keyAtIndex:currRow] deleteStr:@":"]];
        }
        
        // --- 自定义 leftView
        UIView *leftView = nil;
        
        if ([self._dataSource respondsToSelector:@selector(leftViewForCurrRow:table:)]) {
            leftView = [self._dataSource leftViewForCurrRow:currRow table:self];
        }
        
        // --- 自定义 leftView Width
        float leftWidth = f_Cell_Left_w;
        
        if ([self._dataSource respondsToSelector:@selector(leftWidthForCurrRow:table:)]) {
            float width = [self._dataSource leftWidthForCurrRow:currRow table:self];
            
            if (width>0) {
                leftWidth = width;
            }else if (width<-10) {
                leftWidth = 0;
                tTextField.textAlignment = NSTextAlignmentCenter;
            }
        }
        
        
        // --- 默认 leftView :标题
        if (!leftView) {
            leftView = [[UILabel alloc] init];
            leftView.frame = CGRectMake(0, 0, leftWidth, tCellH);
            leftView.backgroundColor = [UIColor clearColor];
            [(UILabel *)leftView setFont : font_Cell_Left];
            [(UILabel *)leftView setTextColor : color_Cell_Left];
            [(UILabel *)leftView setTextAlignment : NSTextAlignmentLeft];
            [(UILabel *)leftView setText :[self.titles keyAtIndex:currRow]];
            if (self.showFullRemark) {
                if ([[self.titles keyAtIndex:currRow] isContain:@"备注"]) {
                    [(UILabel*)leftView setText:@""];
                    leftView.width = 1.f;
                }
            }
            // 如果不与许编辑 ---- bill_edit
            if (!self.editable) {
                CGSize size = [leftView sizeThatFits:CGSizeMake(self.width, leftView.height)];
                if (size.width > leftWidth) {
                    leftView.width = size.width;
                }
            }
        }
        
        tTextField.leftView = leftView;
        
        // --- 自定义 rightView
        UIView *rightView;
        
        if ([self._dataSource respondsToSelector:@selector(rightViewForCurrRow:table:)]) {
            rightView = [self._dataSource rightViewForCurrRow:currRow table:self];
        }
        
        // 如果不允许编辑 右边 为内容
        if (!self.editable) {
            
            tTextField.text = @"";
            UILabel* rightLabel = [[UILabel alloc] init];
            rightLabel.frame = CGRectMake(leftView.right+4, 0,  tTextField.width-leftView.width-4, tCellH);
            rightLabel.backgroundColor = [UIColor clearColor];
            [rightLabel setNumberOfLines:0];
            [rightLabel setFont : font_Cell_Content];
            [rightLabel setTextColor : color_Cell_Content];
            [rightLabel setTextAlignment : NSTextAlignmentLeft];
            [rightLabel setText :[self.titles objectAtIndex:currRow]];
            
            CGSize size = rightLabel.realSize;
            float topSub = (tCellH-[(UILabel*)leftView realSize].height)/2.f;
            if (size.height + topSub*2 > tCellH) {
                rightLabel.top = 0;
                rightLabel.height = size.height+topSub*2;
                tCellH = rightLabel.height-3;
            }
            [tTextField addSubview:rightLabel];
            tTextField.clipsToBounds = NO;
        }
        
        
        if (rightView) {
            rightView.top = (tCellH - rightView.height) / 2.f;
            tTextField.rightViewMode = UITextFieldViewModeAlways;
            tTextField.rightView = rightView;
        }
        
        // --- 底部绘线
        if (i != rowCount - 1) {
            UIImage* tImage = img_Cell_Line;
            UIImageView *tImgView = [[UIImageView alloc] initWithImage:tImage];
            tImgView.frame = CGRectMake(0, tSectionH + tCellH - tImage.height, tSectionW , tImage.height);
            [tImgView setImage:tImage];
            if (!tImage) {
                tImgView.height = 0.5;
            }
            
            if (self.hasBorder) {
                tImgView.frame = CGRectMake(f_Section_bg_shadow_w, tSectionH + tCellH - tImage.height, tSectionW - f_Section_bg_shadow_w * 2, tImage.height);
            }
            if ([self._dataSource respondsToSelector:@selector(cellLineFrame:table:defaultFrame:)]) {
                CGRect frame = [self._dataSource cellLineFrame:currRow table:self defaultFrame:tImgView.frame];
                if (CGRectGetWidth(frame) > 1 ) {
                    tImgView.frame = frame;
                }
            }
            [backView addSubview:tImgView];
        }
        
        tCellY += tCellH;
        tSectionH += tCellH;
    }

    backView.height = tSectionH;
    _currY += (tSectionH + f_Section_Top);
}

#pragma mark - -------- UITextFieldDelegate ----------

/// 根据textfield 的frame 设置scrollview 的滚动位置 使得编辑中的textfield 上方有一个
- (void)scrollTextField:(float)sY
{
    // 最大滑动高度
    float maxOffsetY = _currY + f_KeyBoard_H - self.height;

    // 最小滑动高度
    float minOffsetY = 0.1f;

    if (maxOffsetY < minOffsetY) {
        return;
    }

    // 标准滑动高度
    float mOffsetY = 53;
    // 实际滑动高度
    float offsetY = sY - mOffsetY;

    if (offsetY > maxOffsetY) {
        offsetY = maxOffsetY;
    } else if (offsetY < minOffsetY) {
        offsetY = minOffsetY;
    }

//    DLog("----->>> ContentOffset: %f",offsetY);
    CGPoint offset = CGPointMake(0, offsetY);
//    [super setContentOffset:offset animated:YES];
    @synchronized(self) {
        [super setContentOffset:offset animated:YES];
    }

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger row = [textField tag] - f_TextfieldTag;

    if (!self.editable) {
        [self._dataSource didSelectCurrRow:row table:self];
        return NO;
    }

    BOOL canEdit = [self._dataSource didSelectCurrRow:row table:self];
    
    if (!canEdit) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
    
    return canEdit;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint point = [textField convertPoint:CGPointZero toView:self];

    [self scrollTextField:point.y];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger   row = [textField tag] - f_TextfieldTag;
    NSString    *text = [textField.text deleteSpace];

    if (k_Is_Empty(text)) {
        text = @"";
    }

    [self.titles.allValues replaceObjectAtIndex:row withObject:text];
    
    if ([self._dataSource respondsToSelector:@selector(doneSelectCurrRow:table:)]) {
        [self._dataSource doneSelectCurrRow:row table:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger       row = [textField tag] - f_TextfieldTag;
    BOOL            isChange = YES;
    UIKeyboardType  keyboard = [textField keyboardType];

    if ((keyboard == UIKeyboardTypeNumberPad) || (keyboard == UIKeyboardTypePhonePad) || (keyboard == UIKeyboardTypeNumbersAndPunctuation)) {
        NSCharacterSet  *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSPERIOD] invertedSet];
        NSString        *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];

        isChange = [string isEqualToString:filtered];
    }

    // 交给数据源实现对应委托
    BOOL isDeleteChange = YES;

    if ([self._dataSource respondsToSelector:@selector(shouldChangeRow:range:replacementString:table:)]) {
        isDeleteChange = [self._dataSource shouldChangeRow:row range:range replacementString:string table:self];
    }

    return isChange && isDeleteChange;
}

#pragma mark - -------- 键盘通知事件 ----------

- (void)keyboardWillChange:(NSNotification *)notification
{
    NSDictionary    *userInfo = [notification userInfo];
    NSValue         *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect          keyboardRect = [aValue CGRectValue];

    float boardH = keyboardRect.size.height;

    if (boardH > 260) {
        boardH = 250;
    }

//    self.contentSize = CGSizeMake(self.width, _currY + boardH);
    @synchronized(self) {
        self.contentSize = CGSizeMake(self.width, _currY + boardH);
    }
    if (self.changeBlk) {
        self.changeBlk(boardH);
    }

}

- (void)keyboardWillHide:(NSNotification *)notification
{
    @synchronized(self) {
        
        // DLog("----->>> ===>> Offset: %f",self.contentOffset.y);
        
        CGPoint currOffset = self.contentOffset;
        self.contentSize = CGSizeMake(self.width, _currY);
        CGFloat maxH = self.contentSize.height-self.height;
        if (currOffset.y>self.contentSize.height-self.height && maxH>0) {
            [super setContentOffset:CGPointMake(0, self.contentSize.height-self.height) animated:YES];
        }
        if (self.hideBlk) {
            self.hideBlk();
        }
    }
}

- (void)addNotification
{
    NSNotificationCenter *tCenter = [NSNotificationCenter defaultCenter];
    [tCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [tCenter addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeNotification
{
    NSNotificationCenter *tCenter = [NSNotificationCenter defaultCenter];

    [tCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [tCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void) addKeyBoardNotifiBySource:(id)viewSource keyBoardShow:(VBlock)show keyBoardChange:(FBlock)change keyBoardHide:(VBlock)hide
{
    self.showBlk = show;
    self.hideBlk = hide;
    self.changeBlk = change;
}


#pragma mark - -------- 内存 ----------

- (void)dealloc
{
    [self removeNotification];
}

#pragma mark - -------- 默认 与初始化 框架常量 ----------

+ (void)defaultSetting
{
    img_Section_Bg = [[UIImage getImage:@"round_bg_1@2x.png"] resizableImage:6 left:6 bottom:6 right:6];
    img_Cell_Line = [UIImage getImage:@"line_h2_a"];

    f_Section_bg_shadow_w = 2.f / 2;
    f_Section_Top = 25 / 2.f;
    f_Section_Left = 25 / 2.f;
    f_Cell_h = 44.f;
    f_Cell_Content_left = 10.f;
    f_Cell_Left_w = 85.f;
    f_Cell_Max_Left_w = 0.f;

    font_Cell_Left = [UIFont FontOfSize:f_auto_scale(13.f)];
    font_Cell_Content = [UIFont FontOfSize:f_auto_scale(13.f)];

    color_Cell_Left = [UIColor hexColor:@"888888"];
    color_Cell_Content = [UIColor hexColor:@"333333"];
}

-(float) f_Section_Top
{
    return f_Section_Top;
}
-(float) f_Section_Left
{
    return f_Section_Left;
}
-(float) f_Section_bg_shadow_w
{
    return f_Section_bg_shadow_w;
}
-(float) f_Section_w
{
    return f_Device_w-2*f_Section_Left-2*f_Section_bg_shadow_w;
}

@end

@implementation TEditView (EditView)

/// 单元格 背景图片 (带阴影)  [默认图片名称: t_edit_section_bg@2x.png ]
+ (void)regist_EditSectionBgImage:(UIImage *)image
{
    img_Section_Bg = image;
}

/// 单元格 背景图片阴影宽    [默认宽度: 1.f]
+ (void)regist_EditSectionBgShadowWidth:(float)width
{
    f_Section_bg_shadow_w = width;
}

/// 分区顶部长   [默认:10.f]
+ (void)regist_EditSectionTop:(float)top
{
    f_Section_Top = top;
}

/// 分区左边长   [默认:15.f]
+ (void)regist_EditSectionLeft:(float)left
{
    f_Section_Left = left;
}

/// 单元格左边标题的宽   [默认:80]
+ (void)regist_EditCellLeftWidth:(float)width
{
    f_Cell_Left_w = width;
}

/// 单元格左边标题的最大宽 如果设置此变量 当有标题实际宽超出默认LeftWidth 会自动设置所有LeftWidth  [默认:80]
+ (void)regist_EditCellMaxLeftWidth:(float)width
{
    f_Cell_Max_Left_w = width;
}

/// 单元格高度   [默认:44]
+ (void)regist_EditCellHeight:(float)height
{
    f_Cell_h = height;
}

/// 单元格内容 左边长   [默认:10]
+ (void)regist_EditCellContentLeft:(float)left
{
    f_Cell_Content_left = left;
}

/// 单元格 左边字体   [默认:[UIFont FontOfSize:15.f]]
+ (void)regist_EditCellLeftFont:(UIFont *)font
{
    font_Cell_Left = font;
}

/// 单元格内容 字体   [默认:[UIFont FontOfSize:15.f]]
+ (void)regist_EditCellContentFont:(UIFont *)font
{
    font_Cell_Content = font;
}

/// 单元格 左边字体颜色   [默认:[UIColor hexColor:@"8190a2"]]
+ (void)regist_EditCellLeftColor:(UIColor *)color
{
    color_Cell_Left = color;
}

/// 单元格内容 字体颜色   [默认:[UIColor hexColor:@"3f4f63"]]
+ (void)regist_EditCellContentColor:(UIColor *)color
{
    color_Cell_Content = color;
}

/// 单元格 分割线    [默认:[UIImage getImage:@"line_h2_a"]]
+ (void)regist_EditCellLineImg:(UIImage *)image
{
    img_Cell_Line = image;
}

@end