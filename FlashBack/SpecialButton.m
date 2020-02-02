//
//  SpecialButton.m
//  FlashBack
//
//  Created by Aaron KJ and AYDEN PANHIZYEHN on 2/2/20.
//  Copyright © 2020 Micah Gomez. All rights reserved.
//

#import "SpecialButton.h"

@implementation SpecialButton

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) [self commonInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self commonInit];
    return self;
}

- (void)commonInit {
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.userInteractionEnabled = NO;
    blurView.clipsToBounds = YES;
    blurView.layer.cornerRadius = 15;
    if (@available(iOS 13.0, *)) {
        blurView.layer.cornerCurve = kCACornerCurveContinuous;
    }
    blurView.frame = self.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:blurView atIndex:0];
}

@end
