//
//  TTableView.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#define T_Table_Tag 300

#import "TTableView.h"
#import "TExt.h"

@class TNoRecordView;
@interface TTableView () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>


@end
@implementation TTableView

+ (id)tableWithFrame:(CGRect)frame dataSource:(id <TTableDelegate>)dataSource
{
    TTableView *tTable = [[TTableView alloc] initWithFrame:frame isRefresh:YES];

    tTable.delegate = dataSource;
    return tTable;
}

+ (id)tableWithFrame:(CGRect)frame dataSource:(id <TTableDelegate>)dataSource isRefresh:(BOOL)isRefresh
{
    TTableView *tTable = [[TTableView alloc] initWithFrame:frame isRefresh:isRefresh];

    tTable.delegate = dataSource;
    return tTable;
}

- (id)initWithFrame:(CGRect)frame isRefresh:(BOOL)isRefresh
{
    self = [super initWithFrame:frame];

    if (self) {
        if (kPageNo < 1) {
            kPageNo = 10;
        }

        self._currPage = -1;
        self.noRecordText = @"暂无记录";
        self.singleSection = YES;
        self.cellReUse = YES;
        self.cleanCacheAtFaild = YES;
        self._dataList = [NSMutableArray arrayWithCapacity:0];

        CGRect tabFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);

        if (isRefresh) {
            self._tableView = [[PullToRefreshTableView alloc] initWithFrame:tabFrame style:UITableViewStylePlain];
        }
        else {
            self._tableView = [[PullToRefreshTableView alloc] initWithFrame:tabFrame style:UITableViewStylePlain];
            self.hideHeader = YES;
            self.hideFooter = YES;
        }

        self._tableView.tag = T_Table_Tag;
        self._tableView.separatorColor = [UIColor clearColor];
        self._tableView.backgroundColor = [UIColor clearColor];
        self._tableView.delegate = self;
        self._tableView.dataSource = self;
        [self addSubview:self._tableView];

        self._noRecordView = [[TNoRecordView alloc] initWithFrame:CGRectMake(0, 0, f_Device_w, 40)];
        self._noRecordView.center = CGPointMake(self.width / 2, self.height / 2 - 10);
        [self._tableView addSubview:self._noRecordView];
        self._noRecordView.hidden = YES;
    }

    return self;
}

#pragma mark - -------- cell btn ----------

