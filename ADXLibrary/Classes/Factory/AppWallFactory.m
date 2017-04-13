//
//  AppWallFactory.m
//  Pods
//
//  Created by 최치웅 on 2017. 3. 17..
//
//

#import "AppWallFactory.h"
#import <MVSDK/MVSDK.h>
#import <MVSDKAppWall/MVWallAdManager.h>

static NSString * _appId = nil;
static NSString * _adUnitId = nil;

static UIColor * _naviBarTintColor = nil;
static UIImage * _naviBarBackgroundImage = nil;

static NSString * _title = nil;
static UIColor * _titleColor = nil;
static UIImage * _titleImage = nil;

static UIImage * _closeButtonImage = nil;
static UIImage * _closeButtonHighlightedImage = nil;

@implementation AppWallFactory

+ (void)init:(NSString *)appId adUnitId:(NSString *)adUnitId {
    _appId = appId;
    _adUnitId = adUnitId;
    
    [[MVSDK sharedInstance] setAppID:appId ApiKey:@"8ce0be271fcf0452a70966299f1e32aa"];
}

+ (void)preloadAppWall {
    [[MVSDK sharedInstance] preloadAppWallAdsWithUnitId:_adUnitId];
}

+ (void)showAppWall:(UIViewController *)viewController {
    MVWallAdManager * wallManager = [[MVWallAdManager alloc] initWithUnitID:_adUnitId presentingViewController:viewController];
    
    if(_naviBarTintColor != nil) {
        [wallManager setAppWallNavBarTintColor:_naviBarTintColor];
    }
    if(_naviBarBackgroundImage != nil) {
        [wallManager setAppWallNavBarBackgroundImage:_naviBarBackgroundImage];
    }
    
    if(_title != nil && _titleColor != nil) {
        [wallManager setAppWallTitle:_title titleColor:_titleColor];
    }
    if(_titleImage != nil) {
        [wallManager setAppWallTitleImage:_titleImage];
    }
    
    if(_closeButtonImage != nil && _closeButtonHighlightedImage != nil) {
        [wallManager setAppWallCloseButtonImage:_closeButtonImage highlightedImage:_closeButtonHighlightedImage];
    }
    
    [wallManager showAppWall];
}

+ (void)setAppWallNavBarTintColor:(nonnull UIColor *)color {
    _naviBarTintColor = color;
}
+ (void)setAppWallNavBarBackgroundImage:(nonnull UIImage *)image {
    _naviBarBackgroundImage = image;
}

+ (void)setAppWallTitle:(nonnull NSString *)title titleColor:(nonnull UIColor *)color {
    _title = title;
    _titleColor = color;
}
+ (void)setAppWallTitleImage:(nonnull UIImage *)image {
    _titleImage = image;
}

+ (void)setAppWallCloseButtonImage:(nonnull UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage {
    _closeButtonImage = image;
    _closeButtonHighlightedImage = highlightedImage;
}

@end
