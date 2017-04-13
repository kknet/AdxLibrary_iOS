//
//  AppWallFactory.h
//  Pods
//
//  Created by 최치웅 on 2017. 3. 17..
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AppWallFactory : NSObject

+ (void)init:(NSString *)appId adUnitId:(NSString *)adUnitId;

+ (void)preloadAppWall;
+ (void)showAppWall:(UIViewController *)viewController;

+ (void)setAppWallNavBarTintColor:(nonnull UIColor *)color;
+ (void)setAppWallNavBarBackgroundImage:(nonnull UIImage *)image;

+ (void)setAppWallTitle:(nonnull NSString *)title titleColor:(nonnull UIColor *)color;
+ (void)setAppWallTitleImage:(nonnull UIImage *)image;

+ (void)setAppWallCloseButtonImage:(nonnull UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage;
@end
