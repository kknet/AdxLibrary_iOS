//
//  MobvistaNativeAdAdapter.m
//  MoPubSampleApp
//
//  Created by tianye on 2016/11/10.
//  Copyright © 2016年 MoPub. All rights reserved.
//

#import "MobvistaNativeAdAdapter.h"
#import <MVSDK/MVNativeAdManager.h>
#import <MVSDK/MVCampaign.h>
#import "MPNativeAdConstants.h"


@interface MobvistaNativeAdAdapter () <MVNativeAdManagerDelegate>

@property (nonatomic, readonly) MVNativeAdManager *nativeAdManager;
@property (nonatomic, readonly) MVCampaign *campaign;
@property (nonatomic, strong) NSDictionary *mvAdProperties;

@end
@implementation MobvistaNativeAdAdapter

- (instancetype)initWithNativeAds:(NSArray *)nativeAds nativeAdManager:(MVNativeAdManager *)nativeAdManager{
    if (self = [super init]) {
        _nativeAdManager = nativeAdManager;
        _nativeAdManager.delegate = self;
        
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];

        if (nativeAds.count > 0) {
            MVCampaign *campaign = nativeAds[0];
            [properties setObject:campaign.appName forKey:kAdTitleKey];
            if (campaign.appDesc) {
                [properties setObject:campaign.appDesc forKey:kAdTextKey];
            }
            
            if (campaign.adCall.length > 0) {
                [properties setObject:campaign.adCall forKey:kAdCTATextKey];
            }
            
            if ([campaign valueForKey:@"star"] ) {
                [properties setValue:@([[campaign valueForKey:@"star"] intValue])forKey:kAdStarRatingKey];
            }
            
            
            if (campaign.imageUrl.length > 0) {
                [properties setObject:campaign.imageUrl forKey:kAdMainImageKey];
            }
            
            if (campaign.iconUrl.length > 0) {
                [properties setObject:campaign.iconUrl forKey:kAdIconImageKey];
            }
            _campaign = campaign;
        }
        _nativeAds = nativeAds;
        _mvAdProperties = properties;
        
    }
    return self;
}

#pragma mark - MVSDK NativeAdManager Delegate

- (void)nativeAdDidClick:(nonnull MVCampaign *)nativeAd;
{
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    }
     [self.delegate nativeAdWillPresentModalForAdapter:self];
}

- (void)nativeAdClickUrlDidEndJump:(nullable NSURL *)finalUrl
                             error:(nullable NSError *)error{
    [self.delegate nativeAdDidDismissModalForAdapter:self];
}



#pragma mark - MPNativeAdAdapter


- (NSDictionary *)properties {
    return _mvAdProperties;
}

- (NSURL *)defaultActionURL {
    return nil;
}
- (BOOL)enableThirdPartyClickTracking
{
    return YES;
}

- (void)willAttachToView:(UIView *)view
{
    [self.nativeAdManager registerViewForInteraction:view withCampaign:_campaign];
    if ([self.delegate respondsToSelector:@selector(nativeAdWillLogImpression:)]){
        [self.delegate nativeAdWillLogImpression:self];
    }
}

- (UIView *)privacyInformationIconView
{
    return nil;
}

- (UIView *)mainMediaView
{
    return nil;
}
@end
