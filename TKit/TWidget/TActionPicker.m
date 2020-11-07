//
//  TActionPicker.m
//  oaclient
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//


#define Action_H        284
#define Action_H1       234
#define Action_H2       334
#define Action_H3       184
#define Action_H4       384
//#define Action_H5       134
//#define Action_H6       434

#import "TActionPicker.h"
#import "TExt.h"

@interface TActionPicker ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UILabel *_pickTitle;
}
@property (nonatomic, strong)   UIImageView *_toolBar;
@property (nonatomic, assign)   TPickType   _type;

@property (nonatomic, strong)   PickBlk     _pickBlk;
@property (nonatomic, strong)   DatePickBlk _datePickBlk;

@end
@implementation TActionPicker

+ (id)pickWithTitle:(NSString *)title
{
    return [[self alloc] initWithType:PickDateType title:@"" height:Action_H];
}

+ (id)pickWithType:(TPickType)type
{
    return [[self alloc] initWithType:type title:@"" height:Action_H];
}

+ (id)pickWithType:(TPickType)type title:(NSString *)title
{
    return [[self alloc] initWithType:type title:title height:Action_H];
}

- (void)setPickTitle:(NSString *)title
{
    _pickTitle.text = title;
}

- (void)set_type:(TPickType)_type
{
    __type = _type;
    self._pickerView.hidden = _type != PickNormalType;
    self._datePicker.hidden = _type != PickDateType;
}

-(void) setItems:(NSArray *)items
{
    if (!items || items.count<1) {return;}
    
    _realItems = [NSMutableArray arrayWithArray:items];
        // 如果数组内为数组 默认为多列 picker
    if (self.singleComponents) {
        self.singleComponents = ![[_realItems objectAtIndex:0] isKindOfClass:[NSArray class]];
    }
    
        // 单列 显示选中index  多列默认选中都为0
    self.isShowSelect = self.singleComponents;
    if (!self.singleComponents) {
            // 重置选择下标
        for (int i=0; i<_realItems.count; i++) {
            [self._selectIndexs addObject:[NSNumber numberWithInt:0]];
        }
    }
}

-(NSArray*) items
{
    if (!_realItems) {
        _realItems = [NSMutableArray array];
    }
    return _realItems;
}

// ------- 普通选择器
#pragma mark - -------- 普通选择器 ----------

/// 手动选择某行
- (void)doSelectPicker
{
    if (self.singleComponents) {
        if (self.isShowSelect) {
            [self._pickerView selectRow:self._selectIndex inComponent:0 animated:NO];
        }
    } else{
        if (!self.isShowSelect) {
            return;
        }
        for (int section=0; section<self.items.count; section++) {
            int row = [[self._selectIndexs objectAtIndex:section] intValue];
            [self._pickerView selectRow:row inComponent:section animated:NO];
        }
    }
}


- (void)showPickerIn:(UIView *)view click:(PickBlk)click
{
    self._type = PickNormalType;
    self._pickBlk = click;
    [self showInView:view];
    [self._pickerView reloadAllComponents];
    [self doSelectPicker];

}

/// 弹出选择器
- (void)showPicker:(id)items click:(PickBlk)click
{
    if (!items || ![items isKindOfClass:[NSArray class]] || [items count] < 1) {
        return;
    }
    self._type = PickNormalType;
    self.items = items;
    self._pickBlk = click;
    [self._pickerView reloadAllComponents];
    [self doSelectPicker];
}

/// 弹出选择器
- (void)showPicker:(id)items view:(UIView *)view click:(PickBlk)click
{
    self._type = PickNormalType;
    [self showPicker:items click:click];
    [self showInView:view];
    [self._pickerView reloadAllComponents];
    [self doSelectPicker];
}

#pragma mark - -------- 日期选择器 ----------
// ------- 日期选择器
/// 设置日期时间
- (void)doSelectDate:(NSDate *)date
{
    if (!date) {
        date = [NSDate date];
    }

    self._selectDate = date;
    self._datePicker.date = self._selectDate;
}

