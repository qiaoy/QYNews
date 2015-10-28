
//
//  SettingViewController.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/23.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//
#define swTag 999
#define sysDege (AppDelegate *)[[UIApplication sharedApplication] delegate]
#import "SettingViewController.h"
#import "Reachability.h"
#import "NFKCachManager.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"

@interface SettingViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic) NSArray     *dataSource;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UILabel     *sizeLabel;
//@property (nonatomic) UILabel     *noneLabel;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UIView  *backgroundView;
@property (nonatomic) UILabel *backgroundLabel;
@end

@implementation SettingViewController
- (id)init {
    if (self = [super init]) {
        self.title = @"设置";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createTableView];
    [self createBackGround];
}

- (void)loadData {
    self.dataSource = @[@[@"仅在Wifi下加载图片",@"隐藏刷新按钮"],@[@"清理缓存"],@[@"意见反馈",@"关于我们"]];
}
//UI
- (UILabel *)backgroundLabel {
    if (!_backgroundLabel) {
        _backgroundLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 200, 30)];
        _backgroundLabel.text = self.sizeLabel.text;
        _backgroundLabel.textAlignment = NSTextAlignmentCenter;
        _backgroundLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    }
    return _backgroundLabel;
}
- (UIView *)contentView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.bounds = CGRectMake(0, 0, 200, 100);
    view.center = self.view.center;
    view.layer.cornerRadius  = 10;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancleBut = [[UIButton alloc]initWithFrame:CGRectMake(20, 60, 60, 30)];
    [cancleBut setBackgroundImage:[UIImage imageNamed:@"buttonbar_edit.png"] forState:UIControlStateNormal];
    [cancleBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBut setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
    [cancleBut addTarget:self action:@selector(cancelButClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yesBUt    = [[UIButton alloc]initWithFrame:CGRectMake(120, 60, 60, 30)];
    [yesBUt setBackgroundImage:[UIImage imageNamed:@"buttonbar_edit.png"] forState:UIControlStateNormal];
    [yesBUt setTitle:@"删除" forState:UIControlStateNormal];
    [yesBUt setTitleColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] forState:UIControlStateNormal];
    [yesBUt addTarget:self action:@selector(yesButClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:self.backgroundLabel];
    [view addSubview:cancleBut];
    [view addSubview:yesBUt];
    return view;
}
- (void)createBackGround {

    self.backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0;
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:[self contentView]];
}
- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 70, 0, 50, 44)];
        _sizeLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        _sizeLabel.font = [UIFont systemFontOfSize:15];
    }
    _sizeLabel.text = [NSString stringWithFormat:@"%.1fM",[NFKCachManager cacheSize]/10/1024.0];
    
    return _sizeLabel;
}

- (UIImageView *)iconImageView {
   
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 50, 12, 20, 20)];
    _iconImageView.image = [UIImage imageNamed:@"right4.png"];
    
    return _iconImageView;
}
- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setCellId"];
    [self.view addSubview:self.tableView];
}
- (void)addSwitchToCell:(UITableViewCell *)cell index:(NSInteger)index{
 
    UISwitch *swBut = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenWidth - 80, 5, 60, 30)];
    if (index == 0) {
        NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:isWifi];
        [swBut setOn:[state boolValue]];
    }else {
        NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:isHide];
        [swBut setOn:[state boolValue]];
    }
    
    swBut.tag = swTag + index;
    [swBut addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:swBut];
}
#pragma mark 事件
- (void)switchAction:(UISwitch *)swBut {

    if (swBut.tag == swTag + 0) {
        if ([swBut isOn]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:isWifi];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:isWifi];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        if ([swBut isOn]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:isHide];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [[NSNotificationCenter defaultCenter]postNotificationName:REFRESHBUTSTATUS object:nil];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:isHide];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:REFRESHBUTSTATUS object:nil];
    }
}
- (void)cancelButClick:(UIButton *)button {
    self.backgroundView.alpha = 0;
}
- (void)yesButClick:(UIButton *)button {
    self.backgroundView.alpha = 0;
    [NFKCachManager clearDisk];
    self.sizeLabel.text = @"0.0M";
    self.backgroundLabel.text = self.sizeLabel.text;
}
#pragma mark - TableView协议 -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSource objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCellId" forIndexPath:indexPath];
    cell.textLabel.text = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1)) {
        [self addSwitchToCell:cell index:indexPath.row];
    }
    if (indexPath.section == 1) {
        [cell addSubview:self.sizeLabel];
    }
    if (indexPath.section == 2) {
        [cell addSubview:self.iconImageView];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 1;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        return view;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.backgroundView.alpha = 0.5;
        }];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            FeedbackViewController *feedBackVC = [[FeedbackViewController alloc]init];
            [self.navigationController pushViewController:feedBackVC animated:YES];
        }
        if (indexPath.row == 1) {
            AboutViewController *aboutVC = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }
}
#pragma mark -
#pragma 重写父类方法
- (void)customNavigationRightBar {}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
