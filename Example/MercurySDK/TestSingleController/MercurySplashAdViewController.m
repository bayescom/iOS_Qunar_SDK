//
//  MercurySplashAdViewController.m
//  AAA
//
//  Created by CherryKing on 2019/11/1.
//  Copyright © 2019 CherryKing. All rights reserved.
//

#import "MercurySplashAdViewController.h"

#import <MercurySDK/MercurySDK.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface MercurySplashAdViewController () <MercurySplashAdDelegate>
@property (nonatomic, strong) MercurySplashAd *ad;
@property (nonatomic, strong) UIImageView *img;
@end

@implementation MercurySplashAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initDefSubviewsFlag = YES;
    self.adspotIdsArr = @[
        @{@"addesc": @"开屏(长图)", @"adspotId": @"10002619"},
        @{@"addesc": @"开屏(dp长图 广告:1013861,创意:100036931)", @"adspotId": @"10007344"},
    ];
    
    
    
    self.img = [UIImageView new];
    self.img.frame = CGRectMake(100, 100, 80, 80);
    [self.view addSubview:self.img];

    self.btn1Title = @"加载并显示广告";
//    UIImage *img = [UIImage imageNamed:@"MercurySplashcMotion"];
//    NSString *path = [self imageToBase64:img];
//    NSLog(@"%@",path);
    NSString *path = @"";
    UIImage *image = [self imageWithBase64:path];
    self.img.image = image;
    
    
    
}

- (UIImage *)imageWithBase64:(NSString *)encodedImageStr {
    NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    
    return decodedImage;
}


- (NSString *)imageToBase64:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}


// MARK: ======================= load ad =======================
- (void)loadAdBtn1Action {
    
    [_ad destory];
    if (![self checkAdspotId]) { return; }
    _ad = [[MercurySplashAd alloc] initAdWithAdspotId:self.adspotId customExt:@{} delegate:self];
    _ad.controller = self;
    // 自定义Logo，占位图
    _ad.placeholderImage = [UIImage imageNamed:@"LaunchImage_img"];
    _ad.showType = MercurySplashAdAutoAdaptScreenWithLogoFirst;
    _ad.fetchDelay = 5;
    [_ad loadAd];

}

- (NSString *)jsonStringCompactFormatForDictionary:(NSDictionary *)dicJson {

    if (![dicJson isKindOfClass:[NSDictionary class]] || ![NSJSONSerialization isValidJSONObject:dicJson]) {

        return nil;

    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicJson options:0 error:nil];

    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return strJson;

}


- (UIImage*)createImageFromView

{
// 1000 170
    
    CGFloat width = self.view.frame.size.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 120)];
    view.backgroundColor = [UIColor blueColor];
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_logo"]];
    [view addSubview:imageV];
    imageV.frame = CGRectMake(0, 0, 100 * (1000.f/170.f), 100);
    imageV.center = view.center;
    
//obtain scale
    CGFloat scale = [UIScreen mainScreen].scale;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width,
                                                      120), NO,scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //开始生成图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



// 广告素材宽高不确定 所以底部的留白高度不确定
- (UIView *)getTestBottomView {
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 120, self.view.frame.size.width, 120)];
    test.backgroundColor = [UIColor redColor];
    return test;
}

- (void)showAction {
    __weak typeof(self) _self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(_self) self = _self;
        [self.ad showAdInWindow:self.view.window];
    });

}

// MARK: ======================= MercurySplashAdDelegate =======================
- (void)mercury_splashAdDidLoad:(MercurySplashAd *)splashAd {
    NSLog(@"开屏广告模型加载成功 %s\r\nprice:%ld\r\n素材链接:%@\r\n素材类型:%ld", __func__, (long)[splashAd getPrice], [splashAd getMaterialLink], (long)[splashAd getMaterialType]);

    NSLog(@"跳转跳转链接(此时获取不到,请在点击后的mercury_splashAdOpenlink:linkType:中获取):%@", [splashAd getDeeplinkOrPageUrl]);
    [self showAction];
}

- (void)mercury_splashAdSuccessPresentScreen:(MercurySplashAd *)splashAd {
    NSLog(@"开屏广告成功曝光 %s %@", __func__, splashAd);
}

- (void)mercury_splashAdFailError:(NSError *)error {
    NSLog(@"开屏广告曝光失败 %s %@ ", __func__, error);
}

- (void)mercury_splashAdLifeTime:(NSUInteger)time {
    if (time <= 0) {
        NSLog(@"开屏广告剩余时间回调 %s _ %lu", __func__, (unsigned long)time);
    }
}

- (void)mercury_splashAdApplicationWillEnterBackground:(MercurySplashAd *)splashAd {
    NSLog(@"应用进入后台时回调 %s %@", __func__, splashAd);
}

- (void)mercury_splashAdExposured:(MercurySplashAd *)splashAd {
    NSLog(@"开屏广告曝光回调 %s  %@", __func__, splashAd);
}

- (void)mercury_splashAdClicked:(MercurySplashAd *)splashAd {
    NSLog(@"开屏广告点击回调 %s %@", __func__, splashAd);
    NSLog(@"跳转跳转链接:%@", [splashAd getDeeplinkOrPageUrl]);

}

- (void)mercury_splashAdWillClosed:(MercurySplashAd *)splashAd {
    NSLog(@"开屏广告将要关闭回调 %s %@", __func__, splashAd);
}

- (void)mercury_splashAdClosed:(MercurySplashAd *)splashAd {
    NSLog(@"开屏广告关闭回调 %s %@", __func__, splashAd);
}

- (void)mercury_splashAdSkipClicked:(MercurySplashAd *)splashAd {
    NSLog(@"开屏广告点击跳过回调 %s %@", __func__, splashAd);
}

- (void)mercury_splashAdOpenlink:(NSString *)link linkType:(MercuryTargetLinkType)type {
    NSLog(@"此回调非点击回调,仅回调dplink或h5link,切勿在该回调中处理与点击事件有关的业务 %s link:%@ %ld", __func__, link, type);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    self.ad = nil;
  
}

@end
