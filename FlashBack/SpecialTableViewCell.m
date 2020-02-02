//
//  SpecialTableViewCell.m
//  FlashBack
//
//  Created by Aaron KJ on 2/2/20.
//  Copyright © 2020 Micah Gomez. All rights reserved.
//

#import "SpecialTableViewCell.h"

@implementation SpecialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.backgroundColor = [UIColor clearColor];
    
    UIView *selectionView = [[UIView alloc] init];
    selectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    self.selectedBackgroundView = selectionView;
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.userInteractionEnabled = NO;
    self.backgroundView = blurView;
}

@end
