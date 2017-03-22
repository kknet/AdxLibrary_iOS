//
//  AppWallFactory.h
//  Pods
//
//  Created by 최치웅 on 2017. 3. 17..
//
//

#import <Foundation/Foundation.h>

@interface AppWallFactory : NSObject

+ (void)init:(NSString *)appId adUnitId:(NSString *)adUnitId;

+ (void)preloadAppWall;
+ (void)showAppWall:(UIViewController *)viewController;

@end
