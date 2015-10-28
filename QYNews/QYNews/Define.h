//
//  Define.h
//  NewFirstKnow
//
//  Created by qiaoyan on 15/9/21.
//  Copyright © 2015年 QiaoYan. All rights reserved.
//

#ifndef Define_h
#define Define_h

#define ScreenSize   [UIScreen mainScreen].bounds.size
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScrollView_H 40
#define EditBut_W    40
#define Button_W ([UIScreen mainScreen].bounds.size.width - 40)/5.0

#define kBaseTag     666
#define DrawerButTag 888
#define SubButTag    111

#define HEADKEY    @"headKey"
#define CONTENTKEY @"contentKey"

//数据库中记录的类型
#define kCollectionType   @"collectionType"
#define kBrowserType      @"browserType"
#define kDownloadType     @"downloadType"

//通知中心 name
#define JMPNOTIFICATION  @"JMPOneother"
#define REFRESHBUTSTATUS @"refreshButStatus"

//保存switch 的状态 对应的状态
#define isWifi @"isWifi"
#define isHide @"isHide"

#define DATASOURCE_DIC @{@"头条":@"news_toutiao",@"娱乐":@"news_ent",@"体育":@"news_sports",@"财经":@"news_finance",@"汽车":@"news_auto",@"科技":@"news_tech",@"搞笑":@"news_funny",@"女性":@"eladies",@"家居":@"news_home",@"社会":@"news_sh",@"历史":@"news_history",@"时尚":@"news_fashion",@"博客":@"news_blog",@"数码":@"news_digital",@"NBA":@"news_nba",@"健康":@"news_health",@"八卦":@"news_gossip",@"游戏":@"news_game",@"星座":@"news_ast",@"收藏":@"news_collection",@"专栏":@"zhuanlan_recommend",@"育儿":@"news_baby",@"教育":@"news_edu",@"军事":@"news_mil",@"精读":@"news_gread"}

#define kHomeUrl @"http://api.sina.cn/sinago/list.json?uid=74cb951478bd157f&loading_ad_timestamp=0&platfrom_version=4.1.2&wm=b207&imei=A000004925BA53&from=6048195012&connection_type=2&chwm=12411_0005&AndroidID=f38ac775556b8c3076ff6e003346e023&v=1&s=20&IMEI=335c2575d268d5b42b9dc487a9fea776&p=%ld&MAC=b4829bd909fb3b69ec55f8d49689576b&channel=%@"

#define kContentUrl @"http://api.sina.cn/sinago/articlev2.json?id=%@&uid=74cb951478bd157f&wm=b207&oldchwm=12411_0005&imei=A000004925BA53&from=6048195012&postt=news_news_gossip_feed_1&chwm=12411_0005"

//天气接口
#define kWeather @"http://apistore.baidu.com/microservice/weather?cityname=%@"

//发布不输出 NSLog
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

#endif /* Define_h */
