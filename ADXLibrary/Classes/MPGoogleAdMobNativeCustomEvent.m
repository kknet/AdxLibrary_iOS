#import "MPGoogleAdMobNativeAdAdapter.h"
#import "MPGoogleAdMobNativeCustomEvent.h"
#import "MPInstanceProvider.h"
#import "MPLogging.h"
#import "MPNativeAd.h"
#import "MPNativeAdConstants.h"
#import "MPNativeAdError.h"
#import "MPNativeAdUtils.h"

static void MPGoogleLogInfo(NSString *message) {
    message = [[NSString alloc] initWithFormat:@"<Google Adapter> - %@", message];
    MPLogInfo(message);
}

@interface MPGoogleAdMobNativeCustomEvent () <
GADAdLoaderDelegate, GADNativeAppInstallAdLoaderDelegate, GADNativeContentAdLoaderDelegate>

/// GADAdLoader instance.
@property(nonatomic, strong) GADAdLoader *adLoader;

@end

@implementation MPGoogleAdMobNativeCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info {
    NSString *adUnitID = info[@"adUnitID"];
    if (!adUnitID) {
        [self.delegate nativeCustomEvent:self
                didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidAdServerResponse(
                                                                                     @"Ad unit ID cannot be nil.")];
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    while (rootViewController.presentedViewController) {
        rootViewController = rootViewController.presentedViewController;
    }
    GADRequest *request = [GADRequest request];
    request.requestAgent = @"MoPub";
    GADNativeAdImageAdLoaderOptions *nativeAdImageLoaderOptions =
    [[GADNativeAdImageAdLoaderOptions alloc] init];
    nativeAdImageLoaderOptions.disableImageLoading = YES;
    nativeAdImageLoaderOptions.shouldRequestMultipleImages = NO;
    nativeAdImageLoaderOptions.preferredImageOrientation =
    GADNativeAdImageAdLoaderOptionsOrientationAny;
    
    // In GADNativeAdViewAdOptions, the default preferredAdChoicesPosition is
    // GADAdChoicesPositionTopRightCorner.
    GADNativeAdViewAdOptions *nativeAdViewAdOptions = [[GADNativeAdViewAdOptions alloc] init];
    nativeAdViewAdOptions.preferredAdChoicesPosition = GADAdChoicesPositionTopRightCorner;
    
    // chiung.choi start
    NSString * adChoicesPosition = info[@"ad_choices_placement"];
    
    if([adChoicesPosition isEqualToString:AD_CHOICES_TOP_LEFT] || [adChoicesPosition isEqualToString:@"0"]) {
        nativeAdViewAdOptions.preferredAdChoicesPosition = GADAdChoicesPositionTopLeftCorner;
    } else if([adChoicesPosition isEqualToString:AD_CHOICES_TOP_RIGHT] || [adChoicesPosition isEqualToString:@"1"]) {
        nativeAdViewAdOptions.preferredAdChoicesPosition = GADAdChoicesPositionTopRightCorner;
    } else if([adChoicesPosition isEqualToString:AD_CHOICES_BOTTOM_RIGHT] || [adChoicesPosition isEqualToString:@"2"]) {
        nativeAdViewAdOptions.preferredAdChoicesPosition = GADAdChoicesPositionBottomRightCorner;
    } else if([adChoicesPosition isEqualToString:AD_CHOICES_BOTTOM_LEFT] || [adChoicesPosition isEqualToString:@"3"]) {
        nativeAdViewAdOptions.preferredAdChoicesPosition = GADAdChoicesPositionBottomLeftCorner;
    }
    // chiung.choi end
    
    self.adLoader = [[GADAdLoader alloc]
                     initWithAdUnitID:adUnitID
                     rootViewController:rootViewController
                     adTypes:@[ kGADAdLoaderAdTypeNativeAppInstall, kGADAdLoaderAdTypeNativeContent ]
                     options:@[ nativeAdImageLoaderOptions, nativeAdViewAdOptions ]];
    self.adLoader.delegate = self;
    [self.adLoader loadRequest:request];
}

#pragma mark GADAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
}

