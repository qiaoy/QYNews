//
//  "WeatherViewController.m"
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/21.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//

#define kCity @"city"

#import "WeatherViewController.h"
#import "NFKCachManager.h"
#import "WeatherModel.h"
#import "CityViewController.h"

@interface WeatherViewController () <returnCityName>
//地名
@property (nonatomic) NSString *cityName;
@property (nonatomic, copy) NSString *capital;
//UI
@property (nonatomic) UIImageView *backgroundImage;
@property (nonatomic) UIView      *weatherView;
@property (nonatomic) UILabel     *myLabel;
@property (nonatomic) UILabel     *QYLabel;
@property (nonatomic) UILabel     *currentTmpLabel;
@property (nonatomic) UILabel     *tmpperatureLabel;
@property (nonatomic) UILabel     *timeLabel;
@property (nonatomic) UILabel     *windLabel;
@property (nonatomic) UIImageView *weatherImageView;
@property (nonatomic) UILabel     *cityLabel;

@property (nonatomic) NSArray *textArray;
@property (nonatomic) NSMutableArray *WeatherArray;

@end

@implementation WeatherViewController
- (id)init {
    if (self = [super init]) {
        self.title = @"天气";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    self.backgroundImage.image = [UIImage imageNamed:@"qiao2.png"];
    self.backgroundImage.alpha = 0.95;
    [self.view addSubview:self.backgroundImage];
    [self.view insertSubview:self.backgroundImage belowSubview:self.alphaView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    self.navigationItem.backBarButtonItem = item;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWeatherView];
    [self fetchWeatherData];
    
}
- (void)loadData {
    self.textArray = @[@"今天是个好天气哦，出去晒晒太阳吧，祝你有一个好心情...",@"今天可能会下雨哦，出门记得带一把雨伞，注意报闹别感冒啦...",@"今天可能要下雪了，注意保暖哦...",@"今天可能会是一个阴天哦，出门注意安全，祝你有一个好的心情..."];
}
#pragma mark - 视图 -
- (UILabel *)myLabel {
    if (!_myLabel) {
        _myLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 300, ScreenWidth - 20*2, 100)];
        _myLabel.textColor = [UIColor orangeColor];
        _myLabel.numberOfLines = 0;
    }
    return _myLabel;
}
- (UILabel *)QYLabel {
    if (!_QYLabel) {
        _QYLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _QYLabel.text = @"__ QY新闻";
    }
    return _QYLabel;
}
- (UIView *)weatherView{
    if (!_weatherView) {
        _weatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.38 * ScreenHeight)];
    }
    return _weatherView;
}

- (UILabel *)currentTmpLabel{
    if (!_currentTmpLabel) {
         _currentTmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.05 * ScreenWidth, 0.10 * ScreenHeight, 0.32 * ScreenWidth, 0.15 * ScreenHeight)];
        _currentTmpLabel.font = [UIFont systemFontOfSize:_currentTmpLabel.width - 15];
        _currentTmpLabel.textColor = [UIColor redColor];
    }
    return _currentTmpLabel;
}

- (UILabel *)tmpperatureLabel{
    if (!_tmpperatureLabel) {
        _tmpperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.37 * ScreenWidth, 0.20 * ScreenHeight, 0.4 * ScreenWidth, 21)];
        _currentTmpLabel.text = @"8℃/20℃";
    }
    return _tmpperatureLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.08 * ScreenWidth, 0.24 * ScreenHeight, 0.53 * ScreenWidth, 21)];
        _timeLabel.text = @"15-10-09  星期五";
    }
    return _timeLabel;
}

- (UILabel *)windLabel{
    if (!_windLabel) {
        _windLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.08 * ScreenWidth, 0.27 * ScreenHeight, 0.64 *ScreenWidth, 21)];
        _windLabel.text = @"北风  4-5级(17~25m/h)";
    }
    return _windLabel;
}

- (UIImageView *)weatherImageView{
    if (!_weatherImageView) {
        _weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.75 * ScreenWidth                                                                                                            , 0.12 * ScreenHeight, 64, 64)];
        _weatherImageView.layer.cornerRadius  = 25;
        _weatherImageView.layer.masksToBounds = YES;
        _weatherImageView.image = [UIImage imageNamed:@"iconfont-qing.png"];
    }
    return _weatherImageView;
}

- (UILabel *)cityLabel{
    if (!_cityLabel) {
         _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.7 * ScreenWidth, 0.24 * ScreenHeight, 0.27 * ScreenWidth, 21)];
        _cityLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cityLabel;
}


- (void)fetchWeatherData{
    if (![self fetchWeatherDataFromLocal]) {
        [self fetchWeatherDataFromSever];
    }
}