/// 设置日期选择器 大小限制 和日期格式
- (void)setMaxDate:(NSDate *)maxDate minDate:(NSDate *)minDate dateModel:(UIDatePickerMode)dateModel
{
    if (!self._datePicker) {
        [self createNormalPicker];
    }

    self._pickerView.hidden = YES;
    self._datePicker.hidden = NO;

    if (!self._selectDate) {
        self._selectDate = [NSDate date];
        self._datePicker.date = self._selectDate;
    }

    [self._datePicker setDatePickerMode:dateModel];

    if (minDate) {
        [self._datePicker setMinimumDate:minDate];
    }

    if (maxDate) {
        [self._datePicker setMaximumDate:maxDate];
    }
}

/// 弹出日期选择器
- (void)showDatePicker:(DatePickBlk)click
{
    self._datePickBlk = click;
    //    [self._datePicker reloadInputViews];
}

/// 弹出日期选择器
- (void)showDatePicker:(UIView *)view click:(DatePickBlk)click
{
    self._type = PickDateType;
    [self showDatePicker:click];
    [self showInView:view];
}

#pragma mark - -------- _dataSource ----------

- (void)doDone
{
    self._selectDate = [self._datePicker date];
    
    if (self.singleComponents) {
        if (self._selectIndex>=self.items.count) {
            self._selectIndex = self.items.count-1;
        }
    }
    BOOL isDiss = NO;
    
    if (__type == PickNormalType) {
        if (self._pickBlk) {
            
                // 多列时 拼接选择的内容
            if (!self.singleComponents) {
                NSString* selectTitle = @"";
                for (int section=0; section<self.items.count; section++) {
                    int row = [[self._selectIndexs objectAtIndex:section] intValue];
                    id rowDatas = [self.items objectAtIndex:section];
                    if ([rowDatas count]>row) {
                        NSString* tTitle = [[rowDatas objectAtIndex:row] description];
                        selectTitle = [selectTitle appendStr:tTitle];
                    }
                }
                self._selectItem = selectTitle;
            }else{
                self._selectItem = [[self.items objectAtIndex:self._selectIndex] description];
            }
            
            isDiss = self._pickBlk(self, self._selectItem);
        }
    } else {
        if (self._datePickBlk) {
            isDiss = self._datePickBlk(self, self._selectDate);
        }
    }
    
    if (isDiss) {
        self._pickBlk = nil;
        [self dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)doCancel
{
    if (self.cancelBlk) {
        self.cancelBlk();
    }
    [self dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark - -------- private method ----------

- (id)initWithType:(int)type title:(NSString *)title height:(float)height
{
//    self = [super initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"1",@"2",@"3",@"4",@"5", nil];
    self = [super init];
    if (self) {
        /*
         *   因为是通过给ActionSheet 加 Button来改变ActionSheet, 所以大小要与actionsheet的button数有关
         *   height = 84, 134, 184, 234, 284, 334, 384, 434, 484
         *   如果要用self.view = anotherview.  那么another的大小也必须与view的大小一样
         */
        self.actionSheetStyle = UIBarStyleBlackOpaque;
        self.singleComponents = YES;
        self._selectIndexs = [NSMutableArray array];
        int btnNum = (height - 40) / 50;

        for (int i = 0; i < btnNum; i++) {
            [self addButtonWithTitle:@" "];
        }

        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, f_Device_w, height)];
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if (!Is_up_Ios_8) {
            [self addSubview:self.view];
            [self bringSubviewToFront:self.view];
        }else{
            self.view.height = Action_H3;
            self.view.top = f_Device_h;
        }
        
        [self createNormalPicker];
        [self createDatePicker];

        [self createToolBar:title];

        // 根据类型创建不同的 picker
        self._type = type;
    }

    return self;
}

- (void)createToolBar:(NSString *)titleName
{
    UIImageView *tImgView = nil;

    tImgView = [[UIImageView alloc] init];
    tImgView.frame = CGRectMake(0, 0, f_Device_w, f_Tool_Bar_h);
    tImgView.userInteractionEnabled = YES;
    tImgView.backgroundColor = [UIColor blackColor];
    [tImgView setImage:[UIImage getImage:@"TPick_toolbar_bg.png"]];
    [self.view addSubview:tImgView];
    self._toolBar = tImgView;

    UIButton *tButton = nil;
    tButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tButton.frame = CGRectMake(5, (f_Tool_Bar_h - 29.5) / 2.f, 60, 29.5f);
    tButton.tag = 50;
    [tButton setTitle:@"取消" forState:UIControlStateNormal];
    [tButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tButton.titleLabel setFont:[UIFont FontOfSize:14.f]];
    [tButton setBackgroundImage:[UIImage getImage:@"TPick_toolbar_btn.png"] forState:UIControlStateNormal];
    [tButton setBackgroundImage:[UIImage getImage:@"TPick_toolbar_btn_h.png"] forState:UIControlStateHighlighted];
    [tButton addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    [self._toolBar addSubview:tButton];

    tButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tButton.frame = CGRectMake(f_Device_w - 65, (f_Tool_Bar_h - 29.5) / 2.f, 60, 29.5f);
    tButton.tag = 51;
    [tButton setTitle:@"确定" forState:UIControlStateNormal];
    [tButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tButton.titleLabel setFont:[UIFont FontOfSize:14.f]];
    [tButton setBackgroundImage:[UIImage getImage:@"TPick_toolbar_btn.png"] forState:UIControlStateNormal];
    [tButton setBackgroundImage:[UIImage getImage:@"TPick_toolbar_btn_h.png"] forState:UIControlStateHighlighted];
    [tButton addTarget:self action:@selector(doDone) forControlEvents:UIControlEventTouchUpInside];
    [self._toolBar addSubview:tButton];

    UILabel *tLabel = nil;
    tLabel = [[UILabel alloc] init];
    tLabel.frame = CGRectMake(65, 0, f_Device_w - 65 * 2, f_Tool_Bar_h);
    tLabel.backgroundColor = [UIColor clearColor];
    [tLabel setText:titleName];
    [tLabel setFont:[UIFont FontOfSize:16.f]];
    [tLabel setTextColor:[UIColor whiteColor]];
    [tLabel setTextAlignment:NSTextAlignmentCenter];
    [tLabel setNumberOfLines:1];
    [self._toolBar addSubview:tLabel];
    _pickTitle = tLabel;
}

- (void)createNormalPicker
{
    UIPickerView *tPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, f_Tool_Bar_h, f_Device_w, Action_H - f_Tool_Bar_h)];
    if (Is_up_Ios_7) {
        tPicker.top -= 34;
    }
    
    tPicker.delegate = self;
    tPicker.dataSource = self;
    tPicker.showsSelectionIndicator = YES;
    [self.view addSubview:tPicker];
    self._pickerView = tPicker;
}

- (void)createDatePicker
{
    UIDatePicker *tDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, f_Tool_Bar_h, f_Device_w, Action_H - f_Tool_Bar_h)];
    if (Is_up_Ios_7) {
        tDatePicker.top -= 34;
    }

    tDatePicker.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tDatePicker];
    self._datePicker = tDatePicker;
}

