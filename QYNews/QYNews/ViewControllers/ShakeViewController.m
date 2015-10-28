
//
//  ShakeViewController.m
//  QYNews
//
//  Created by qiaoyan on 15/10/11.
//  Copyright (c) 2015年 qiaoyan. All rights reserved.
//

#import "ShakeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HeadOfContentScrollVeiw.h"
#import "TitleTableViewCell.h"
#import "NewTableViewCell.h"
#import "ScrollViewController.h"
#import "WebViewController.h"
#import "TimeChannel.h"

@interface ShakeViewController () <UIAlertViewDelegate>{
    UIImageView *_upImageView;   //上半部的view
    UIImageView *_downImageView;  //下半部的view
}
@property (nonatomic,copy)   NSArray *titleDataSource;
@property (nonatomic,strong) NSMutableArray *newsList;    //新闻列表数据

@property (nonatomic) NSInteger page;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *longTitleLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UIView  *backGroundView;
@property (nonatomic) UIAlertView *alertView;
@property (nonatomic) NewModel *model;
@end



@implementation ShakeViewController
- (id)init {
    if (self = [super init]) {
        self.title = @"摇一摇";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self customUI];
     self.alertView = [[UIAlertView alloc]initWithTitle:nil message:@"摇晃失败，请再来一次"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
}

- (NSString *)cacheFileDirectory {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    cacheDir = [cacheDir stringByAppendingPathComponent:@"QYCache"];
    NSString *filePath = [cacheDir stringByAppendingPathComponent:@"likeFile"];
    NSError *error;
    BOOL bret = [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:&error];
    if (!bret) {
        NSLog(@"%@",error);
        return nil;
    }
    return filePath;
}
- (void)loadData {
    self.page = 1;
    NSString *filePath = [self cacheFileDirectory];
    self.titleDataSource = [NSMutableArray arrayWithContentsOfFile:filePath];
}

- (void)customUI
{
    _upImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, (ScreenHeight - 64)/2)];
    _upImageView.image = [UIImage imageNamed:@"shake_up.png"];
    
    _downImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _upImageView.bottomY, ScreenWidth, (ScreenHeight - 64)/2)];
    _downImageView.image = [UIImage imageNamed:@"shake_down.png"];
    
    [self.view addSubview:_upImageView];
    [self.view addSubview:_downImageView];
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 110, ScreenHeight - 40, 110, 25)];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}
- (UILabel *)longTitleLabel {
    if (!_longTitleLabel) {
        _longTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, ScreenHeight - 45, ScreenWidth - 98, 40)];
        _longTitleLabel.numberOfLines = 0;
        _longTitleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _longTitleLabel;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, ScreenHeight - 70, ScreenWidth, 25)];
    }
    return _titleLabel;
}
- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 80, ScreenWidth, 80)];
        _backGroundView.backgroundColor = [UIColor blackColor];
        _backGroundView.alpha = 0.2;
        UITapGestureRecognizer *tapGesrure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleAction:)];
        [_backGroundView addGestureRecognizer:tapGesrure];
    }
    return _backGroundView;
}
- (void)handleAction:(UITapGestureRecognizer *)gesture {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"rippleEffect";
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    WebViewController     *webVC = [[WebViewController alloc]init];
    ScrollViewController  *scrollVC  = [[ScrollViewController alloc]init];
    
    if ([self.model.category isEqualToString:@"cms"]) {

        webVC.id  = self.model.id;
        webVC.pic = self.model.pic;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([self.model.category isEqualToString:@"hdpic"]) {
        scrollVC.id  = self.model.id;
        scrollVC.pic = self.model.pic;
        [self.navigationController pushViewController:scrollVC animated:YES];
    }
}
#pragma mark - 请求网络数据 -
#pragma mark - 请求网络数据 -

- (void)fetchDataFromServer {
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"数据加载中"];
    
    NSString *url = [self composeRequestUrl];
    [[NetDataEngine sharedInstance]requestNewListFrom:url success:^(id response) {
        [MMProgressHUD dismissWithSuccess:@"恭喜下载数据成功" ];
        [self parseDataWithRespondse:response];
       
    } failed:^(NSError *error) {
        //[MMProgressHUD dismissWithError:@"数据下载失败"];
        [MMProgressHUD dismiss];
        [self.alertView show];
        NSLog(@"%@",error);
    }];
}
- (void)parseDataWithRespondse:(id)Respondse {
    NSDictionary *dic = [NewModel parseDataWithRespondsData:Respondse];
    [self.newsList removeAllObjects];
    self.newsList    = dic[CONTENTKEY];
    
    if (self.newsList.count == 0) {
        [self.alertView show];
    }else {
        NSInteger num = self.newsList.count;
        self.model = [self.newsList objectAtIndex:arc4random()%num];
        [self.view addSubview:self.backGroundView];
        
        [self.view addSubview:self.titleLabel];
        self.titleLabel.text = self.model.title;
        [self.view addSubview:self.longTitleLabel];
        self.longTitleLabel.text = self.model.long_title;
        [self.view addSubview:self.timeLabel];
        self.timeLabel.text = [TimeChannel calculatePushTimeFrom:self.model.pubDate];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            _upImageView.alpha = 1.0;
            _downImageView.alpha = 1.0;
        }];
    }
}
//网址
- (NSString *)composeRequestUrl {
    NSInteger num = self.titleDataSource.count;
    NSString *title = [self.titleDataSource objectAtIndex:arc4random()%num];
    NSString *url  = [NSString stringWithFormat:kHomeUrl,self.page,DATASOURCE_DIC[title]];
    return url;
}
//晃动动画
- (void)doAnimation
{
    [UIView animateWithDuration:1 animations:^{
        _upImageView.transform = CGAffineTransformMakeTranslation(0, -100);
        _downImageView.transform = CGAffineTransformMakeTranslation(0, 100);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _upImageView.transform = CGAffineTransformIdentity;
            _downImageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}
- (void)shake {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);

}
- (BOOL)becomeFirstResponder
{
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self doAnimation];
    [self shake];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self fetchDataFromServer];
}

#pragma mark - 重写父类方法 -

- (void)customNavigationRightBar { }

@end
