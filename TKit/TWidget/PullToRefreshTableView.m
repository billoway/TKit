//
//  PullToRefreshTableView.m
//  _app
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#define f_img_left                  70
#define k_PULL_STATE_NORMAL         0       //  状态标识：下拉可以刷新/上拖加载更多
#define k_PULL_STATE_DOWN           1       //  状态标识：释放可以刷新
#define k_PULL_STATE_LOAD           2       //  状态标识：正在加载
#define k_PULL_STATE_UP             3       //  状态标识：释放加载更多
#define k_PULL_STATE_END            4       //  状态标识：已加载全部数据


#define k_VIEW_TYPE_HEADER          0       //  视图标识：下拉刷新视图
#define k_VIEW_TYPE_FOOTER          1       //  视图标识：上拖加载视图

#define k_STATE_VIEW_HEIGHT         40      //  视图窗体：视图高度
#define k_STATE_VIEW_INDICATE_WIDTH 60      //  视图窗体：视图箭头指示器宽度

#define k_STATE_SHOW_TIME           1
#define k_STATE_HIDE_TIME           2

#import "PullToRefreshTableView.h"
#import <QuartzCore/QuartzCore.h>
#import "TExt.h"

/// 加载更多 0: 松开加载 1:位移超过范围即开始加载
static int kLoadMoreType;
#pragma mark - -------- StateView ----------
/// StateView 顶部和底部状态视图
@interface StateView : UIView

@property (nonatomic, strong)   UIActivityIndicatorView *indicatorView; //  加载指示器（菊花圈）
@property (nonatomic, strong)   UIImageView             *arrowView;     //  箭头视图
@property (nonatomic, strong)   UILabel                 *stateLabel;    //  状态文本
@property (nonatomic, strong)   UILabel                 *timeLabel;     //  时间文本
@property (nonatomic)           int viewType;                           //  标识是下拉还是上拖视图
@property (nonatomic)           int currentState;                       //  标识视图当前状态

@end

@implementation StateView

- (id)initWithFrame:(CGRect)frame viewType:(int)type
{
    CGFloat width = frame.size.width;

    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width, k_STATE_VIEW_HEIGHT)];

    if (self) {
        //  设置当前视图类型
        self.viewType = type == k_VIEW_TYPE_HEADER ? k_VIEW_TYPE_HEADER : k_VIEW_TYPE_FOOTER;
        self.backgroundColor = [UIColor clearColor];

        //  初始化加载指示器（菊花圈）
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake( (k_STATE_VIEW_INDICATE_WIDTH - 20) / 2 + k_STATE_VIEW_INDICATE_WIDTH / 2, (k_STATE_VIEW_HEIGHT - 20) / 2, 20, 20 )];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _indicatorView.hidesWhenStopped = YES;

        // ------ 当刷新时候 需要界面自己添加loading 如果 加载更多时候 不要界面loading footer 需要菊花圈
        if (kLoadMoreType) {
            if (self.viewType == k_VIEW_TYPE_FOOTER) {
                [self addSubview:_indicatorView];
            }
        }

        //  初始化箭头视图
        NSString    *imgName = type == k_VIEW_TYPE_HEADER ? s_Down_img : s_Up_img;
        UIImage     *tImage = [UIImage imageNamed:imgName];
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(170 / 2, (k_STATE_VIEW_HEIGHT - 25) / 2, 18, 25)];
        _arrowView.image = tImage;
        _arrowView.frame = CGRectMake(f_img_left, (k_STATE_VIEW_HEIGHT - tImage.height) / 2.f, tImage.width, tImage.height);
        [self addSubview:_arrowView];

        //  初始化状态提示文本
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
        _stateLabel.font = [UIFont FontOfSize:14.5f];
        _stateLabel.textColor = k_RGBCOLOR(153, 153, 153);
        _stateLabel.backgroundColor = [UIColor clearColor];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.text = type == k_VIEW_TYPE_HEADER ? @"下拉可以刷新" : @"上拖加载更多";
        [self addSubview:_stateLabel];

        if (!type == k_VIEW_TYPE_HEADER) {
            _stateLabel.frame = CGRectMake(0, 0, width, 40);
        }

        //  初始化更新时间提示文本
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, width, k_STATE_VIEW_HEIGHT - 20)];
        _timeLabel.font = [UIFont FontOfSize:11.0f];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = k_RGBCOLOR(153, 153, 153);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"";
        [self addSubview:_timeLabel];
    }

    return self;
}