#pragma mark - -------- UIPickerDelegate ----------

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_normalPickerDelegate && [_normalPickerDelegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [_normalPickerDelegate pickerView:self._pickerView didSelectRow:row inComponent:component];
        if (!self.singleComponents) {
            NSNumber* number = [NSNumber numberWithInteger:row];
            [self._selectIndexs replaceObjectAtIndex:component withObject:number];
        }
    } else {
            // 多列时 选择后 替换对应的选择下标
        if (!self.singleComponents) {
            NSNumber* number = [NSNumber numberWithInteger:row];
            [self._selectIndexs replaceObjectAtIndex:component withObject:number];
        }else{
                // 单列时选择
            self._selectIndex = row;
            self._selectItem = [[self.items objectAtIndex:row] description];
        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_normalPickerDelegate && [_normalPickerDelegate respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        return [_normalPickerDelegate pickerView:pickerView numberOfRowsInComponent:component];
    }
    if (!self.singleComponents) {
        if ([[self.items objectAtIndex:component] count]>0) {
            return [[self.items objectAtIndex:component] count];
        }
        return 1;
    }
    return self.items.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_normalPickerDelegate && [_normalPickerDelegate respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        return [_normalPickerDelegate numberOfComponentsInPickerView:pickerView];
    }
    if (!self.singleComponents) {
        return self.items.count;
    }
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_normalPickerDelegate && [_normalPickerDelegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
        return [_normalPickerDelegate pickerView:pickerView titleForRow:row forComponent:component];
    }
    if (!self.singleComponents) {
        return [[[self.items objectAtIndex:component] objectAtIndex:row] description];
    }
    return [[self.items objectAtIndex:row] description];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (_normalPickerDelegate && [_normalPickerDelegate respondsToSelector:@selector(pickerView:widthForComponent:)]) {
        return [_normalPickerDelegate pickerView:pickerView widthForComponent:component];
    }

    if (!self.singleComponents) {
        return 292.5f/self.items.count;
    }
    return 292.5f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!self.singleComponents) {
        if ([[self.realItems objectAtIndex:component] count]==0) {
            return nil;
        }
    }
    
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
//        pickerLabel.frame = CGRectMake(0, 0, 200, 30);
        [pickerLabel setFont:[UIFont FontOfSize:20]];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.minFontSizeForScale = 5.5f;
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        if (self.singleComponents) {
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        }
    }
        // Fill the label text here
    pickerLabel.text=[[@" " appendStr:[self pickerView:pickerView titleForRow:row forComponent:component]] appendStr:@" "];
    
    return pickerLabel;
}

