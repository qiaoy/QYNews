

//
//  ChannelViewController.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/21.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//
#define BUT_W (ScreenWidth - 20*5)/4
#define BUT_H 30
#import "ChannelViewController.h"

@interface ChannelViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property (nonatomic) UICollectionView *collectionView;
//保留路径
@property (nonatomic,copy) NSString  *likeNewPath;
@property (nonatomic,copy) NSString  *unLikeNewPath;
//
@property (nonatomic) NSMutableArray *likeQYNews;
@property (nonatomic) NSMutableArray *UnLikeQYNews;
@property (nonatomic) NSMutableArray *deleteButArr;
@property (nonatomic) NSMutableArray *likeButArr;
@property (nonatomic) NSMutableArray *unLikeButArr;

@property (nonatomic) UIButton       *deleteBut;  //删除Button

@property (nonatomic) BOOL      isSecond;//判断是否为第二次 reloadData
@property (nonatomic) NSInteger selectButIndex; //选中But
//头UI
@property (nonatomic) UILabel  *firHeadLabel;
@property (nonatomic) UILabel  *secHeadLabel;
@property (nonatomic) UIButton *firHeadBut;
@property (nonatomic) BOOL isEdit;
@end

@implementation ChannelViewController
+ (instancetype)sharedInstance {
    static ChannelViewController *s_channelVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_channelVC = [[ChannelViewController alloc]init];
    });
    return s_channelVC;
}
- (id)init {
    if (self = [super init]) {
        self.title = @"频道管理";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self loadDataSource];
    [self createCollection];
    [self createLongGresture];
    [self createHeadUI];
}

