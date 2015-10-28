

//
//  FeedbackViewController.m
//  QYNews
//
//  Created by qiaoyan on 15/10/10.
//  Copyright (c) 2015年 qiaoyan. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
@property (nonatomic) UIImageView *imageView;
@end

@implementation FeedbackViewController
- (id)init {
    if (self = [super init]) {
        self.title = @"意见反馈";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTopContent];
    [self createLineView];
    [self createBottomVontent];
}
- (void)createTopContent {
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - 150)/2, 84, 150, 150)];
    self.imageView.image = [UIImage imageNamed:@"Icon-60@2x.png"];
    self.imageView.layer.cornerRadius  = 10;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.imageView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageView.topX, self.imageView.bottomY + 5, 150, 30)];
    titleLabel.text = @"QY 新闻";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *eTitlLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageView.topX, self.imageView.bottomY + 35, 150, 25)];
    eTitlLabel.textAlignment = NSTextAlignmentCenter;
    eTitlLabel.font = [UIFont systemFontOfSize:15];
    eTitlLabel.textColor = [UIColor colorWithHue:0.3 saturation:0.3 brightness:0.3 alpha:1.0];
    eTitlLabel.text = @"QY NEWS";
    [self.view addSubview:eTitlLabel];
}
- (void)createLineView {
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, self.imageView.bottomY + 80, ScreenWidth - 40, 1.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
    [self.view addSubview:lineView];
}
- (void)createBottomVontent {
    UILabel *hLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, ScreenHeight - 230, ScreenWidth - 50*2, 30)];
    ;
    hLabel.text = @"欢迎反馈^-^";
    [self.view addSubview:hLabel];
    
    UILabel *qqLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, ScreenHeight - 180, ScreenWidth - 50*2, 30)];
    ;
    qqLabel.text = @"反馈 Q Q: 1043607274";
    [self.view addSubview:qqLabel];
    
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, ScreenHeight - 140, ScreenWidth - 50*2, 30)];
    emailLabel.text = @"反馈 邮箱: 1043607274@qq.com";
    [self.view addSubview:emailLabel];
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