#pragma mark - -------- ios8 ----------

// UIPicker显示
- (void)showInView:(UIView *)view
{
    if (!Is_up_Ios_8) {
        [super showInView:view];
        return;
    }
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        // 添加阴影
        UIView *shadowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        shadowView.userInteractionEnabled = NO;
        shadowView.tag = 1024;
        [view addSubview:shadowView];
        [view bringSubviewToFront:shadowView];
        // 添加UIPickerView
//        [self setFrame:CGRectMake(0, f_Device_h-self.view.height, [UIScreen mainScreen].bounds.size.width, self.pickView.frame.size.height)];
        self.view.bottom = shadowView.height;
        [view addSubview:self.view];
        [view bringSubviewToFront:self.view];
        // navigationItem 禁用
        UIViewController *viewController = [self viewController];
        viewController.navigationItem.leftBarButtonItem.enabled = NO;
        viewController.navigationItem.rightBarButtonItem.enabled = NO;
        
        // 除了UIPickerView外 禁用
        for (UIView *subView in [view subviews]) {
            if (![self.view isEqual:subView]) {
                subView.userInteractionEnabled = NO;
            }
        }
    } completion:^(BOOL isFinished){
        
    }];
}

-(void) dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (!Is_up_Ios_8) {
        [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
        return;
    }
    [self hidePickerView];
}

// UIPicker隐藏
-(void)hidePickerView
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        // 去掉阴影，去掉禁用
        for (UIView *subView in [[self.view superview] subviews]) {
            if (subView.tag == 1024) {
                [subView removeFromSuperview];
            }else{
                subView.userInteractionEnabled = YES;
            }
        }
        // UIPickerView隐藏
//        [self.view setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.view.top = f_Device_h;
        //  navigationItem可用
        UIViewController *viewController = [self viewController];
        viewController.navigationItem.leftBarButtonItem.enabled = YES;
        viewController.navigationItem.rightBarButtonItem.enabled = YES;
        
    } completion:^(BOOL isFinished){
        
    }];
}

// 通过UIView查找UIViewController
- (UIViewController *)viewController {
    UIResponder *responder = self.view;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIViewController *)responder;
}


#pragma mark - -------- 内存 ----------

- (void)dealloc
{
    self._datePicker.date = [NSDate date];
    self._datePicker = nil;
    self._datePicker.minimumDate = nil;
    self._datePicker.maximumDate = nil;
    self._datePicker.datePickerMode = UIDatePickerModeDateAndTime;

    self._selectDate = nil;
    self._pickerView = nil;
    self._toolBar = nil;
    self.items = nil;
}

@end