//
//  CollectionViewController.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/23.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//

#import "CollectionViewController.h"
#import "NewTableViewCell.h"
#import "ScrollViewController.h"
#import "WebViewController.h"


@interface CollectionViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) UITableView    *tableView;
@property (nonatomic) NSMutableArray *newsArray;
@property (nonatomic) NSMutableArray *selIndexPathArr;
@end

@implementation CollectionViewController
- (id)init {
    if (self = [super init]) {
        self.title = @"收藏";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.selIndexPathArr = [NSMutableArray array];
    [self createTableView];
    [self loadDataSource];
}
- (void)createTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:@"NewTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cellId"];
    [self.view addSubview:self.tableView];
}
- (void)loadDataSource {
    self.newsArray = [NSMutableArray arrayWithArray:[[NFKDBManager sharedInstance]readNewInfoList:kCollectionType]];
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    NewModel *model = [self.newsArray objectAtIndex:indexPath.row];
    [cell updateWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewModel *model = [self.newsArray objectAtIndex:indexPath.row];
    if (!tableView.isEditing) {
        WebViewController *webVC = [[WebViewController alloc]init];
        ScrollViewController  *scrollVC  = [[ScrollViewController alloc]init];
        if ([model.id hasSuffix:@"cms"]) {
            webVC.id  = model.id;
            webVC.pic = model.pic;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        if ([model.id hasSuffix:@"hdpic"]) {
            scrollVC.id  = model.id;
            scrollVC.pic = model.pic;
            [self.navigationController pushViewController:scrollVC animated:YES];
        }
    }else {
        [self.selIndexPathArr addObject:indexPath];
    }
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        [self.selIndexPathArr removeObject:indexPath];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark -
#pragma 重写父类方法
- (void)setRightButtonImage:(UIButton *)rightButton {
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton imageRectForContentRect:CGRectMake(5, 5, 15, 15)];
}
- (void)rightButtonClick:(UIButton *)button {
    if (self.tableView.isEditing) {
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
        [self deleteAllSelectCell];
        
    }else {
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
        [self.selIndexPathArr removeAllObjects];
    }
}
- (void)deleteAllSelectCell {
    
    NSMutableArray *RArr = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.selIndexPathArr) {
        NewModel *model = [self.newsArray objectAtIndex:indexPath.row];
        [[NFKDBManager sharedInstance] deleteNewInfo:model type:kCollectionType];
        [RArr addObject:[self.newsArray objectAtIndex:indexPath.row]];
    }
    //删除数据源
    [self.newsArray removeObjectsInArray:RArr];
    //删除cell
    [self.tableView deleteRowsAtIndexPaths:self.selIndexPathArr withRowAnimation:UITableViewRowAnimationLeft];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
