//
//  ContentCollectionViewCell.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/26.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "ContentCollectionViewCell.h"
#import "NewTableViewCell.h"
#import "HeadOfContentScrollVeiw.h"
#import "TitleTableViewCell.h"
#import "ScrollViewController.h"
#import "JHRefresh.h"
#import "NFKCachManager.h"
#import "RefreshButton.h"
#import "ChannelViewController.h"
#import "WebViewController.h"

@interface ContentCollectionViewCell () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *newsList;    //新闻列表数据
@property (nonatomic,strong) NSMutableArray *headViewArr; //新闻列表头数据
@property (nonatomic,copy) NSString *butTitle; //标题栏button的title
@property (nonatomic) NSInteger page;  //网页加载的页数
@property (nonatomic) BOOL isRefresh;  //是否刷新
@property (nonatomic) BOOL isLoadMore; //是否加载更多

@end

static NSString *newCellId   = @"newCellId";
static NSString *titleCellId = @"titleCellId";

@implementation ContentCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self customTableView];
        [self createRefreshHeadView];
        [self createRefreshFootView];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self addNotificationCenter];
            [self createChannelBlock];
            [self createRefreshBlock];
        });
    }
    return self;
}
- (void)initData {
    self.page     = 1;
    self.butTitle = @"头条";
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.headViewArr removeAllObjects];
    self.ContenttableView.tableHeaderView = nil;
    [self.newsList removeAllObjects];
    [self.ContenttableView reloadData];
}

- (void)createChannelBlock {
    [ChannelViewController sharedInstance].jmpClock = ^ (NSString *title) {
        self.butTitle = title;
        [self fetchDataFromServer];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"setOffset" object:nil userInfo:@{@"title":self.butTitle}];
    };
}

- (void)createRefreshBlock {
    [RefreshButton sharedInstance].refreshButBlock = ^(void) {
        self.page = 1;
        self.isRefresh = YES;
        [UIView animateWithDuration:1 animations:^{
            [self.ContenttableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }];
        
        [self fetchDataFromServer];
    };
}
#pragma mark - 创建TableVeiw -
- (void)customTableView {
    self.ContenttableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight - 64 - ScrollView_H)];
    self.ContenttableView.dataSource = self;
    self.ContenttableView.delegate   = self;
    self.ContenttableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registTableCell];
    [self addSubview:self.ContenttableView];
}
- (void)customHeadViewOfTableView {
    UIView *headBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/172*87)];
    headBackgroundView.tag = 100;
    headBackgroundView.backgroundColor = [UIColor whiteColor];
    
    HeadOfContentScrollVeiw *headView = [[HeadOfContentScrollVeiw alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/172*87)];
    if (headView.contentViewBlock) {
        headView.contentViewBlock(self.headViewArr);
    }
    
    UIView *backgroungView = [[UIView alloc]initWithFrame:CGRectMake(0, headView.bottomY -30, headView.width, 30)];
    backgroungView.backgroundColor = [UIColor blackColor];
    backgroungView.alpha = 0.2;
    
    [headBackgroundView addSubview:headView];
    [headBackgroundView addSubview:backgroungView];
    
    self.ContenttableView.tableHeaderView = headBackgroundView;
}
- (void)registTableCell {
    //有图
    UINib *newNib = [UINib nibWithNibName:@"NewTableViewCell" bundle:nil];
    [self.ContenttableView registerNib:newNib forCellReuseIdentifier:newCellId];
    //无图
    UINib *TitleNib = [UINib nibWithNibName:@"TitleTableViewCell" bundle:nil];
    [self.ContenttableView registerNib:TitleNib forCellReuseIdentifier:titleCellId];
}
#pragma mark - 上拉下拉刷新 -
- (void)createRefreshHeadView { //下拉刷新
    __weak typeof(self) weakSelf = self;
    [self.ContenttableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        weakSelf.page = 1;
        weakSelf.isRefresh = YES;
        [weakSelf fetchDataFromServer];
    }];
}
- (void)createRefreshFootView { //上拉加载
    __weak typeof(self) weakSelf = self;
    [self.ContenttableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        weakSelf.page ++;
        weakSelf.isLoadMore = YES;
        [weakSelf fetchDataFromServer];
    }];
}
- (void)endRefreshing { //结束刷新
    if (self.isRefresh) {
        //[self.ContenttableView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.isRefresh = NO;
        [self.ContenttableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.ContenttableView footerEndRefreshing];
    }
}
#pragma mark - 更新tableView -
- (void)updateWith:(NSString *)title {
    self.butTitle = title;
    [self fetchNetData];
}
- (void)addNotificationCenter {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(titleButAction:) name:JMPNOTIFICATION object:nil];
}