- (NSString *)composeUrl{
    NSString *urlStr = nil;
    
    self.cityName = [[NSUserDefaults standardUserDefaults]objectForKey:kCity];
    
    if (self.cityName.length != 0) {
        urlStr = [NSString stringWithFormat:kWeather,self.cityName];
    }else{
        urlStr = [NSString stringWithFormat:kWeather,@"上海"];
    }
    
    NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return url;
}
#pragma mark - 加载网络数据 -
- (BOOL)fetchWeatherDataFromLocal{
    if ([NFKCachManager isCacheDataInvalid:[self composeUrl]]) {
        id responsData = [NFKCachManager readDataAtUrl:[self composeUrl]];
        [self parseRespondData:responsData];
        return YES;
    }
    return NO;
}

- (void)fetchWeatherDataFromSever{
    self.WeatherArray = [NSMutableArray array];
    NSString *url = [self composeUrl];
    
    [[NetDataEngine sharedInstance] requestWeatherFrom:url success:^(id responsData) {
        [self parseRespondData:responsData];
        [self updateWeatherViewWithModel:[_WeatherArray lastObject]];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)parseRespondData:(id)responsData{
    if ([responsData[@"errMsg"] isEqualToString:@"success"]) {
        _WeatherArray = [WeatherModel parseRespondData:responsData];
        [NFKCachManager saveData:responsData atUrl:[self composeUrl]];
        [self updateWeatherViewWithModel:[_WeatherArray lastObject]];
    }else{
        self.cityName = self.capital;
        [self fetchWeatherDataFromSever];
    }
}

//添加天气数据
- (void)updateWeatherViewWithModel:(WeatherModel *)model{
    _currentTmpLabel.text = model.temp;
    _tmpperatureLabel.text = [NSString stringWithFormat:@"%@℃/%@℃",model.l_tmp,model.h_tmp];
    _timeLabel.text = [TimeChannel calculateLeftTimeFromNow];
    _windLabel.text = [NSString stringWithFormat:@"%@  %@",model.WD,model.WS];
    if ([model.weather hasPrefix:@"晴"]) {
        _weatherImageView.image = [UIImage imageNamed:@"iconfont-qing.png"];
        self.myLabel.text = [self.textArray objectAtIndex:0];
    }else if ([model.weather hasSuffix:@"雨"]){
        _weatherImageView.image = [UIImage imageNamed:@"iconfont-xiayu.png"];
        self.myLabel.text = [self.textArray objectAtIndex:1];
    }else if ([model.weather hasSuffix:@"雪"]){
        _weatherImageView.image = [UIImage imageNamed:@"iconfont-daxue.png"];
        self.myLabel.text = [self.textArray objectAtIndex:2];
    }else{
        _weatherImageView.image = [UIImage imageNamed:@"iconfont-yin.png"];
        self.myLabel.text = [self.textArray objectAtIndex:3];
    }
    self.QYLabel.frame = CGRectMake(ScreenWidth - 120, self.myLabel.bottomY, 100, 25);
    _cityLabel.text = [NSString stringWithFormat:@"%@ %@",model.city,model.weather];
}
#pragma mark - 天气视图
- (void)createWeatherView{
   
    UILabel *Clabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 70, 32, 32)];
    Clabel.font = [UIFont systemFontOfSize:25];
    Clabel.text = @"℃";
    [self.weatherView addSubview:self.currentTmpLabel];
    [self.weatherView addSubview:Clabel];
    [self.weatherView addSubview:self.tmpperatureLabel];
    [self.weatherView addSubview:self.timeLabel];
    [self.weatherView addSubview:self.windLabel];
    [self.weatherView addSubview:self.weatherImageView];
    [self.weatherView addSubview:self.cityLabel];
    [self.backgroundImage addSubview:self.myLabel];
    [self.backgroundImage addSubview:self.QYLabel];
    [self.backgroundImage addSubview:self.weatherView];
}

- (void)returnCityName:(NSString *)city and:(NSString *)capital{
    _cityName = city;
    _capital  = capital;
    
    [[NSUserDefaults standardUserDefaults]setObject:_cityName forKey:kCity];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self fetchWeatherDataFromSever];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - 重写父类方法 -

- (void)setRightButtonImage:(UIButton *)rightButton {
    [rightButton setImage:[UIImage imageNamed:@"lbs2.png"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
}
- (void)rightButtonClick:(UIButton *)button {
    
    CityViewController *cityVC = [[CityViewController alloc]init];
    cityVC.delegate = self;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"cube";
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:cityVC animated:YES];
}

@end