- (void)changeState:(int)state
{
    if (kLoadMoreType) {
        if (self.viewType == k_VIEW_TYPE_FOOTER) {
            _stateLabel.hidden = state != k_PULL_STATE_LOAD;
            _timeLabel.hidden = YES;
        }
    }

    [_indicatorView stopAnimating];
    _arrowView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    switch (state) {
    case k_PULL_STATE_NORMAL:
        _currentState = k_PULL_STATE_NORMAL;
        _stateLabel.text = self.viewType == k_VIEW_TYPE_HEADER ? @"下拉可以刷新" : @"上拖加载更多";
        //  旋转箭头
        _arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        break;

    case k_PULL_STATE_DOWN:
        _currentState = k_PULL_STATE_DOWN;
        _stateLabel.text = @"释放刷新数据";
        _arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        break;

    case k_PULL_STATE_UP:
        _currentState = k_PULL_STATE_UP;
        _stateLabel.text = @"释放加载数据";
        _arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        break;

    case k_PULL_STATE_LOAD:
        _currentState = k_PULL_STATE_LOAD;
        _stateLabel.text = self.viewType == k_VIEW_TYPE_HEADER ? @"正在刷新.." : @"正在加载..";
        [_indicatorView startAnimating];
        _arrowView.hidden = YES;
        break;

    case k_PULL_STATE_END:
        _currentState = k_PULL_STATE_END;
        _stateLabel.text = _viewType == k_VIEW_TYPE_HEADER ? _stateLabel.text : @"已加载全部数据";
        _stateLabel.text = _viewType == k_VIEW_TYPE_HEADER ? _stateLabel.text : @"";
        _arrowView.hidden = YES;

        break;

    default:
        _currentState = k_PULL_STATE_NORMAL;
        _stateLabel.text = _viewType == k_VIEW_TYPE_HEADER ? @"下拉可以刷新" : @"上拖加载更多";
        _arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        break;
    }
    [UIView commitAnimations];
}

// k_STATE_SHOW_TIME 显示   k_STATE_HIDE_TIME 不显示
- (void)updateTimeLabel:(int)flag
{
    if (flag == k_STATE_HIDE_TIME) {
        _timeLabel.text = @"";
        return;
    }

    NSDate          *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"HH:mm"];
    _timeLabel.text = [NSString stringWithFormat:@"上次刷新时间 %@", [formatter stringFromDate:date]];
}

@end
#pragma mark - -------- PullToRefreshTableView  ----------

@interface PullToRefreshTableView ()

@property (nonatomic, strong) UIView *_nilFooter;

@end

/// PullToRefreshTableView 拖动刷新/加载 表格视图
@implementation PullToRefreshTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.opaque = NO;

        // 顶部状态栏
        StateView *tState = nil;
        tState = [[StateView alloc] initWithFrame:CGRectMake(0, -40, frame.size.width, frame.size.height) viewType:k_VIEW_TYPE_HEADER];
        [self addSubview:tState];
        self.headerView = tState;

        // 底部状态栏
        tState = [[StateView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) viewType:k_VIEW_TYPE_FOOTER];
        [self setTableFooterView:tState];
        self.footerView = tState;
        if (kLoadMoreType) {
            [self.footerView.arrowView removeFromSuperview];
        }

        self.tableFooterView.hidden = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

- (void)setIsfooterHide:(BOOL)isHide
{
    self.footerView.hidden = isHide;
    _isfooterHide = isHide;
    self.tableFooterView = (isHide ? nil : self.footerView);
}

- (void)setIsHeaderHide:(BOOL)isHide
{
    self.headerView.hidden = isHide;
    _isHeaderHide = isHide;
}

