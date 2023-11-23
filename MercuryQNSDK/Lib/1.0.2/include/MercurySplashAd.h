//
//  MercurySplashAd.h
//  MercurySDKExample
//
//  Created by 程立卿 on 2020/4/22.
//  Copyright © 2020 mercury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MercurySplashAdDelegate.h"
#import "MercuryPubEnumHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface MercurySplashAd : NSObject

/// 回调
@property (nonatomic, weak) id<MercurySplashAdDelegate> delegate;

/// 拉取广告超时时间，默认为3秒
/// Desc: 拉取广告超时时间，开发者调用 loadDataWithResultBlock 方法以后会立即曝光backgroundImage，然后在该超时时间内，如果广告拉取成功，则立马曝光开屏广告，否则放弃此次广告曝光机会。
@property (nonatomic, assign) NSInteger fetchDelay;

/// showType =  MercurySplashAdAutoAdaptScreen 或 showType =  MercurySplashAdAutoAdaptScreenWithLogoFirst 生效
/// 当素材填充后底部留白 > blankGap 时 会显示logo
/// 默认值是 0
@property (nonatomic, assign) NSInteger blankGap;


/// 广告底部组件展示样式类型
@property (nonatomic, assign) MercurySplashAdShowType showType;

/// 广告占位图
@property (nonatomic, strong) UIImage *placeholderImage;
/// Logo广告
@property (nonatomic, strong) UIImage *logoImage;
/// 父视图 详解：[必选]需设置为显示广告的UIViewController
@property (nonatomic, weak) UIViewController *controller;

/// 自定义路由 不传则默认为 @"qunarphone://hy?url=%@&type=browser"
///  %@ 在内部会默认拼接跳转到qunar web页面的 link encode之后的结果
@property (nonatomic, copy) NSString *customRoute;

/// 构造方法
/// @param adspotId 广告Id
/// @param delegate 代理
- (instancetype)initAdWithAdspotId:(NSString * _Nonnull)adspotId
                          delegate:(id<MercurySplashAdDelegate> _Nullable)delegate;


/// 构造方法 (可携带自定义参数)
/// @param adspotId 广告id
/// @param ext 自定义参数
/// @param delegate 代理
- (instancetype)initAdWithAdspotId:(NSString * _Nonnull)adspotId
                         customExt:(NSDictionary * _Nonnull)ext
                          delegate:(id<MercurySplashAdDelegate> _Nullable)delegate;

/// 拉取广告数据 只拉取 不展示
- (void)loadAd;


- (void)showAdInWindow:(UIWindow *)window;

/// 获取本次开屏广告的价格
- (NSInteger)getPrice;

/// 获取素材链接
- (NSString *)getMaterialLink;

/// 获取本次广告的物料类型
- (MercuryMaterialType)getMaterialType;

/// 物料是否准备好
- (BOOL)materialIsReady;


/// 销毁广告
- (void)destory;


@end

NS_ASSUME_NONNULL_END
