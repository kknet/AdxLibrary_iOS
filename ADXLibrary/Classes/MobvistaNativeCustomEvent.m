//
//  MobvistaNativeCustomEvent.m
//  MoPubSampleApp
//
//  Created by tianye on 2016/11/10.
//  Copyright © 2016年 MoPub. All rights reserved.
//

#import "MobvistaNativeCustomEvent.h"
#import "MobvistaNativeAdAdapter.h"
#import "MPNativeAd.h"
@interface MobvistaNativeCustomEvent()

@property (nonatomic, readwrite, strong) MVNativeAdManager *mvNativeAdManager;
@end


@implementation MobvistaNativeCustomEvent

static BOOL initialized = NO;
- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    NSString *appId = [NSString stringWithFormat:@"%@",[info objectForKey:@"appId"]];//nonnull
    NSString *appKey = [NSString stringWithFormat:@"%@",[info objectForKey:@"appKey"]];//nonnull
    NSString *unitId = [NSString stringWithFormat:@"%@",[info objectForKey:@"unitId"]];//nonnull
    NSString *placementID = [NSString stringWithFormat:@"%@",[info objectForKey:@"placementId"]];
    
    BOOL autoCacheImage = [[info objectForKey:@"autoCacheImage"] boolValue];
    MVAdCategory adCategory =[info objectForKey:@"adCategory"]? [[info objectForKey:@"adCategory"] integerValue]:MVAD_CATEGORY_ALL;
    
    MVAdTemplateType templateType = [info objectForKey:@"templateType"] ?[[info objectForKey:@"templateType"] integerValue]:MVAD_TEMPLATE_BIG_IMAGE;
    
    MVAdTemplateType reqNum = [info objectForKey:@"reqNum"] ?[[info objectForKey:@"reqNum"] integerValue]:1;
    
    if (!initialized) {
        initialized = YES;
        [[MVSDK sharedInstance] setAppID:appId ApiKey:appKey];
    }

    _mvNativeAdManager = [[MVNativeAdManager alloc] initWithUnitID:unitId fbPlacementId:placementID supportedTemplates:@[[MVTemplate templateWithType:templateType adsNum:reqNum]] autoCacheImage:autoCacheImage adCategory:adCategory presentingViewController:nil];
    
    _mvNativeAdManager.delegate = self;
    [_mvNativeAdManager loadAds];
    
}

#pragma mark - nativeAdManager init and delegate

- (void)nativeAdsLoaded:(nullable NSArray *)nativeAds {
    MobvistaNativeAdAdapter *adAdapter = [[MobvistaNativeAdAdapter alloc] initWithNativeAds:nativeAds nativeAdManager:_mvNativeAdManager];
    MPNativeAd *interfaceAd = [[MPNativeAd alloc] initWithAdAdapter:adAdapter];
    [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
}

- (void)nativeAdsFailedToLoadWithError:(nonnull NSError *)error {
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
}

@end