/// 极限考虑:列表支持上千万条数据(1000*1000*10)  btn.tag ==> section*1000,000 + row*10 + tag*1(section:万(极限) ,row十万(极限)
#define section_start_tag   1000 * 1000
#define row_start_tag       10
/// 设置并绑定 cell 中btn 的事件
- (void)addCellBtn:(NSIndexPath *)indexPath tag:(NSInteger)tag btn:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellBtnClick:)]) {
        btn.tag = section_start_tag * indexPath.section + row_start_tag * indexPath.row + tag;
        [btn addTarget:self.delegate action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/// btn 所在的cell 位置
- (NSIndexPath *)indexPathForCellBtn:(UIButton *)btn
{
    NSInteger tag = btn.tag;
    NSInteger section = tag / section_start_tag;
    NSInteger row = (tag % section_start_tag) / row_start_tag;

    return [NSIndexPath indexPathForRow:row inSection:section];
}

#pragma mark - -------- 刷新数据 加载更多数据  重载表格 ----------

/// 调用来加载更多
- (void)doAddListData:(NSArray *)params
{
    if ( params && [params isKindOfClass:[NSArray class]] && (params.count > 0) ) {
        [self._dataList addObjectsFromArray:params];
    }

    BOOL isLoadAll = self._dataList.count < kPageNo * self._currPage;
    self._tableView.pagingEnabled = self._currPageEnable;

    if (!params) {
        isLoadAll = YES;
    }
    [self._tableView reloadData:isLoadAll];
}

/// 调用来刷新列表
- (void)doReloadListData:(NSArray *)params
{
    [self._dataList removeAllObjects];

    if (params) {
        [self._dataList addObjectsFromArray:params];
    }

    self._tableView.pagingEnabled = NO;

    BOOL isLoadAll = self._dataList.count < kPageNo * self._currPage;
    [self._tableView reloadData:isLoadAll];

    [self showNoRecordView:self._dataList.count == 0];
}

/// 列表刷新失败
- (void)tableReloadFaild
{
    if (self.cleanCacheAtFaild) {
        [self._dataList removeAllObjects];
        self._currPage = 1;
    }

    BOOL isLoadAll = self._dataList.count < kPageNo * self._currPage;
    [self._tableView reloadData:isLoadAll];
}

/// 列表加载更多失败
- (void)tableGetMoreFaild
{
    BOOL isLoadAll = self._dataList.count < kPageNo * self._currPage;
    [self._tableView reloadData:isLoadAll];
}

- (void)refreshTable
{
    if (self._dataList.count == 0) {
        if ([self.delegate respondsToSelector:@selector(getTableData:isRefresh:)]) {
            [self.delegate getTableData:self isRefresh:NO];
            [self._tableView reloadData];
        }
    }
    else {
        [self._tableView reloadData];
    }
}

#pragma mark - -------- 显示与隐藏 下拉和上托 ----------

- (void)setHideHeader:(BOOL)hideHeader
{
    [self._tableView setIsHeaderHide:hideHeader];
}

- (void)setHideFooter:(BOOL)hideFooter
{
    [self._tableView setIsfooterHide:hideFooter];
}

#pragma mark - -------- 没有记录表格 ----------

- (void)showNoRecordView:(BOOL)show
{
    if ( !show || k_Is_Empty(self.noRecordText) ) {
        [self._noRecordView setHidden:YES];
        return;
    }

    if (![self._noRecordView superview]) {
        self._noRecordView.center = CGPointMake(self.width / 2, self.height / 2 - 10);
        [self._tableView addSubview:self._noRecordView];
    }

    self._noRecordView._noRecordText = self.noRecordText;
    [self._noRecordView setHidden:NO];
}

#pragma mark --------------- UITableView Delegate ---------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.singleSection) {
        return self._dataList.count;
    }

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.singleSection) {
        return [[self._dataList objectAtIndexEx:section] count];
    }

    return self._dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(getCellHeight:)]) {
        return [self.delegate getCellHeight:indexPath];
    }

    return 45;
}

- (TBaseTableCell *)cellWithIdentifier:(NSString *)tIdentifier indexPath:(NSIndexPath *)indexPath
{
    if ( k_Is_Empty(tIdentifier) ) {
        DAssert(@"TTableView Cell exp", @"Can't create cell");
    }

    // 自动添加(:)
    if (![tIdentifier hasSuffix:@":"]) {
        tIdentifier = [tIdentifier appendStr:@":"];
    }

    TBaseTableCell   *tCell = nil;
    id item = nil;

    if (self.cellReUse) {
        tCell = [self._tableView dequeueReusableCellWithIdentifier:tIdentifier];
    }

    if (!tCell) {
        tCell = [TBaseTableCell cellWithStyle:UITableViewCellStyleDefault reuseIdentifier:tIdentifier];
    }

    if (self.singleSection) {
        item = [self._dataList objectAtIndexEx:indexPath.row];
    }
    else {
        item = [[self._dataList objectAtIndexEx:indexPath.section] objectAtIndexEx:indexPath.row];
        tCell.cellLocalModel = ( indexPath.row == 0 ? CellLocalTop : (indexPath.row == [[self._dataList objectAtIndexEx:indexPath.section] count] - 1 ? CellLocalBottom : CellLocalMiddle) );
    }

    tCell.indexPath = indexPath;
    [tCell layoutCellWithTypeSEL:tIdentifier item:item];

    return tCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cellAtIndexPath:)]) {
        return [self.delegate cellAtIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __block TTableView *bSelf = self;

    if ([self.delegate respondsToSelector:@selector(cellSelected:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [bSelf.delegate cellSelected:indexPath];
        }
                       );
    }
}

#pragma mark - -------- 多个分区 ----------

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return [self.delegate tableView:tableView titleForHeaderInSection:section];
    }

    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        return [self.delegate tableView:tableView titleForFooterInSection:section];
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.delegate tableView:tableView heightForHeaderInSection:section];
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [self.delegate tableView:tableView heightForFooterInSection:section];
    }

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.delegate tableView:tableView viewForHeaderInSection:section];
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.delegate tableView:tableView viewForFooterInSection:section];
    }

    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
{
    if ([self.delegate respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        return [self.delegate sectionIndexTitlesForTableView:tableView];
    }

    return nil;
}
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))
//{
//    if ([self.delegate respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
//        return [self.delegate sectionIndexTitlesForTableView:tableView];
//    }
//    return 0;
//}