#pragma mark GADNativeAppInstallAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader
didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd {
    if (![self isValidAppInstallAd:nativeAppInstallAd]) {
        MPGoogleLogInfo(@"App install ad is missing one or more required assets, failing the request");
        [self.delegate nativeCustomEvent:self
                didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidAdServerResponse(
                                                                                     @"Missing one or more required assets.")];
        return;
    }
    
    MPGoogleAdMobNativeAdAdapter *adapter = [[MPGoogleAdMobNativeAdAdapter alloc] initWithAdMobNativeAppInstallAd:nativeAppInstallAd];
    MPNativeAd *moPubNativeAd = [[MPNativeAd alloc] initWithAdAdapter:adapter];
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    
    if ([moPubNativeAd.properties[kAdIconImageKey] length]) {
        if (![MPNativeAdUtils addURLString:moPubNativeAd.properties[kAdIconImageKey]
                                toURLArray:imageURLs]) {
            [self.delegate nativeCustomEvent:self
                    didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidImageURL()];
        }
    }
    
    if ([moPubNativeAd.properties[kAdMainImageKey] length]) {
        if (![MPNativeAdUtils addURLString:moPubNativeAd.properties[kAdMainImageKey]
                                toURLArray:imageURLs]) {
            [self.delegate nativeCustomEvent:self
                    didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidImageURL()];
        }
    }
    
    [super precacheImagesWithURLs:imageURLs
                  completionBlock:^(NSArray *errors) {
                      if (errors) {
                          [self.delegate nativeCustomEvent:self
                                  didFailToLoadAdWithError:MPNativeAdNSErrorForImageDownloadFailure()];
                      } else {
                          [self.delegate nativeCustomEvent:self didLoadAd:moPubNativeAd];
                      }
                  }];
}

#pragma mark GADNativeContentAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader
didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    if (![self isValidContentAd:nativeContentAd]) {
        MPGoogleLogInfo(@"Content ad is missing one or more required assets, failing the request");
        [self.delegate nativeCustomEvent:self
                didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidAdServerResponse(
                                                                                     @"Missing one or more required assets.")];
        return;
    }
    
    MPGoogleAdMobNativeAdAdapter *adapter =
    [[MPGoogleAdMobNativeAdAdapter alloc] initWithAdMobNativeContentAd:nativeContentAd];
    MPNativeAd *interfaceAd = [[MPNativeAd alloc] initWithAdAdapter:adapter];
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    
    if ([interfaceAd.properties[kAdIconImageKey] length]) {
        if (![MPNativeAdUtils addURLString:interfaceAd.properties[kAdIconImageKey]
                                toURLArray:imageURLs]) {
            [self.delegate nativeCustomEvent:self
                    didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidImageURL()];
        }
    }
    
    if ([interfaceAd.properties[kAdMainImageKey] length]) {
        if (![MPNativeAdUtils addURLString:interfaceAd.properties[kAdMainImageKey]
                                toURLArray:imageURLs]) {
            [self.delegate nativeCustomEvent:self
                    didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidImageURL()];
        }
    }
    
    [super precacheImagesWithURLs:imageURLs
                  completionBlock:^(NSArray *errors) {
                      if (errors) {
                          [self.delegate nativeCustomEvent:self
                                  didFailToLoadAdWithError:MPNativeAdNSErrorForImageDownloadFailure()];
                      } else {
                          [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
                      }
                  }];
}

#pragma mark - Private Methods

/// Checks the app install ad has required assets or not.
- (BOOL)isValidAppInstallAd:(GADNativeAppInstallAd *)appInstallAd {
    return (appInstallAd.headline && appInstallAd.body && appInstallAd.icon &&
            appInstallAd.images.count && appInstallAd.callToAction);
}

/// Checks the content ad has required assets or not.
- (BOOL)isValidContentAd:(GADNativeContentAd *)contentAd {
    return (contentAd.headline && contentAd.body && contentAd.logo && contentAd.images.count &&
            contentAd.callToAction);
}
@end
