//
//  UIBackgroundStyle.h
//  FlashBack
//
//  Created by 23 Aaron on 12/24/19.
//  Copyright © 2019 Micah Gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIBackgroundStyle) {
    UIBackgroundStyleDefault,
    UIBackgroundStyleTransparent,
    UIBackgroundStyleLightBlur,
    UIBackgroundStyleDarkBlur,
    UIBackgroundStyleDarkTranslucent,
    UIBackgroundStyleExtraDarkBlur,
    UIBackgroundStyleBlur
};

@interface UIApplication (UIBackgroundStyle)
// Requires "com.apple.springboard.appbackgroundstyle" entitlement.
-(void)_setBackgroundStyle:(UIBackgroundStyle)style;
@end
