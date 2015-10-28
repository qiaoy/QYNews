

//
//  ScrollViewController.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/10/5.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "ScrollViewController.h"
#import "NewScrollView.h"
#import "ScrollConModel.h"
#import "SCPicsModel.h"
#import "UIImageView+WebCache.h"

@interface ScrollViewController () <UIScrollViewDelegate,UMSocialUIDelegate>
@property (nonatomic) NewScrollView  *newsScrollView;
@property (nonatomic) ScrollConModel *model;
@property (nonatomic) UILabel    *pageLabel;
@property (nonatomic) UITextView *textView;
@property (nonatomic) UIButton *colButton;
@property (nonatomic) BOOL     isLike;
@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    [self fetNetData];
}

#pragma mark - customUI -
- (void)createScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.newsScrollView = [[NewScrollView alloc]initWithFrame:self.view.bounds];
    self.newsScrollView.delegate = self;
    [self.view addSubview:self.newsScrollView];
}
- (void)addUIToScrollVeiw {
    NSDictionary *picDic = [self.model.pics_module firstObject];
    NSArray *pics = picDic[@"data"];
    for (int index = 0; index < pics.count; index ++) {
        NSDictionary *dic = [pics objectAtIndex:index];
        SCPicsModel *model = [[SCPicsModel alloc]initWithDictionary:dic error:nil];
        [self createImageView:model index:index];
    }
    self.newsScrollView.contentSize = CGSizeMake(pics.count*ScreenWidth, 0);
}
- (void)createImageView:(SCPicsModel *)picModel index:(int)index{
    static CGFloat height;
    if (picModel.width) {
        height = 600 * ScreenWidth/800;
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index*ScreenWidth, ScreenHeight/2 - height/2 , ScreenWidth, height)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:picModel.kpic]];
    [self.newsScrollView addSubview:imageView];
    if (index == 0) {
        [self createLable:imageView];
    }
    [self createTextVeiw:picModel imageView:imageView];
}
- (void)createTextVeiw:(SCPicsModel *)picModel imageView:(UIImageView *)imageView{
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(imageView.topX + 20, imageView.bottomY + 50, ScreenWidth - 20*2, 200)];
    
    self.textView.text = picModel.alt;
    self.textView.scrollEnabled = YES;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor whiteColor];
    [self.newsScrollView addSubview:self.textView];
}
- (void)createLable:(UIImageView *)imageVeiw {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, imageVeiw.bottomY + 20, ScreenWidth, 30)];
    titleLabel.text = self.model.title;
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    self.pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 60, titleLabel.topY, 60, 30)];
    self.pageLabel.textColor = [UIColor whiteColor];
    NSDictionary *picDic = [self.model.pics_module firstObject];
    NSArray *pics = picDic[@"data"];
    self.pageLabel.text = [NSString stringWithFormat:@"1/%ld",pics.count];
    [self.view addSubview:self.pageLabel];
}
#pragma mark -
#pragma mark 请求数据
- (void)loadMyModel {
    self.model.pic = self.pic;
    [self checkContentModelExistInDB];
}
- (void)fetNetData {
    NSString *url = [self composeRequestUrl];
    [[NetDataEngine sharedInstance]requestNewContentFrom:url success:^(id response) {
        self.model = [ScrollConModel parseDataWithRespondsData:response];
        [self loadMyModel];
        [self checkContentModelExistInDB];
        [self addUIToScrollVeiw];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (NSString *)composeRequestUrl {
    NSString *url  = [NSString stringWithFormat:kContentUrl,self.id];
    NSLog(@"%@",url);
    return url;
}
#pragma mark - ScrollView 协议 -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSDictionary *picDic = [self.model.pics_module firstObject];
    NSArray *pics = picDic[@"data"];
    NSInteger page = self.newsScrollView.contentOffset.x/ScreenWidth;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",page+1,pics.count];
}
#pragma mark - 重写父类方法 -
- (void)customNavigationRightBar {
    NSMutableArray *butItemArr = [NSMutableArray array];
    NSArray *imageNames = @[@"share2.png",@"like2.png"];
    for (int index = 0; index<2; index ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button setImage:[UIImage imageNamed:[imageNames objectAtIndex:index]] forState:UIControlStateNormal];
        button.tag = 66 + index;
        [button addTarget:self action:@selector(contentButClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *butItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        [butItemArr addObject:butItem];
        if (index == 1) {
            self.colButton = button;
        }
    }
    self.navigationItem.rightBarButtonItems = butItemArr;
}
- (void)contentButClick:(UIButton *)button {
    if (button.tag == 66) {
        [self sharedMylike];
    }
    if (button.tag == 67) {
        if (self.isLike) {
            [self cancleMyLike];
        }else {
            [self collectionMyLike];
        }
    }
}
- (void)sharedMylike {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5615c97067e58ea8e2003382"
                                      shareText:@"请输入你要分享的文字"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToFacebook,UMShareToTwitter,nil]
                                       delegate:self];
}
- (void)collectionMyLike {
    if (self.model.long_title.length == 0 ||self.model.long_title.length == 0 || self.model.pub_date.length == 0) {
        return;
    }
    if (self.model.long_title.length >0) {
        [[NFKDBManager sharedInstance]addNewInfo:self.model type:kCollectionType];
        [self.colButton setImage:[UIImage imageNamed:@"likefill2.png"] forState:UIControlStateNormal];
        self.isLike = YES;
    }
}
- (void)cancleMyLike {
    if (self.model.long_title.length == 0 ||self.model.long_title.length == 0 || self.model.pub_date.length == 0) {
        return;
    }
    if (self.model.long_title.length >0) {
        [[NFKDBManager sharedInstance]deleteNewInfo:self.model type:kCollectionType];
        [self.colButton setImage:[UIImage imageNamed:@"like2.png"] forState:UIControlStateNormal];
        self.isLike = NO;
    }
}
- (void)checkContentModelExistInDB {
    BOOL isExist = [[NFKDBManager sharedInstance]isNewInfoExist:self.model type:kCollectionType];
    if (isExist) {
        self.isLike = YES;
        [self.colButton setImage:[UIImage imageNamed:@"likefill2.png"] forState:UIControlStateNormal];
    }else {
        self.isLike = NO;
    }
}

@end
