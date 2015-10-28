//
//  TitleScrollView.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/24.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "TitleScrollView.h"
#import "ContentCollectionViewController.h"
#import "ChannelViewController.h"
#import "OrangeView.h"




@interface TitleScrollView ()

@property (nonatomic,copy) NSArray   *titleDataSource;
//重定制self时 用于删除上一次生成的view
@property (nonatomic) NSMutableArray *butArray;
//下标视图
@property (nonatomic) OrangeView     *orangeView;
//记忆选中的 按钮
@property (nonatomic) NSInteger index;
//判断是否为 再次定制self
@property (nonatomic) BOOL      isSecond;

@end

@implementation TitleScrollView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.index = 0;
        self.butArray = [NSMutableArray array];
        [self loadData];
        [self createOrangeView];
        [self customMyself];
        [self setOffsetWithContentScrollView];
        [self createNotificationC];
        [self refreshScrollViewContent];
    }
        return self;
}
- (NSString *)cacheFileDirectory {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    cacheDir = [cacheDir stringByAppendingPathComponent:@"QYCache"];
    NSString *filePath = [cacheDir stringByAppendingPathComponent:@"likeFile"];

    return filePath;
}
- (void)loadData {
    NSString *filePath = [self cacheFileDirectory];
    self.titleDataSource = [NSMutableArray arrayWithContentsOfFile:filePath];
}
- (void)createNotificationC {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setOffsetAction:) name:@"setOffset" object:nil];
}
// UI
- (void)createOrangeView {
    self.orangeView = [[OrangeView alloc]initWithFrame:CGRectMake(0, ScrollView_H -2, Button_W, 2)];
}
- (void)customMyself {
    self.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:0.95 alpha:1.0];
    self.bounces = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    [self addButton:self.titleDataSource view:self.orangeView];
}
- (void)addButton:(NSArray *)titles view:(UIView *)orangeView {
    [self.butArray removeAllObjects];
    for (int index = 0; index <self.titleDataSource.count; index ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame     = CGRectMake(Button_W*index, 0, Button_W, ScrollView_H);
        
        [button setTitle:[self.titleDataSource objectAtIndex:index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        button.tag = kBaseTag +index;
        [button addTarget:self action:@selector(scrollViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (index == 0) {
            button.selected = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            [button addSubview:orangeView];
        }
        
        if (index == self.titleDataSource.count -1) {
            self.contentOffset = CGPointMake(self.index * Button_W, 0);
            self.contentSize = CGSizeMake(Button_W *self.titleDataSource.count, 0);
        }
        [self addSubview:button];
    }
    
}

//频道管理页面 点击喜欢的标题 刷新
- (void)refreshScrollViewContent {
    [ChannelViewController sharedInstance].reBlock = ^ (NSString *title) {
        [self loadData];
        [self.titleDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:title]) {
                self.index = idx;
                *stop = YES;
            }
        }];
        //self.index = 0;
        NSArray *subViewArr = [self subviews];
        for (UIView *view in subViewArr) {
            [view removeFromSuperview];
        }
        [self addButton:self.titleDataSource view:self.orangeView];
    };
}
//新闻页面左右切换后 ，对应self 的 button
- (void)setOffsetWithContentScrollView {
    [ContentCollectionViewController sharedInstance].setOffsetBlock = ^(NSInteger index) {
        UIButton *button = (UIButton *)[self viewWithTag:kBaseTag +index];
        [self refreshButtonSelected];
        button.selected = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addSubview:_orangeView];
        self.index = index;
        if(index>=2 &&index <=self.titleDataSource.count -3) {
            [self setContentOffset:CGPointMake((index-2)*Button_W, 0) animated:YES];
        }
        else if(index<2){
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else if (index>self.titleDataSource.count -2) {
            [self setContentOffset:CGPointMake((index-4)*Button_W, 0) animated:YES];
        }
    };
}
#pragma mark -
#pragma mark ButtonClick
- (void)refreshButtonSelected {
    UIButton *lastButton = (UIButton *)[self viewWithTag:self.index +kBaseTag];
    lastButton.selected = NO;
    lastButton.titleLabel.font = [UIFont systemFontOfSize:16];
    NSArray *subViews = lastButton.subviews;
    for (id view in subViews) {
        UIView *orangeView = (UIView *)view;
        if (orangeView.tag == 233) {
            [view removeFromSuperview];
        }
    }
}
- (void)scrollViewButtonClick:(UIButton *)button {
    //选中状态
    [self refreshButtonSelected];
    button.selected = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    self.index = button.tag - kBaseTag;
    [button addSubview:_orangeView];
    //偏移
    [self offset:button];
    //事件
    [self eventClick:button];
}
- (void)offset:(UIButton *)button {
    NSInteger index = button.tag - kBaseTag;
    CGPoint offset  = self.contentOffset;
    NSInteger count = self.titleDataSource.count;
    if (offset.x>=Button_W || offset.x < (count - 5)* Button_W) {
        if (index <=1 ||index >= count-2) {
            if (index <= 1) {
                [self setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            else {
                [self setContentOffset:CGPointMake((count - 5)*Button_W, 0) animated:YES];
            }
        }
        if (index>=2 && index <=self.titleDataSource.count - 3) {
            [self setContentOffset:CGPointMake((index -2) *Button_W, 0) animated:YES];
        }
    }
}
//事件
- (void)setOffsetAction:(NSNotification *)notification {
    self.isSecond = YES;
    NSString *title = notification.userInfo[@"title"];
    [self.titleDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([title isEqualToString:obj]) {
            
            UIButton *button = (UIButton *)[self viewWithTag:kBaseTag +idx];
            [self refreshButtonSelected];
            
            button.selected = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            [button addSubview:_orangeView];
            self.index = idx;
            if(idx>=2 &&idx <=self.titleDataSource.count -3) {
                [self setContentOffset:CGPointMake((idx-2)*Button_W, 0) animated:YES];
            }
            else if(idx<2){
                [self setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            else if (idx>self.titleDataSource.count -2) {
                [self setContentOffset:CGPointMake((idx-4)*Button_W, 0) animated:YES];
            }
        }
    }];
}
- (void)eventClick:(UIButton *)button {
    [ContentCollectionViewController sharedInstance].collectionView.contentOffset = CGPointMake((button.tag-kBaseTag)*ScreenWidth, 0);
    NSLog(@"%ld",button.tag - kBaseTag);
    [[NSNotificationCenter defaultCenter]postNotificationName:JMPNOTIFICATION object:nil userInfo:@{@"title":button.currentTitle}];
    NSLog(@"%@",button.currentTitle);
}
@end
