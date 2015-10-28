//
//  HeadOfContentScrollVeiw.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/10/4.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "HeadOfContentScrollVeiw.h"
#import "UIImageView+WebCache.h"
#import "ScrollViewController.h"
#import "WebViewController.h"

@interface HeadOfContentScrollVeiw ()
@property (nonatomic,strong) NSMutableArray *contentUrlArr;
@property (nonatomic,strong) NSMutableArray *contentViewArr;

@property (nonatomic) UIImageView  *imageView;
@property (nonatomic) UILabel *countLabel;
@property (nonatomic) UILabel *titleLabel;
@end
@implementation HeadOfContentScrollVeiw

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentUrlArr = [NSMutableArray array];
        [self customMyself];
        [self customContentView];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
        });
    }
    return self;
}
- (void)customMyself {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    self.bounces = NO;
    self.pagingEnabled = YES;
}
- (void)customContentView {
    __weak typeof(self) weakSelf = self;
    self.contentViewBlock = ^(NSMutableArray *contentArr) {
        weakSelf.contentViewArr = contentArr;
        weakSelf.contentSize = CGSizeMake((contentArr.count)*self.width, 0);
        [weakSelf addImageView];
    };
}
- (void)addImageView {
    [self.contentUrlArr removeAllObjects];
    for (int index = 0; index <self.contentViewArr.count; index++) {
        NewModel *model = [self.contentViewArr objectAtIndex:index];
        [self.contentUrlArr addObject:model.link];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index*self.width, 0, self.width, self.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.kpic]];
        imageView.tag = index +1;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[self tapGesture]];
        [imageView addSubview:[self subviewOfImageViewWithModle:model]];
        [self addSubview:imageView];
    }
}

- (UITapGestureRecognizer *)tapGesture {
    UITapGestureRecognizer *tapGesTure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
    return tapGesTure;
}
- (void)tapGestureClick:(UITapGestureRecognizer *)gesture {
    UIResponder *responder = self.nextResponder;
    while (responder != nil && ![responder isKindOfClass:[UIViewController class]]) {
        responder = responder.nextResponder;
    }
    UIViewController *viewController = (UIViewController *)responder;
    WebViewController *webVC = [[WebViewController alloc]init];
    ScrollViewController  *scrollVC  = [[ScrollViewController alloc]init];
    //获取当前model，判断类型进行跳转
    NSInteger index = gesture.view.tag - 1;
    NewModel *model = [self.contentViewArr objectAtIndex:index];
    if ([model.category isEqualToString:@"cms"]) {
        
        webVC.id  = model.id;
        webVC.pic = model.pic;
        [viewController.navigationController pushViewController:webVC animated:YES];
    }
    if ([model.category isEqualToString:@"hdpic"]) {
        scrollVC.id  = model.id;
        scrollVC.pic = model.pic;
        [viewController.navigationController pushViewController:scrollVC animated:YES];
    }
}
- (UIView *)subviewOfImageViewWithModle:(NewModel *)model {
    int padding = 5;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(padding*2, self.bottomY-50, 30, 50)];
    if (model.pics) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        self.imageView.image = [UIImage imageNamed:@"iconfont-pic.png"];

        self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 15, 15)];
        PicsModel *picsModel = model.pics;
        NSInteger total = picsModel.total;
        self.countLabel.text = [NSString stringWithFormat:@"%ld",total];
        self.countLabel.font = [UIFont systemFontOfSize:12];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.textColor     = [UIColor orangeColor];
        
        [backgroundView addSubview:self.imageView];
        [backgroundView addSubview:self.countLabel];
    }
    
    UILabel *TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, backgroundView.height-padding-25, self.width, 25)];
    TitleLabel.text = model.title;
    TitleLabel.textColor = [UIColor whiteColor];
    
    [backgroundView addSubview:TitleLabel];
    return backgroundView;
}
@end
