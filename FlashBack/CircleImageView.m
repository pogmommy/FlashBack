//
//  CircleImageView.m
//  FlashBack
//
//  Created by 23 Aaron on 1/25/20.
//  Copyright © 2020 Micah Gomez. All rights reserved.
//

#import "CircleImageView.h"

@implementation CircleImageView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.bounds.size.width / 2;
    
}
    
@end
