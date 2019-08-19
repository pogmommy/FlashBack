//
//  ViewController.m
//  FlashBack
//
//  Created by Micah Gomez on 3/27/19.
//  Copyright © 2019 Micah Gomez. All rights reserved.
//

#import "ViewController.h"
#include <spawn.h>
#include <signal.h>
#include "NSTask.h"
#import "UIImage+Private.h"

@interface ViewController ()

@end

BOOL trial;
NSArray *_backupFolderArray;
NSString *_backupDirectory;
NSMutableString *selectedBackupImageURL;
NSMutableString *selectedBackupURL;
NSString *backupNameSelected;


@implementation ViewController

- (IBAction)createBackup:(id)sender {
    
    if(([_backupFolderArray count] >= 1) && (trial == YES)){
        
        UIAlertController * noMoreBackupsAlert =   [UIAlertController
                                                    alertControllerWithTitle:@"Maximum Backups Reached"
                                                    message:@"The free trial of FlashBack only allows one saved setup. Purchase the full version on PackIX for $1.50 to make more!"
                                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [noMoreBackupsAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [noMoreBackupsAlert addAction:ok];
        [self presentViewController:noMoreBackupsAlert animated:YES completion:nil];
        
    }
    else{

        UIAlertController *createBackupAlert = [UIAlertController alertControllerWithTitle:@"Enter the Backup Name" message:@"Please do not use special symbols. Use only letters and numbers, no spaces. If you have issues with the wallpaper not being properly applied after restoring to a backup, install autowall from\n https://jb365.github.io/" preferredStyle:UIAlertControllerStyleAlert];
        [createBackupAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Backup Name";
            textField.secureTextEntry = NO;
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Backup name is :%@", [[createBackupAlert textFields][0] text]);
            NSString *newBackupName=[[createBackupAlert textFields][0] text];
            
            if([[[createBackupAlert textFields][0] text] isEqual:@""]){
                NSLog(@"empty backup name!");
            }
            else{
                NSLog(@"Backup name is good!");
                
                NSLog(@"Running NSTask");
                
                NSTask *createTask = [[NSTask alloc] init];
                [createTask setLaunchPath:@"/bin/bash"];
                [createTask setArguments:@[ @"FBCreate", newBackupName]];
                [createTask launch];
                [createTask waitUntilExit];
                
                UIAlertController * finishedCreateAlert=   [UIAlertController
                                                            alertControllerWithTitle:@"Backup Creation Completed"
                                                            message:@"The backup has been successfully created"
                                                            preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         
                                         _backupFolderArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/FlashBack/Backups/" error:nil];
                                         [self->selectedBackupPickerView reloadAllComponents];
                                         
                                         [finishedCreateAlert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                [finishedCreateAlert addAction:ok];
                
                [self presentViewController:finishedCreateAlert animated:YES completion:nil];
                
                /*pid_t pid;
                 int status;
                 const char* args[] = {"killall", "backboardd", NULL, NULL};
                 posix_spawn(&pid, "/bin/bash", NULL, NULL, (char* const*)args, NULL);
                 waitpid(pid, &status, WEXITED);*/
                
            }
            
            
        }];
        [createBackupAlert addAction:confirmAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Canelled");
        }];
        [createBackupAlert addAction:cancelAction];
        [self presentViewController:createBackupAlert animated:YES completion:nil];
    }
}

- (IBAction)restoreBackup:(id)sender {
    
    if (backupNameSelected == nil){
        
        UIAlertController * selectBackupAlert=   [UIAlertController
                                                  alertControllerWithTitle:@"Select a Backup!"
                                                  message:@"Scroll through the list then let it settle on an item to select the backup."
                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [selectBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [selectBackupAlert addAction:ok];
        
        [self presentViewController:selectBackupAlert animated:YES completion:nil];
        
    }
    else{
        
        UIAlertController * restoreBackupAlert=   [UIAlertController
                                                   alertControllerWithTitle:@"Restore Backup"
                                                   message:@"Your device will revert to the selected backup! Please wait for your device to respring."
                                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 //RUN RESTORE SCRIPT
                                 
                                 NSTask *restoreTask = [[NSTask alloc] init];
                                 [restoreTask setLaunchPath:@"/bin/bash"];
                                 [restoreTask setArguments:@[ @"FBRestore", backupNameSelected]];
                                 [restoreTask launch];
                                 
                                 UIAlertController * finishedRestoreAlert=   [UIAlertController
                                                                              alertControllerWithTitle:@"Restoring from backup"
                                                                              message:@"Your device will respring when the process is completed."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                                 [self presentViewController:finishedRestoreAlert animated:YES completion:nil];
                                 
                                 [restoreBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [restoreBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [restoreBackupAlert addAction:cancel];
        [restoreBackupAlert addAction:ok];
        
        [self presentViewController:restoreBackupAlert animated:YES completion:nil];
    }
}

- (IBAction)updateBackup:(id)sender {
    
    if (backupNameSelected == nil){
        
        UIAlertController * updateBackupAlert=   [UIAlertController
                                                  alertControllerWithTitle:@"Select a Backup!"
                                                  message:@"Scroll through the list then let it settle on an item to select the backup."
                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [updateBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [updateBackupAlert addAction:ok];
        
        [self presentViewController:updateBackupAlert animated:YES completion:nil];
        
    }
    else{
        
        UIAlertController * updateBackupAlert=   [UIAlertController
                                                  alertControllerWithTitle:@"Update Backup"
                                                  message:@"The selected backup will be overwritten! Please wait until the completion pop-up appears"
                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 
                                 [updateBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 NSTask *deleteTask = [[NSTask alloc] init];
                                 [deleteTask setLaunchPath:@"/bin/bash"];
                                 [deleteTask setArguments:@[ @"FBDelete", backupNameSelected]];
                                 [deleteTask launch];
                                 [deleteTask waitUntilExit];
                                 
                                 NSTask *createTask = [[NSTask alloc] init];
                                 [createTask setLaunchPath:@"/bin/bash"];
                                 [createTask setArguments:@[ @"FBCreate", backupNameSelected]];
                                 [createTask launch];
                                 [createTask waitUntilExit];
                                 
                                 UIAlertController * finishedUpdateAlert=   [UIAlertController
                                                                             alertControllerWithTitle:@"Backup Update Completed"
                                                                             message:@"The backup has been successfully updated"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                 
                                 UIAlertAction* ok = [UIAlertAction
                                                      actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                                      {
                                                          
                                                          _backupFolderArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/FlashBack/Backups/" error:nil];
                                                          [self->selectedBackupPickerView reloadAllComponents];
                                                          
                                                          [finishedUpdateAlert dismissViewControllerAnimated:YES completion:nil];
                                                          
                                                      }];
                                 [finishedUpdateAlert addAction:ok];
                                 
                                 [self presentViewController:finishedUpdateAlert animated:YES completion:nil];
                                 
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [updateBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [updateBackupAlert addAction:cancel];
        [updateBackupAlert addAction:ok];
        
        [self presentViewController:updateBackupAlert animated:YES completion:nil];
    }
}

- (IBAction)packageBackup:(id)sender {
    
    if (trial == NO){
        
        if (backupNameSelected == nil){
            
            UIAlertController * selectBackupAlert=   [UIAlertController
                                                      alertControllerWithTitle:@"Select a Backup!"
                                                      message:@"Scroll through the list then let it settle on an item to select the backup."
                                                      preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"ok"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [selectBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            [selectBackupAlert addAction:ok];
            
            [self presentViewController:selectBackupAlert animated:YES completion:nil];
            
        }
        else{
            
            UIAlertController * packageBackupAlert=   [UIAlertController
                                                       alertControllerWithTitle:@"Package Backup"
                                                       message:@"This will package the selected backup to a DEB file."
                                                       preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     UIAlertController * packageBackupWait=   [UIAlertController
                                                                               alertControllerWithTitle:@"Backup DEB"
                                                                               message:@"The backup is being created. Please Wait. This dialogue will will be dismissed when finished. The  DEB can be found in [/User/Documents/FlashBackDEBs]"
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                     
                                     [packageBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                     
                                     [self presentViewController:packageBackupWait animated:YES completion:nil];
                                     
                                     
                                     NSTask *packageTask = [[NSTask alloc] init];
                                     [packageTask setLaunchPath:@"/bin/bash"];
                                     [packageTask setArguments:@[ @"FBPackage", backupNameSelected]];
                                     [packageTask launch];
                                     [packageTask waitUntilExit];
                                     
                                     
                                     [packageBackupWait dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [packageBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            [packageBackupAlert addAction:cancel];
            [packageBackupAlert addAction:ok];
            
            [self presentViewController:packageBackupAlert animated:YES completion:nil];
        }
    }
    
    else{
        
        UIAlertController * noBackupDEBAlert =   [UIAlertController
                                                    alertControllerWithTitle:@"Creating DEBs is only available in the full version"
                                                    message:@"The free trial of FlashBack doesn't allow backing up setups to DEBs. Purchase the full version on PackIX for $1.50 for this!"
                                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [noBackupDEBAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [noBackupDEBAlert addAction:ok];
        
        [self presentViewController:noBackupDEBAlert animated:YES completion:nil];
        
    }
}

- (IBAction)helpMenu:(id)sender {
    
    UIAlertController * tutorialAlert=   [UIAlertController
                                          alertControllerWithTitle:@"Help"
                                          message:@"Create Backup: This will prompt you to enter a name for the backup which will be displayed in the box above.\n\nRestore: This will revert your settings, wallpaper, and Icon Layout to the selected setup.\n\nUpdate: This will overwrite the selected backup to cleanly update it.\n\nPackage: This will generate a package in DEB format for you to share or back up for later, including installed tweaks.\n\nDelete: This will delete the selected backup. These backups cannot be recovered!"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"ok"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [tutorialAlert dismissViewControllerAnimated:YES completion:nil];
                             
                             
                             UIAlertController * infoAlert=   [UIAlertController
                                                               alertControllerWithTitle:@"Known issues"
                                                               message:@"\nFor bug reports, please contact me via Twitter or the email available in the next pop-up dialogue.\n\nCredit for the DRM goes to @kushdabush on twitter"
                                                               preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction* okay = [UIAlertAction
                                                    actionWithTitle:@"ok"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                                                    {
                                                        [infoAlert dismissViewControllerAnimated:YES completion:nil];
                                                        
                                                        
                                                        UIAlertController * contactAlert=   [UIAlertController
                                                                                             alertControllerWithTitle:@"Contact Me"
                                                                                             message:@"\nYou can contact my via Twitter or Email\n\n@micahpgomez\n\nmpg13@micahpgomez.dev\n\nhttps://www.micahpgomez.dev"
                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                                        
                                                        UIAlertAction* okey = [UIAlertAction
                                                                               actionWithTitle:@"ok"
                                                                               style:UIAlertActionStyleDefault
                                                                               handler:^(UIAlertAction * action)
                                                                               {
                                                                                   [contactAlert dismissViewControllerAnimated:YES completion:nil];
                                                                                   
                                                                               }];
                                                        
                                                        [contactAlert addAction:okey];
                                                        
                                                        [self presentViewController:contactAlert animated:YES completion:nil];
                                                        
                                                        
                                                        
                                                    }];
                             
                             [infoAlert addAction:okay];
                             
                             [self presentViewController:infoAlert animated:YES completion:nil];
                             
                             
                             
                         }];
    
    [tutorialAlert addAction:ok];
    
    [self presentViewController:tutorialAlert animated:YES completion:nil];
    
}

- (IBAction)deleteBackup:(id)sender {
    
    if (backupNameSelected == nil){
        
        UIAlertController * selectBackupAlert=   [UIAlertController
                                                  alertControllerWithTitle:@"Select a Backup!"
                                                  message:@"Scroll through the list then let it settle on an item to select the backup."
                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [selectBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [selectBackupAlert addAction:ok];
        
        [self presentViewController:selectBackupAlert animated:YES completion:nil];
        
    }
    
    UIAlertController * deleteBackupAlert=   [UIAlertController
                                              alertControllerWithTitle:@"Delete Backup"
                                              message:@"The selected backup will be deleted!"
                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             NSTask *deleteTask = [[NSTask alloc] init];
                             [deleteTask setLaunchPath:@"/bin/bash"];
                             [deleteTask setArguments:@[ @"FBDelete", backupNameSelected]];
                             [deleteTask launch];
                             [deleteTask waitUntilExit];
                             
                             UIAlertController * deleteFinishedAlert=   [UIAlertController
                                                                         alertControllerWithTitle:@"Backup Deleted"
                                                                         message:@"The backup has been deleted successfully"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction* okey = [UIAlertAction
                                                    actionWithTitle:@"ok"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                                                    {
                                                        
                                                        _backupFolderArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/FlashBack/Backups/" error:nil];
                                                        [self->selectedBackupPickerView reloadAllComponents];
                                                        
                                                        [deleteFinishedAlert dismissViewControllerAnimated:YES completion:nil];
                                                        
                                                    }];
                             
                             [deleteFinishedAlert addAction:okey];
                             
                             [self presentViewController:deleteFinishedAlert animated:YES completion:nil];
                             
                             
                             
                             [deleteBackupAlert dismissViewControllerAnimated:YES completion:nil];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 [deleteBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [deleteBackupAlert addAction:cancel];
    [deleteBackupAlert addAction:ok];
    
    [self presentViewController:deleteBackupAlert animated:YES completion:nil];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    selectedBackupPickerView.delegate=self;
    selectedBackupPickerView.dataSource=self;
    
    // MARK: List of Backups is found and added to this array
    //_backupFolderArray = @[@"one",@"two",@"three"];
    _backupFolderArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/FlashBack/Backups/" error:nil];
    
    // MARK: DRM From @Kushdabush, commenting out for testing
    //pulled from https://github.com/DomienF/kushy-drm/blob/master/Tweak.xm
    /*
    
    UIAlertController * failedDRMAlert=   [UIAlertController
                                           alertControllerWithTitle:@"FlashBack appears to be pirated :("
                                           message:@"Please support small devs and purchase software. If you're unable to, please contact me, I'm happy to work things out! If you want to test it out, check out the trial version!"
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* failedDRMOk = [UIAlertAction
                                  actionWithTitle:@"ok"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [failedDRMAlert dismissViewControllerAnimated:YES completion:nil];
                                      //exit(0);
                                  }];
    
    UIAlertController * trialNoticeAlert=   [UIAlertController
                                             alertControllerWithTitle:@"Trial Notice"
                                             message:@"Thanks for checking out FlashBack! This trial allows you to give FlashBack a test run allowing for one backup. You can use that backup as a checkpoint to revert to after making changes."
                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* trialOk = [UIAlertAction
                              actionWithTitle:@"ok"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [trialNoticeAlert dismissViewControllerAnimated:YES completion:nil];
                              }];
    
    [failedDRMAlert addAction:failedDRMOk];
    [trialNoticeAlert addAction:trialOk];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.mpg13.flashback.list"]){
        NSLog(@"FlashBack DRM Passed");
        trial = NO;
    }
    else{
        if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.mpg13.flashbackfree.list"]){
            NSLog(@"FlashBack Trial Mode");
            trial = YES;
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self presentViewController:trialNoticeAlert animated:YES completion:nil];
            });
        }
        else{
            NSLog(@"DRM failed");
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self presentViewController:failedDRMAlert animated:YES completion:nil];
            });
        }
    }
    */
    
        trial = NO;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (_backupFolderArray == nil){
        
        UIAlertController * emptyArrayAlert=   [UIAlertController
                                                alertControllerWithTitle:@"Let's start by making a backup!"
                                                message:@"Press 'Create Backup' to get started!"
                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [emptyArrayAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [emptyArrayAlert addAction:ok];
        
        [self presentViewController:emptyArrayAlert animated:YES completion:nil];
        
    }
    else{
        backupNameSelected = [_backupFolderArray objectAtIndex:row];
        selectedBackupText.text=backupNameSelected;
        
        selectedBackupURL = [NSMutableString stringWithString: @"/Library/FlashBack/Backups/"];
        [selectedBackupURL appendString: backupNameSelected];
        
        selectedBackupImageURL=selectedBackupURL;
        
        [selectedBackupImageURL appendString: @"/SBFolder/LockBackgroundThumbnail.jpg"];
        NSLog(@"%@", selectedBackupImageURL);
        NSURL *url = [NSURL fileURLWithPath:selectedBackupImageURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        selectedBackupImage.image = [UIImage imageWithData:data];
        
        NSLog(@"%@", backupNameSelected);
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _backupFolderArray.count;
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return _backupFolderArray[row];
    
}
@end

