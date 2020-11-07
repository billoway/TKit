//
//  TRefreshScrollView.m
//  uApp
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Gear. All rights reserved.
//

#define F_REFRESH_VIEW_H        40.f

#define S_REFRESH_TEXT_NORMAL   @"下拉可以刷新"
#define S_REFRESH_TEXT_DOWN     @"释放刷新数据"
#define S_REFRESH_TEXT_LOAD     @"加载中..."

#define REFRESH_NORMAL          0
#define REFRESH_DOWN            1
#define REFRESH_LOAD            2

#import "TRefreshScrollView.h"
#import "TExt.h"

@interface TRefreshScrollView () <UIScrollViewDelegate>

/// 刷新状态 status ( 0:normal 1:free to refresh 2:loading )
@property (nonatomic, assign) int status;
/// refresh BLOCK
@property (nonatomic, strong) VBlock        refreshBlock;
@property (nonatomic, strong) UIImageView   *arrowView;
@property (nonatomic, strong) UILabel       *refreshLabel;
// @property (nonatomic, strong) UILabel* dateLabel;
// @property (nonatomic, strong) UIActivityIndicatorView* indicatorView;

@end

@implementation TRefreshScrollView

/// 刷新
- (void)doRefreshBlock:(VBlock)refresh;
{
    self.refreshBlock = refresh;
}

/// 数据刷新完成调用
- (void)doneRefresh;
{
    self.status = REFRESH_NORMAL;
}
/// 加载子视图
- (void)addContentView:(UIView *)view;
{
    [self addSubview:view];
    self.contentSize = CGSizeMake(self.width, view.bottom>self.height+1?view.bottom:self.height+1);
}
/// 移除子视图
- (void)removeContentViews;
{
    for (UIView *view in self.subviews) {
        if (view.tag != 9999) {
            [view removeFromSuperview];
        }
    }
}
#pragma mark - -------- private method ----------

- (void)setRefreshEnable:(BOOL)refreshEnable
{
    _refreshEnable = refreshEnable;
    _headView.hidden = !_refreshEnable;
    [self setShowsVerticalScrollIndicator:_refreshEnable];
}

- (void)setStatus:(int)status
{
    if (_status == status) {
        return;
    }
    _status = status;

    _arrowView.hidden = NO;
    switch (status) {
        case 0:
                [UIView beginAnimations:nil context:nil];
                _arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
                [UIView commitAnimations];
                _refreshLabel.text = S_REFRESH_TEXT_NORMAL;
                self.contentInset = UIEdgeInsetsZero;
                break;

        case 1:
                [UIView beginAnimations:nil context:nil];
                _arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                [UIView commitAnimations];
                _refreshLabel.text = S_REFRESH_TEXT_DOWN;

                break;

        case 2:
                _arrowView.hidden = YES;
                _refreshLabel.text = S_REFRESH_TEXT_LOAD;
                self.contentInset = UIEdgeInsetsMake(F_REFRESH_VIEW_H, 0, 0, 0);

                // 开始加载
                if (self.refreshBlock) {
                    self.refreshBlock();
                }
                break;
        default:
            break;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        _status = 0;
        self.delegate = self;
        self.tag = 8888;
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        
        UIView *headView = [UIView newView:CGRectMake(0, 0 - F_REFRESH_VIEW_H, self.width, F_REFRESH_VIEW_H)];
        headView.tag = 9999;
        [self addSubview:headView];
        self.headView = headView;
        
        // arrow image
//        float scale = [UIScreen mainScreen].scale/2;
//        UIImage* arrImage = [UIImage imageNamed:@"PullToRefresh.bundle/arrow_down@2x.png"];
        _arrowView = [UIImageView newImgViewByImg:[UIImage imageNamed:@"PullToRefresh.bundle/arrow_down@2x.png"]];
//        _arrowView.size = CGSizeMake(arrImage.width*scale, arrImage.height*scale);
        _arrowView.center = CGPointMake(80, F_REFRESH_VIEW_H / 2);
        [headView addSubview:_arrowView];

        // refresh Label
        float textX = _arrowView.right + 10;
        _refreshLabel = [UILabel newLabel:CGRectMake(textX, 0, self.width - textX * 2, F_REFRESH_VIEW_H)];
        [_refreshLabel dosetText:S_REFRESH_TEXT_NORMAL font:14.5 color:[UIColor hexColor:@"999999"]];
        _refreshLabel.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:_refreshLabel];
        self.contentInset = UIEdgeInsetsZero;
        self.contentOffset = CGPointZero;
    }

    return self;
}

#pragma mark - -------- scrollview method ----------

- (void)tableViewDidDragging
{
    CGFloat offsetY = self.contentOffset.y;

    //  正在加载不做处理  ||  不允许刷新 不作处理
    if (self.status == REFRESH_LOAD || !self.refreshEnable) {
        return;
    }

    //  拉动位移超过指定大小 提示:释放刷新
    if (offsetY < -F_REFRESH_VIEW_H - 10) {
        self.status = REFRESH_DOWN;
    } else {
        self.status = REFRESH_NORMAL;
    }
}

- (void)tableViewDidEndDragging
{
    CGFloat offsetY = self.contentOffset.y;

    //  正在加载不做处理 ||  不允许刷新 不作处理
    if (self.status == REFRESH_LOAD || !self.refreshEnable) {
        return;
    }

    //  拉动位移超过指定大小
    if (offsetY < 0 - F_REFRESH_VIEW_H - 10) {
        // 已经提示了 就刷新
        if (self.status == REFRESH_DOWN) {
            self.status = REFRESH_LOAD;
        } else {
            // 没有提示则复原
            self.status = REFRESH_NORMAL;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 8888) {
        [self tableViewDidDragging];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.tag == 8888) {
        [self tableViewDidEndDragging];
    }
}

@end