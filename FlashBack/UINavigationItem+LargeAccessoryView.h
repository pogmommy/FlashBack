//
//  UINavigationItem+LargeAccessoryView.h
//  FlashBack
//
//  Created by 23 Aaron on 12/29/19.
//  Copyright © 2019 Micah Gomez. All rights reserved.
//

#ifndef UINavigationBar_LargeAccessoryView_h
#define UINavigationBar_LargeAccessoryView_h

@interface UINavigationItem (Private)
@property (setter=_setLargeTitleAccessoryView:,nonatomic,retain) UIView * _largeTitleAccessoryView;
@end

#endif /* UINavigationBar_LargeAccessoryView_h */
