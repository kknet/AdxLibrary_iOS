#if __has_include(<MoPub / MoPub.h>)
#import <MoPub/MoPub.h>
#else
#import "MPNativeCustomEvent.h"
#endif

#define AD_CHOICES_TOP_LEFT         @"ADCHOICES_TOP_LEFT"
#define AD_CHOICES_TOP_RIGHT        @"ADCHOICES_TOP_RIGHT"
#define AD_CHOICES_BOTTOM_RIGHT     @"ADCHOICES_BOTTOM_RIGHT"
#define AD_CHOICES_BOTTOM_LEFT      @"ADCHOICES_BOTTOM_LEFT"

@import GoogleMobileAds;

@interface MPGoogleAdMobNativeCustomEvent : MPNativeCustomEvent

@end
