

//
//  WebViewController.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/10/5.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UMSocialUIDelegate,UIWebViewDelegate>
@property (nonatomic) UIWebView         *webView;
@property (nonatomic) ContentModel      *model;
@property (nonatomic,copy) NSDictionary *dataDic;
@property (nonatomic) UIButton          *colButton;
@property (nonatomic) NSString *webContent;
@property (nonatomic) BOOL isLike;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetNetData];
    [self checkContentModelExistInDB];
    
}
- (void)createWebView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    //拼接
    [self.webView loadHTMLString:self.webContent baseURL:nil];
    
    self.webView.backgroundColor = [UIColor darkGrayColor];
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;

    [self.view addSubview:self.webView];
}
- (void)loadMyModel {
    _model.pic = self.pic;
    [self checkContentModelExistInDB];
}

- (void)customContent {
    
    NSArray *pics = self.model.pics;

    NSString *contentStr = [NSString stringWithString:self.model.content];

    NSMutableString *mutableStrUTF = [NSMutableString stringWithString:contentStr];
    for (int index = 1; index <= pics.count; index++) {
        NSDictionary *dic = [pics objectAtIndexedSubscript:index-1][@"data"];
        NSString *str = [NSString stringWithFormat:@"<!--{IMG_%d}-->",index];
        NSString *str2 = [NSString stringWithFormat:@"<img src=%@  width='%f'><p>%@</p>",dic[@"kpic"],ScreenWidth - 20,dic[@"alt"]];
        [mutableStrUTF replaceOccurrencesOfString:str withString:str2 options:NSLiteralSearch range:NSMakeRange(0, mutableStrUTF.length)];
    }
    NSMutableString *headString = [NSMutableString stringWithFormat:@"<br><h2>%@</h2><p>%@</p> <br/>",self.model.title,self.model.long_title];
    [headString appendString:mutableStrUTF];
    self.webContent = headString;
    [self checkContentModelExistInDB];
    [self createWebView];
}

#pragma mark -
#pragma mark 请求数据
- (void)fetNetData {
    NSString *url = [self composeRequestUrl];
    [[NetDataEngine sharedInstance]requestNewContentFrom:url success:^(id response) {
        self.model = [ContentModel parseDataWithRespondsData:response];
        [self loadMyModel];
        [self customContent];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (NSString *)composeRequestUrl {
    NSString *url  = [NSString stringWithFormat:kContentUrl,self.id];
    NSLog(@"%@",url);
    return url;
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
    [[NFKDBManager sharedInstance]addNewInfo:self.model type:kCollectionType];
    [self.colButton setImage:[UIImage imageNamed:@"likefill2.png"] forState:UIControlStateNormal];
    self.isLike = YES;
}
- (void)cancleMyLike {
    if (self.model.long_title.length == 0 ||self.model.long_title.length == 0 || self.model.pub_date.length == 0) {
        return;
    }
    [[NFKDBManager sharedInstance]deleteNewInfo:self.model type:kCollectionType];
    [self.colButton setImage:[UIImage imageNamed:@"like2.png"] forState:UIControlStateNormal];
    self.isLike = NO;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
