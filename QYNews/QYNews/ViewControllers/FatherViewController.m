


//
//  FatherViewController.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/21.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//

#import "FatherViewController.h"
#import "WeatherViewController.h"

@interface FatherViewController ()

@end

@implementation FatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.width, self.navigationController.navigationBar.height+20)];
    self.alphaView.backgroundColor = [UIColor orangeColor];
    [self customNavigationBar];
}
#pragma mark -
#pragma mark customNavigationBar
- (void)customNavigationBar {
    [self customNavigationBarBackGround];
    [self customNavigationTitleBar];
    [self customNavigationLeftBar];
    [self customNavigationRightBar];
}
- (void)customNavigationBarBackGround {
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
}
- (void)customNavigationTitleBar {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:25];
    //titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
}
- (void)customNavigationLeftBar {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    
    [self setLeftButtonImage:leftButton];
    
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)customNavigationRightBar {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    
    [self setRightButtonImage:rightButton];
    
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//子类重写 image
- (void)setRightButtonImage:(UIButton *)rightButton {
    [rightButton setImage:[UIImage imageNamed:@"add2.png"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
}
- (void)setLeftButtonImage:(UIButton *)leftButton {
    [leftButton setImage:[UIImage imageNamed:@"return2.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
}
#pragma mark -
#pragma BarButtonClick
- (void)leftButtonClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonClick:(UIButton *)button {
    WeatherViewController *weatherVC = [[WeatherViewController alloc]init];
    [self.navigationController pushViewController:weatherVC animated:YES];
}
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
