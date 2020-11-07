//
//  TTableView.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//
static NSInteger kPageNo;

#import "PullToRefreshTableView.h"
#import "TBaseTableCell.h"

@protocol TTableDelegate, TTableNoRecordProtocol;

/********
*    列表控件
*    CGRect frame = CGRectMake(0, f_Page_y, f_Device_w, f_Page_h);
*    TTableView* tTable = [TTableView tableWithFrame:frame dataSource:self isRefresh:NO];
*    [self addSubview:tTable];
*    tTable.singleSection = NO;
*    tTable.noRecordText = @"暂无列表记录";
*    self._tableView = tTable;
*    [self._tableView refreshTable];
********/
@interface TTableView : UIView

/// 委托对象
@property (nonatomic, weak)     id <TTableDelegate> delegate;

/// 是否为单个分区 默认:YES
@property (nonatomic)   BOOL singleSection;
/// 加载失败是否清除缓存数据 默认:YES
@property (nonatomic)   BOOL cleanCacheAtFaild;
/// 隐藏HeaderView
@property (nonatomic)   BOOL hideHeader;
/// 隐藏FooterView
@property (nonatomic)   BOOL hideFooter;
/// 复用cell 默认:YES
@property (nonatomic)   BOOL cellReUse;
/// 当前分业数(默认1开始)
@property (nonatomic)   NSInteger _currPage;
/// 数据源(数组)
@property (nonatomic, strong)   NSMutableArray *_dataList;


/// 无数据时,列表中间提示文字 (默认:暂无记录)
@property (nonatomic, strong)   NSString *noRecordText;
/// 无记录页面 如果为空 默认实现为1个label 局中显示
@property (nonatomic, strong)   UIView <TTableNoRecordProtocol> *_noRecordView;

/// 列表(支持下拉刷新,上托加载)
@property (nonatomic, strong)   PullToRefreshTableView *_tableView;

/// 初始化 dataSource:委托
+ (id)tableWithFrame:(CGRect)frame dataSource:(id <TTableDelegate>)dataSource;
/// 初始化 dataSource:委托 isRefresh:是否支持 上托下拉操作
+ (id)tableWithFrame:(CGRect)frame dataSource:(id <TTableDelegate>)dataSource isRefresh:(BOOL)isRefresh;

- (TBaseTableCell *)cellWithIdentifier:(NSString *)tIdentifier indexPath:(NSIndexPath *)indexPath;


/// 传入数据源 刷新列表(传入空 显示无记录)   params:数组
- (void)doReloadListData:(NSArray *)params;
/// 刷入数据源加载更多列表  params:数组
- (void)doAddListData:(NSArray *)params;

/// 列表刷新失败
- (void)tableReloadFaild;
/// 列表加载更多失败
- (void)tableGetMoreFaild;


/// 刷新列表, 首次添加到视图,需要手动调用
- (void)refreshTable;
/// 添加subView 到table
- (void)addToTable:(UIView *)subView;
// 设置 tableHeaderView
- (void)setHeaderView:(UIView *)view;

/// 设置并绑定 cell 中btn 的事件
- (void)addCellBtn:(NSIndexPath *)indexPath tag:(NSInteger)tag btn:(UIButton *)btn;
/// btn 所在的cell 位置
- (NSIndexPath *)indexPathForCellBtn:(UIButton *)btn;

/// 优化 tableView 在 pageEnable YES状态下动画问题
@property (assign, nonatomic) BOOL _currPageEnable;


/// 设置列表每页数据条数
+ (void)registerPageNo:(int)pageno;

@end

#pragma mark - -------- TTableDelegate ----------

///  列表数据源委托
@protocol TTableDelegate <NSObject>
@required
/// 获取 cell 高度
- (float)getCellHeight:(NSIndexPath *)indexPath;

/// 刷新或加载首页数据
- (void)getTableData:(TTableView *)table isRefresh:(BOOL)isRefresh;

/// 获取 cell 实例 (  can User [table cellWithIdentifier:tIdentifier indexPath:indexPath])
- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath;


@optional

/// 点击 cell
- (void)cellSelected:(NSIndexPath *)indexPath;
/// 加载更多数据
- (void)getMoreTableData:(TTableView *)table;
/// tag = section*row*100+1,2,3,4,5
- (void)cellBtnClick:(UIButton *)button;


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - -------- TTableDelegate ----------

///  列表无数据提示 协议
@protocol TTableNoRecordProtocol <NSObject>
@required
/// 无记录提示语 => (默认:暂无记录)
@property (nonatomic, strong) NSString *_noRecordText;

@end

/// 默认的 无记录提示
@interface TNoRecordView : UIView <TTableNoRecordProtocol>

@property (nonatomic, strong) NSString  *_noRecordText;
@property (nonatomic, strong) UILabel   *_noRecordLabel;

@end

#define Get_Cell_Btn_Section(tag)   ( (tag) / 1000000 )
#define Get_Cell_Btn_Row(tag)       ( ( (tag) % 1000000 ) / 10 )
#define Get_Cell_Btn_Tag(tag)       ( (tag) % 10 )
#define Get_Cell_Btn_Path(tag)      [NSIndexPath indexPathForRow : Get_Cell_Btn_Row(tag) inSection : Get_Cell_Btn_Section(tag)]