#pragma mark - -------- table edit ----------

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}
#pragma mark - -------- 下拉和上托 拖动控制 ----------

- (void)updateThread:(NSNumber *)returnKey
{
    NSInteger key = [returnKey integerValue];

    if (key == k_RETURN_REFRESH) {
        self._tableView.pagingEnabled = NO;
        [self showNoRecordView:NO];

        if ([self.delegate respondsToSelector:@selector(getTableData:isRefresh:)]) {
            [self.delegate getTableData:self isRefresh:YES];
        }
    }
    else if (key == k_RETURN_LOADMORE) {
        if ([self.delegate respondsToSelector:@selector(getMoreTableData:)]) {
            [self.delegate getMoreTableData:self];
        }
    }
    else { }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == T_Table_Tag) {
        NSInteger returnKey = [self._tableView tableViewDidDragging];
        if (returnKey != k_RETURN_DO_NOTHING) {
            [self performSelectorOnMainThread:@selector(updateThread:) withObject:[NSNumber numberWithInteger:returnKey] waitUntilDone:NO];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.tag == T_Table_Tag) {
        NSInteger returnKey = [self._tableView tableViewDidEndDragging];
        [self performSelectorOnMainThread:@selector(updateThread:) withObject:[NSNumber numberWithInteger:returnKey] waitUntilDone:NO];
    }
}

#pragma mark - -------- SetFrame ----------

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self._tableView.frame = CGRectMake(0, 0, self.width, self.height);
}

+ (void)registerPageNo:(int)pageno
{
    if (pageno > 1) {
        kPageNo = pageno;
    }
}

#pragma mark - -------- other ----------

- (void)set_currPageEnable:(BOOL)currPageEnable
{
    __currPageEnable = currPageEnable;
    self._tableView.pagingEnabled = currPageEnable;
}

- (void)setHeaderView:(UIView *)view
{
    [self._tableView setTableHeaderView:view];
}

- (void)addToTable:(UIView *)subView
{
    [self._tableView addSubview:subView];
    [self._tableView bringSubviewToFront:subView];

    self._tableView.contentSize = CGSizeMake(self._tableView.width, subView.top + subView.height);
}


@end

@implementation TNoRecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        UIImage     *tImage = [UIImage getImage:@"TNoRecord_bg.png"];
        UIImageView *tImgView = [UIImageView newImgViewByImg:tImage];
        tImgView.center = CGPointMake(f_Device_w / 2, tImgView.height / 2);
        [self addSubview:tImgView];

        frame = CGRectMake(0, 0, tImgView.width, 20);
        UILabel *tLabel = [UILabel newLabel:frame];
        [tLabel dosetText:nil font:10 color:@"5d686f"];
        [tLabel setTextAlignment:NSTextAlignmentCenter];
        tLabel.center = CGPointMake(tImgView.width / 2, tImgView.height / 2);
        [tImgView addSubview:tLabel];
        self._noRecordLabel = tLabel;
    }

    return self;
}

- (void)set_noRecordText:(NSString *)noRecordText
{
    self._noRecordLabel.text = noRecordText;
}

@end