- (void)initData {
    self.deleteButArr = [NSMutableArray array];
    self.likeButArr   = [NSMutableArray array];
    self.unLikeButArr = [NSMutableArray array];
    self.likeQYNews   = [[NSMutableArray alloc]init];
    self.UnLikeQYNews = [[NSMutableArray alloc]init];
    self.isSecond = NO;
}
- (NSString *)cacheFileDirectory {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    cacheDir = [cacheDir stringByAppendingPathComponent:@"QYCache"];
    return cacheDir;
}
- (void)loadDataSource {
    //喜欢的文件路径和数据
    self.likeNewPath = [[self cacheFileDirectory] stringByAppendingPathComponent:@"likeFile"];;
    self.likeQYNews    = [NSMutableArray arrayWithContentsOfFile:self.likeNewPath];
    
    //不喜欢的文件路径和数据
    self.unLikeNewPath = [[self cacheFileDirectory] stringByAppendingPathComponent:@"unLikeFile"];
    self.UnLikeQYNews = [NSMutableArray arrayWithContentsOfFile:self.unLikeNewPath];
    
}
#pragma mark - customUI - 
#pragma mark ************
- (UIView *)colBackgroundImage {
    UIImageView *imageVeiw = [[UIImageView alloc]initWithFrame:self.collectionView.bounds];
    imageVeiw.image = [UIImage imageNamed:@"appdetail_background.png"];
    imageVeiw.userInteractionEnabled = YES;
    return imageVeiw;
}
- (void)createCollection {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset =  UIEdgeInsetsMake(10, 20, 20, 20);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing      = 15;
    flowLayout.headerReferenceSize = CGSizeMake(30, 35);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
    [self.collectionView setBackgroundView:[self colBackgroundImage]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //注册
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"colCellId"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headViewId"];
    
    [self.view addSubview:self.collectionView];
}
- (void)createHeadUI {
    self.firHeadLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 30)];
    self.firHeadLabel.font = [UIFont systemFontOfSize:15];

    
    self.secHeadLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 30)];
    self.secHeadLabel.font = [UIFont systemFontOfSize:15];
    
    self.firHeadBut = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 85, 2.5, 70, 30)];
    self.firHeadBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.firHeadBut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.firHeadBut setBackgroundImage:[UIImage imageNamed:@"channel_sort.png"] forState:UIControlStateNormal];
    [self.firHeadBut addTarget:self action:@selector(firHeadButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.firHeadBut setTitle:@"排序删除" forState:UIControlStateNormal];
}
- (void)createLongGresture {
    UILongPressGestureRecognizer *longGresture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGrestureAction:)];
    longGresture.delegate = self;
    [self.collectionView addGestureRecognizer:longGresture];
}
- (UIButton *)createDeleteBut:(UICollectionViewCell *)cell {
    UIButton *deleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBut setImage:[UIImage imageNamed:@"shanchu1.png"] forState:UIControlStateNormal];
    deleteBut.backgroundColor = [UIColor redColor];
    deleteBut.bounds = CGRectMake(0, 0, 20, 20);
    deleteBut.center = CGPointMake(10, 10);
    //判断是否隐藏
    if (self.isSecond) {
        [deleteBut setHidden:NO];
    }else {
        [deleteBut setHidden:YES];
    }

    deleteBut.layer.cornerRadius  = 10;
    [deleteBut becomeFirstResponder];
    deleteBut.layer.masksToBounds = YES;
    [deleteBut addTarget:self action:@selector(deleteButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButArr addObject:deleteBut];
    return deleteBut;
}
//collectionView 第一个区的 内容
- (UIView *)addLikeButton:(NSInteger)index cell:(UICollectionViewCell *)cell{
   
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, BUT_W , BUT_H)];
  
    button.layer.cornerRadius  = 5;
    button.layer.masksToBounds = YES;
    [button setTitle:[self.likeQYNews objectAtIndex:index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"buttonbar_edit.png"] forState:UIControlStateNormal];
    if (index == 0) {
        button.alpha = 0.5;
    }
    [button addTarget:self action:@selector(LikeButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeButArr addObject:button];
    return button;
}
//collectionView 第二个区的 内容
- (UIView *)addUnLikeButton:(NSInteger)index cell:(UICollectionViewCell *)cell{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, BUT_W , BUT_H)];
  
    button.layer.cornerRadius  = 5;
    button.layer.masksToBounds = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"buttonbar_edit.png"] forState:UIControlStateNormal];
    [button setTitle:[self.UnLikeQYNews objectAtIndex:index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(unLikeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.unLikeButArr addObject:button];
    return button;
}
#pragma mark - 响应的事件 -
#pragma mark ************

- (void)longGrestureAction:(UILongPressGestureRecognizer *)gesture {
    
    static NSIndexPath *sourceIndexPath = nil;
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gesture locationInView:self.collectionView]];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 1) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
        cell.alpha     = 1.0;
        return;
    }

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {

            if (indexPath.row != 0) {
                
                cell.alpha     = 0.5;
            }
            //重设排序删除title
            [self.firHeadBut setTitle:@"完成" forState:UIControlStateNormal];
            //设置删除按钮的 隐藏状态
            [self.deleteButArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIButton *button = (UIButton *)obj;
                [button setHidden:NO];
            }];
            
            sourceIndexPath  = indexPath;
        }
            break;
        case UIGestureRecognizerStateChanged: {
  
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                if (indexPath.row != 0 && sourceIndexPath.row != 0) {
                    //交换数据源中title的位置
                    [self.likeQYNews exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                    
                    [self.likeQYNews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([self.butTitle isEqualToString:obj]) {
                            self.selectButIndex = idx;
                        }
                    }];
                    [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                    sourceIndexPath = indexPath;

                    cell.alpha     = 1.0;
                }
            }
           // cell.alpha     = 1.0;
        }
            break;
        case UIGestureRecognizerStateEnded: {
            //
            cell.alpha     = 1.0;
            
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                if (indexPath.row != 0 && sourceIndexPath.row != 0) {
                    //交换数据源中title的位置
                    [self.likeQYNews exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                    
                    [self.likeQYNews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([self.butTitle isEqualToString:obj]) {
                            self.selectButIndex = idx;
                        }
                    }];
                    [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                    self.isSecond = YES;
                    [self.collectionView reloadData];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)deleteButClick:(UIButton *)button {
    __block NSInteger index;
   [self.deleteButArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       UIButton *delBut = (UIButton *)obj;
       if ([delBut isEqual:button]) {
           index = idx;
           *stop = YES;
       }
   }];
    //index +1 第一个按钮没有删除按钮
    NSString *title = [self.likeQYNews objectAtIndex:index +1];
    [self.likeQYNews removeObjectAtIndex:index +1];
    //删除所有的button，准备重新刷新collectionView（必须删除
    [self.deleteButArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = (UIButton *)obj;
        [button removeFromSuperview];
    }];
    for (UIButton *button in self.likeButArr) {
        [button removeFromSuperview];
    }
    for (UIButton *button in self.unLikeButArr) {
        [button removeFromSuperview];
    }
    [self.deleteButArr removeAllObjects];
    [self.unLikeButArr removeAllObjects];
    [self.likeButArr removeAllObjects];
    
    [self.UnLikeQYNews insertObject:title atIndex:0];
    [button setHidden:YES];
    self.isSecond = YES;
    [self.collectionView reloadData];
    
    [self.likeQYNews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([self.butTitle isEqualToString:obj]) {
            self.selectButIndex = idx;
        }
    }];
}
//点击添加
- (void)unLikeButtonClick:(UIButton *)button {
    //设置
    [self.firHeadBut setTitle:@"完成" forState:UIControlStateNormal];
    //删除所有的button，准备重新刷新collectionView（必须删除）
    [self.deleteButArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = (UIButton *)obj;
        [button removeFromSuperview];
    }];
    for (UIButton *button in self.likeButArr) {
        [button removeFromSuperview];
    }
    for (UIButton *button in self.unLikeButArr) {
        [button removeFromSuperview];
    }

    __block NSInteger index;
    [self.unLikeButArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *delBut = (UIButton *)obj;
        if ([delBut isEqual:button]) {
            index = idx;
            [button removeFromSuperview];
            *stop = YES;
        }
    }];
    [self.deleteButArr removeAllObjects];
    [self.likeButArr removeAllObjects];
    [self.unLikeButArr removeAllObjects];
    
    NSString *title = [self.UnLikeQYNews objectAtIndex:index];
    [self.UnLikeQYNews removeObjectAtIndex:index];
    [self.likeQYNews addObject:title];
    
    self.isSecond = YES;
    [self.collectionView reloadData];
    
    [self.likeQYNews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([self.butTitle isEqualToString:obj]) {
            self.selectButIndex = idx;
        }
    }];
}
- (void)LikeButClick:(UIButton *)button {
    //排序删除后，写入文件
    [self.likeQYNews writeToFile:self.likeNewPath atomically:YES];
    [self.UnLikeQYNews writeToFile:self.unLikeNewPath atomically:YES];
    
    //刷新item个数
    if (self.reCollectionBlock) {
        self.reCollectionBlock(button.currentTitle);
    }
    
    //刷新title标题
    if (self.reBlock) {
        self.reBlock(button.currentTitle);
    }

    //选中当前标题
    if (self.jmpClock) {
        self.jmpClock(button.currentTitle);
    }
    
    //排序删除后，写入文件
    [self.likeQYNews writeToFile:self.likeNewPath atomically:YES];
    [self.UnLikeQYNews writeToFile:self.unLikeNewPath atomically:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}
//排序删除按钮 事件
- (void)firHeadButClick:(UIButton *)button {
    //排序删除按钮状态
    if ([self.firHeadBut.currentTitle isEqualToString:@"完成"]) {
        [self.firHeadBut setTitle:@"排序删除" forState:UIControlStateNormal];
    }else {
        [self.firHeadBut setTitle:@"完成" forState:UIControlStateNormal];
    }
    //删除按钮的状态
    [self.deleteButArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *delBut = (UIButton *)obj;
        if ([self.firHeadBut.currentTitle isEqualToString:@"完成"]) {
            [delBut setHidden:NO];
        }else {
            [delBut setHidden:YES];
        }
    }];
}
//协议
#pragma mark - UICollectionView 协议 -
#pragma mark ************************
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.likeQYNews.count;
        
    }else {
        return self.UnLikeQYNews.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colCellId" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell addSubview:[self addLikeButton:indexPath.row cell:cell]];
        if (indexPath.row > 0) {
            [cell addSubview:[self createDeleteBut:cell]];
        }
    }else {
        [cell addSubview:[self addUnLikeButton:indexPath.row cell:cell]];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headViewId" forIndexPath:indexPath];
       
        if (indexPath.section ==0) {
            self.firHeadLabel.text = @"频道管理";
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:headView.bounds];
            imageView.image = [UIImage imageNamed:@"appproduct_searchbar.png"];
            imageView.userInteractionEnabled = YES;
            [headView addSubview:imageView];
            [imageView addSubview:self.firHeadBut];
            [imageView addSubview:self.firHeadLabel];
        }else {
            self.secHeadLabel.text = @"点击添加频道";
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:headView.bounds];
            imageView.image = [UIImage imageNamed:@"appproduct_searchbar.png"];
            imageView.userInteractionEnabled = YES;
            [headView addSubview:imageView];
            [imageView addSubview:self.secHeadLabel];
        }
        return headView;
    }
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(BUT_W+10, BUT_H+10);
}

#pragma mark -
#pragma 重写父类方法
- (void)customNavigationLeftBar {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [self setLeftButtonImage:leftButton];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)setLeftButtonImage:(UIButton *)leftButton {
    [leftButton setImage:[UIImage imageNamed:@"return2.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
}
- (void)leftButtonClick:(UIButton *)button {
    
    //排序删除后，写入文件
    [self.likeQYNews writeToFile:self.likeNewPath atomically:YES];
    [self.UnLikeQYNews writeToFile:self.unLikeNewPath atomically:YES];
    
    //刷新item个数
    if (self.reCollectionBlock) {
        self.reCollectionBlock(@"头条");
    }
    
    //刷新标题
    if (self.reBlock) {
        self.reBlock(button.currentTitle);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)customNavigationRightBar {}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
