//
//  UIAlertAction+Common.m
//  FlashBack
//
//  Created by Aaron KJ on 2/2/20.
//  Copyright © 2020 Micah Gomez. All rights reserved.
//

#import "UIAlertAction+Common.h"

@implementation UIAlertAction (Common)

+ (UIAlertAction *)okAction {
    return [self okActionWithHandler:nil];
}

+ (UIAlertAction *)okActionWithHandler:(void (^)(UIAlertAction *action))handler {
    return [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:handler];
}

+ (UIAlertAction *)cancelAction {
    return [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
}

@end