- (int)tableViewDidDragging
{
    CGFloat offsetY = self.contentOffset.y;

    //  判断是否正在加载
    if ( (_headerView.currentState == k_PULL_STATE_LOAD) ||
         (_footerView.currentState == k_PULL_STATE_LOAD) ) {
        return k_RETURN_DO_NOTHING;
    }

    //  --------------改变“下拉可以刷新”视图的文字提示
    if (!_isHeaderHide) {
        if (offsetY < -k_STATE_VIEW_HEIGHT - 10) {
            [_headerView changeState:k_PULL_STATE_DOWN];
        }
        else {
            [_headerView changeState:k_PULL_STATE_NORMAL];
        }
    }

    //  --------------判断数据是否已全部加载
    if (_footerView.currentState == k_PULL_STATE_END) {
        return k_RETURN_DO_NOTHING;
    }


    //  --------------改变“上拖加载更多”视图的文字提示
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;

    if (!_isfooterHide) {
        self.tableFooterView.hidden = NO;

        if (offsetY > differenceY + k_STATE_VIEW_HEIGHT / 3 * 2) {
            if (kLoadMoreType) {
                if (_footerView.currentState != k_PULL_STATE_END && _footerView.currentState != k_PULL_STATE_LOAD) {
                    [_footerView changeState:k_PULL_STATE_LOAD];
                    return k_RETURN_LOADMORE;
                }
            }
            else {
                [_footerView changeState:k_PULL_STATE_UP];
            }
        }
        else {
            [_footerView changeState:k_PULL_STATE_NORMAL];
        }
    }
    return k_RETURN_DO_NOTHING;
}

- (int)tableViewDidEndDragging
{
    CGFloat offsetY = self.contentOffset.y;

    //  判断是否正在加载数据
    if ( (_headerView.currentState == k_PULL_STATE_LOAD) ||
         (_footerView.currentState == k_PULL_STATE_LOAD) ) {
        return k_RETURN_DO_NOTHING;
    }

    //  改变“下拉可以刷新”视图的文字及箭头提示
    if (!self.isHeaderHide) {
        if (offsetY < -k_STATE_VIEW_HEIGHT - 10) {
            [_headerView changeState:k_PULL_STATE_LOAD];
            self.contentInset = UIEdgeInsetsMake(k_STATE_VIEW_HEIGHT, 0, 0, 0);
            return k_RETURN_REFRESH;
        }
    }

    //  改变“上拉加载更多”视图的文字及箭头提示
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;

    if (!self.isfooterHide) {
        if ( (_footerView.currentState != k_PULL_STATE_END) &&
             (offsetY > differenceY + k_STATE_VIEW_HEIGHT / 3 * 2) ) {
            [_footerView changeState:k_PULL_STATE_LOAD];
            return k_RETURN_LOADMORE;
        }
    }

    return k_RETURN_DO_NOTHING;
}

- (void)reloadData:(BOOL)dataIsAllLoaded
{
    [self reloadData];
    self.contentInset = UIEdgeInsetsZero;

    //  如果显示下拉刷新
    if (!self.isHeaderHide) {
        [self.headerView updateTimeLabel:k_STATE_SHOW_TIME];
        [self.headerView changeState:k_PULL_STATE_NORMAL];
    }

    if (!self._nilFooter) {
        self._nilFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 2)];
    }

    // 如果显示加载更多
    if (!self.isfooterHide) {
        self.footerView.hidden = NO;
        [self.footerView updateTimeLabel:k_STATE_HIDE_TIME];

        //  如果数据已全部加载，则禁用“上拖加载”
        if (dataIsAllLoaded) {
            [self.footerView changeState:k_PULL_STATE_END];
            [self.footerView updateTimeLabel:k_STATE_HIDE_TIME];
        }
        else {
            [self.footerView changeState:k_PULL_STATE_NORMAL];
        }

        self.footerView.hidden = dataIsAllLoaded;
        [self setTableFooterView:(dataIsAllLoaded ? self._nilFooter : self.footerView)];
    }
    else {
        [self setTableFooterView:self._nilFooter];
    }
}

+ (void)registerLoadMoreType:(int)type;
{
    kLoadMoreType = type;
}

@end