- (void)titleButAction:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    self.butTitle = dic[@"title"];
    [self fetchNetData];
}
#pragma mark - 请求网络数据 -
- (void)fetchNetData {
    if (![self fetchDataFromLocal]) {
        [self fetchDataFromServer];
    }
}
//本地加载
- (BOOL)fetchDataFromLocal {
    if ([NFKCachManager isCacheDataInvalid:[self composeRequestUrl]]) {
        id respondData = [NFKCachManager readDataAtUrl:[self composeRequestUrl]];
        [self parseCacheData:respondData];
        [self.ContenttableView reloadData];
        return YES;
    }
    return NO;
}
- (void)parseCacheData:(id)respondData {
    self.newsList    = respondData[CONTENTKEY];
    self.headViewArr = respondData[HEADKEY];
    //判断是否有头
    if (self.headViewArr.count == 0) {
        self.ContenttableView.tableHeaderView = nil;
    }
    if (self.headViewArr.count>0) {
        [self customHeadViewOfTableView];
    }
}
//网络加载
- (void)fetchDataFromServer {
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    if (self.page ==1) {
        [MMProgressHUD showWithTitle:@"数据加载中"];
    }
    NSString *url = [self composeRequestUrl];
    [[NetDataEngine sharedInstance]requestNewListFrom:url success:^(id response) {
        if (self.page == 1) {
            [MMProgressHUD dismissWithSuccess:@"恭喜加载成功"];
        }
        [self parseDataWithRespondse:response];
        [self.ContenttableView reloadData];
        [self endRefreshing]; // 结束刷新
    } failed:^(NSError *error) {
        if (self.page == 1) {
            [MMProgressHUD dismissWithError:@"加载失败"];
        }
        [self endRefreshing]; // 结束刷新
        NSLog(@"%@",error);
    }];
}
- (void)parseDataWithRespondse:(id)Respondse {
    NSDictionary *dic = [NewModel parseDataWithRespondsData:Respondse];
    if (self.page == 1) {
        [self.headViewArr removeAllObjects];
        [self.newsList removeAllObjects];
        self.newsList    = dic[CONTENTKEY];
        self.headViewArr = dic[HEADKEY];
        
        [NFKCachManager saveData:dic atUrl:[self composeRequestUrl]];
    }else {
        [self.newsList addObjectsFromArray:dic[CONTENTKEY]];
    }
    //判断是否有头
    if (self.headViewArr.count == 0) {
        self.ContenttableView.tableHeaderView = nil;
    }
    if (self.headViewArr.count>0) {
        [self customHeadViewOfTableView];
    }
}
//网址
- (NSString *)composeRequestUrl {
    NSString *url  = [NSString stringWithFormat:kHomeUrl,self.page,DATASOURCE_DIC[self.butTitle]];
    return url;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewModel *model = [self.newsList objectAtIndex:indexPath.row];
    if (model.pic.length == 0) {
        TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellId forIndexPath:indexPath];
        [cell updateWithModel:model];
        return cell;
    }
    else {
        NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newCellId forIndexPath:indexPath];
        [cell updateWithModel:model]; 
        return cell;
    }
    return nil;
}
#pragma mark -
#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIResponder *responder  = self.nextResponder;
    while (responder != nil && ![responder isKindOfClass:[UIViewController class]]) {
        responder = responder.nextResponder;
    }
    UIViewController *viewController = (UIViewController *)responder;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"rippleEffect";
    transition.delegate = self;
    [viewController.navigationController.view.layer addAnimation:transition forKey:nil];
    
    WebViewController     *webVC = [[WebViewController alloc]init];
    ScrollViewController  *scrollVC  = [[ScrollViewController alloc]init];
    
    NewModel *model = [self.newsList objectAtIndexedSubscript:indexPath.row];
    if ([model.category isEqualToString:@"cms"]) {
        webVC.id  = model.id;
        webVC.pic = model.pic;
        [viewController.navigationController pushViewController:webVC animated:YES];
    }
    if ([model.category isEqualToString:@"hdpic"]) {
        scrollVC.id  = model.id;
        scrollVC.pic = model.pic;
        [viewController.navigationController pushViewController:scrollVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
