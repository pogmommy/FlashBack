//
//  ViewController.h
//  FlashBack
//
//  Created by Micah Gomez on 3/27/19.
//  Copyright © 2019 Micah Gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    
    IBOutlet UILabel *selectedBackupText;
    IBOutlet UIImageView *selectedBackupImage;
    IBOutlet UIPickerView *selectedBackupPickerView;
    IBOutlet UILabel *noBackupsLabel;

}

@property (weak, nonatomic) IBOutlet UILabel *FlashBackTitle;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

