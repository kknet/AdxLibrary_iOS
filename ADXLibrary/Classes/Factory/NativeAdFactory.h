//
//  NativeAdFactory.h
//  Pods
//
//  Created by 최치웅 on 2017. 3. 17..
//
//

#import <Foundation/Foundation.h>
#import "MPNativeAd.h"
#import "MoPub.h"

@protocol NativeAdFactoryDelegate <NSObject>

- (void)onSuccess:(NSString *)adUnitId nativeAd:(MPNativeAd *)nativeAd;
- (void)onFailure:(NSString *)adUnitId;

@end


@interface NativeAdFactory : NSObject

@property (nonatomic, strong) NSMutableDictionary *nativeAds;
@property (nonatomic, strong) NSMutableDictionary *renderingViewClasses;
@property (nonatomic, strong) NSMutableDictionary *viewSizeHandlers;

@property (nonatomic, strong) NSMutableDictionary *loadings;
@property (nonatomic, strong) NSMutableDictionary *preloadings;

@property (nonatomic, strong) NSMutableSet *delegateSet;

+ (id)sharedInstance;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

- (void)preloadAd:(NSString *)adUnitId;
- (void)loadAd:(NSString *)adUnitId;

- (MPNativeAd *)getNativeAd:(NSString *)adUnitId;

- (void)setRenderingViewClass:(NSString *)adUnitId renderingViewClass:(Class)renderingViewClass;
- (Class)getRenderingViewClass:(NSString *)adUnitId;

- (void)setViewSizeHandler:(NSString *)adUnitId viewSizeHandler:(MPNativeViewSizeHandler)viewSizeHandler;
- (MPNativeViewSizeHandler)getViewSizeHandler:(NSString *)adUnitId;

- (UIView *)getNativeAdView:(NSString *)adUnitId;

@end
