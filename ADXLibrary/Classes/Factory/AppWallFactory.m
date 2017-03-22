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
    [wallManager showAppWall];
}

@end
