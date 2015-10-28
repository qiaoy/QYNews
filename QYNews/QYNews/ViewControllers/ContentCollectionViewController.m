


//
//  ContentCollectionViewController.m
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/26.
//  Copyright (c) 2015年 QiaoYan. All rights reserved.
//

#import "ContentCollectionViewController.h"
#import "ContentCollectionViewCell.h"

@interface ContentCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic,copy) NSArray   *recommendList;
@property (nonatomic,copy) NSArray   *newsList;
@property (nonatomic) NSInteger page;

@property (nonatomic) UITableView * currentTV;
@property (nonatomic) UITableView * inactiveTV;
@property (nonatomic) NSMutableArray *cellArr;
@end

@implementation ContentCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
+ (instancetype)sharedInstance {
    static ContentCollectionViewController *s_contentCollectionVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_contentCollectionVC = [[ContentCollectionViewController alloc]init];
    });
    return s_contentCollectionVC;
}
- (id)init {
    if (self = [super init]) {
        [self loadData];
        [self createChannelBlock];
        self.cellArr = [NSMutableArray array];
        [self customMyselfCollectionView];
    }
    return self;
}
- (void)createChannelBlock {
    [ChannelViewController sharedInstance].reCollectionBlock = ^ (NSString *title) {
        NSString *filePath = [self cacheLikeFileDirectory];
        self.recommendList = [NSMutableArray arrayWithContentsOfFile:filePath];
        [self.collectionView reloadData];
        
        __block NSInteger index;
        [self.recommendList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:title]) {
                index = idx;
                *stop = YES;
            }
        }];
        
        [self.collectionView setContentOffset:CGPointMake(index * ScreenWidth, 0)];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.recommendList.count - 1 inSection:0];
        [self collectionView:self.collectionView numberOfItemsInSection:0];
        [self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
    
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (NSString *)cacheLikeFileDirectory {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    cacheDir = [cacheDir stringByAppendingPathComponent:@"QYCache"];
    NSString *filePath = [cacheDir stringByAppendingPathComponent:@"likeFile"];
    return filePath;
}
- (void)loadData {
    NSString *filePath = [self cacheLikeFileDirectory];
    self.recommendList = [NSMutableArray arrayWithContentsOfFile:filePath];
}
- (void)customMyselfCollectionView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.collectionView.delegate = self;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing      = 0;
    flowLayout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight - 64 - ScrollView_H);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64 +ScrollView_H, ScreenWidth, ScreenHeight - 64 - ScrollView_H) collectionViewLayout:flowLayout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    self.collectionView.backgroundColor = [UIColor orangeColor];
    [self.collectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recommendList.count;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger item = (NSInteger)self.collectionView.contentOffset.x/ScreenWidth;
    if (self.setOffsetBlock) {
        self.setOffsetBlock(item);
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell updateWith:[self.recommendList objectAtIndex:indexPath.row]];
    
    NSLog(@"%ld",indexPath.row);
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
