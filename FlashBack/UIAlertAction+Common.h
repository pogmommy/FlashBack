//
//  UIAlertAction+Common.h
//  FlashBack
//
//  Created by Aaron KJ on 2/2/20.
//  Copyright © 2020 Micah Gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertAction (Common)
+ (UIAlertAction *)okAction;
+ (UIAlertAction *)okActionWithHandler:(void (^)(UIAlertAction *action))handler;
+ (UIAlertAction *)cancelAction;
@end

NS_ASSUME_NONNULL_END
