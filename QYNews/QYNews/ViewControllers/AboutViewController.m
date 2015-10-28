

//
//  AboutViewController.m
//  QYNews
//
//  Created by qiaoyan on 15/10/10.
//  Copyright (c) 2015年 qiaoyan. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (nonatomic) UIImageView *imageView;
@end

@implementation AboutViewController
- (id)init {
    if (self = [super init]) {
        self.title = @"关于我们";
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
    self.imageView.backgroundColor = [UIColor orangeColor];
    self.imageView.layer.cornerRadius  = 10;
    self.imageView.layer.masksToBounds = YES;
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
    hLabel.text = @"app简介:";
    [self.view addSubview:hLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, ScreenHeight - 200, ScreenWidth - 50*2, 30)];
    ;
    contentLabel.text = @"这是一款新闻类的APP，希望你能喜欢.";
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:contentLabel];
    
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, ScreenHeight - 150, ScreenWidth - 50*2, 30)];
    emailLabel.text = @"-------  版本号v1.0.0  --------";
    emailLabel.textAlignment = NSTextAlignmentCenter;
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
