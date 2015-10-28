//
//  "CtiyViewController.h"
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/21.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol returnCityName <NSObject>

- (void)returnCityName:(NSString *)city and:(NSString *)capital;
@end
@interface  CityViewController: UIViewController

@property (nonatomic, assign) id <returnCityName> delegate;
@end
