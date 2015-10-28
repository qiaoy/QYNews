//
//  RootViewController.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/21.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//

#define titleScrollViewTag   66
#define contentScrollViewTag 88

#import "RootViewController.h"
#import "ContentCollectionViewController.h"
#import "RefreshButton.h"
#import "CreatFile.h"

@interface RootViewController () <UIGestureRecognizerDelegate>

@property (nonatomic) NSMutableArray *recommendList;
//UI
@property (nonatomic) ContentCollectionViewController *contentCC;
@property (nonatomic) TitleScrollView *titleScrollView;
@property (nonatomic) EditButton      *editButton;
@property (nonatomic) RefreshButton   *refreshBut;
@property (nonatomic) DrawerView      *drawerView;
@property (nonatomic) BackgroundView  *backgroundView;
@property (nonatomic) CreatFile *createFile;
@end

@implementation RootViewController
- (id)init {
    if (self = [super init]) {
        self.title = @"QY 新闻";
        self.createFile = [[CreatFile alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCustomUI];
    [self addNotification];
}
- (void)addNotification {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshButState) name:REFRESHBUTSTATUS object:nil];
}
- (void)refreshButState {
    NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:isHide];
    [self.refreshBut setHidden:[state boolValue]];
}
#pragma mark -
#pragma mark customUI
- (void)initCustomUI {
    [self createScrollView];
    [self createButton];
    [self addDrawerView];
    [self addSwipeGesture];
}
- (void)createScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    //titleScrollView 左右滚动标题
    self.titleScrollView = [[TitleScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth-EditBut_W, ScrollView_H)];
    [self.view addSubview:self.titleScrollView];
    // contentCC 左右滚动新闻
    self.contentCC = [ContentCollectionViewController sharedInstance];
    self.contentCC.collectionView.frame = CGRectMake(0, 64 +ScrollView_H, ScreenWidth, ScreenHeight - 64 - ScrollView_H);
    [self.view addSubview:self.contentCC.collectionView];
}
//titleScrollView最右边的编辑button
- (void)createButton {
    self.editButton = [[EditButton alloc]initWithFrame:CGRectMake(ScreenWidth - EditBut_W, 64, EditBut_W, ScrollView_H)];
    [self.view addSubview:self.editButton];
    
    self.refreshBut = [RefreshButton sharedInstance];
    [self refreshButState];
    [self.view addSubview:self.refreshBut];
}
//添加抽屉视图
- (void)addDrawerView {
    self.drawerView = [[DrawerView alloc]initWithFrame:CGRectMake(-ScreenWidth/3.0*2, 64, ScreenWidth/3.0*2, ScreenHeight -64)];
    self.backgroundView = [[BackgroundView alloc]initWithFrame:CGRectMake(-ScreenWidth, 64, ScreenWidth, ScreenHeight -64 -ScrollView_H) drawer:self.drawerView isDrawer:^(BOOL isDrawer) {
        self.isDrawer = isDrawer;
    }];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.drawerView];
}
#pragma mark  - 添加手势 -
- (void)addSwipeGesture {
    UIView *gestureVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + ScrollView_H, 100, ScreenHeight - 64)];
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    gestureVeiw.backgroundColor = [UIColor clearColor];
    [gestureVeiw addGestureRecognizer:swipeGesture];
    [self.view addSubview:gestureVeiw];
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture {
    [self drawerMoveRight];
}
- (void)drawerMoveRight {
    self.backgroundView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 0.5;
        _drawerView.frame    = CGRectMake(0, 64, ScreenWidth/3.0*2, ScreenHeight - 64);
    } completion:^(BOOL finished) {
        for (int index = 0; index < 4; index ++) {
            UIButton *button = (UIButton *)[_drawerView viewWithTag:DrawerButTag + index];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
                button.frame = CGRectMake(0, button.topY, button.width, button.height);
            } completion:nil];
        }
    }];
}
- (void)drawerMoveLeft {
    [UIView animateWithDuration:0.5 animations:^{
        self.drawerView.frame    = CGRectMake(-ScreenWidth/3.0*2, 64, ScreenWidth/3.0*2, ScreenHeight -64);
        self.backgroundView.alpha = 0.0;
    }];
    for (int index = 0; index < 4; index ++) {
        UIButton *button = (UIButton *)[_drawerView viewWithTag:DrawerButTag + index];
        [UIView animateWithDuration:0.5 animations:^{
            button.frame = CGRectMake(-button.width, button.topY, button.width, button.height);
        }];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark -
#pragma mark 重写Father方法

- (void)setLeftButtonImage:(UIButton *)leftButton {
   [leftButton setImage:[UIImage imageNamed:@"sort2.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 5);
}
- (void)setRightButtonImage:(UIButton *)rightButton {
    [rightButton setImage:[UIImage imageNamed:@"tianqi2.png"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -5);
}
- (void)leftButtonClick:(UIButton *)button {
    self.isDrawer = !self.isDrawer;
    if (self.isDrawer) {
        [self drawerMoveRight];
    }
    else {
        [self drawerMoveLeft];
    }
}
@end
