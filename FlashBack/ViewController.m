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
#import "UIBackgroundStyle.h"
#import "UIAlertAction+Common.h"
#import "UINavigationItem+LargeAccessoryView.h"
#import "globalVars.h"


NSArray *_backupFolderArray;
NSString *_backupDirectory;
NSMutableString *selectedBackupImageURL;
NSMutableString *selectedBackupURL;
NSString *backupNameSelected;

@implementation ViewController

- (void)createBackup:(id)sender {

        UIAlertController *createBackupAlert = [UIAlertController alertControllerWithTitle:@"Enter the Backup Name" message:@"Please do not use special symbols. Use only letters and numbers, no spaces." preferredStyle:UIAlertControllerStyleAlert];
        [createBackupAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Backup Name";
            textField.secureTextEntry = NO;
        }];
        UIAlertAction *confirmAction = [UIAlertAction okActionWithHandler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Backup name is :%@", [[createBackupAlert textFields][0] text]);
            NSString *newBackupName=[[createBackupAlert textFields][0] text];
            
            if([[[createBackupAlert textFields][0] text] isEqual:@""]){
                NSLog(@"Empty backup name!");
            }
            else{
                NSLog(@"Backup name is good!");
                
                NSLog(@"Running NSTask");
                
                NSTask *createTask = [[NSTask alloc] init];
                [createTask setLaunchPath:@"/bin/bash"];
                [createTask setArguments:@[ @"FBCreate", newBackupName, stringTweaksEnabled, stringIconsEnabled, stringWallpaperEnabled]];
                [createTask launch];
                [createTask waitUntilExit];
                
                UIAlertController * finishedCreateAlert=   [UIAlertController
                                                            alertControllerWithTitle:@"Backup Creation Completed"
                                                            message:@"The backup has been successfully created!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction okActionWithHandler:^(UIAlertAction * action)
                                     {
                                         
                                         _backupFolderArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Library/FlashBack/Backups/" error:nil];
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
        [createBackupAlert addAction:[UIAlertAction cancelAction]];
        [self presentViewController:createBackupAlert animated:YES completion:nil];
}

- (IBAction)restoreBackup:(id)sender {
    
    if (backupNameSelected == nil){
        
        UIAlertController * selectBackupAlert=   [UIAlertController
                                                  alertControllerWithTitle:@"Select a Backup!"
                                                  message:@"Scroll through the list then let it settle on an item to select the backup."
                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        [selectBackupAlert addAction:[UIAlertAction okAction]];
        
        [self presentViewController:selectBackupAlert animated:YES completion:nil];
        
    }
    else{
        
        UIAlertController * restoreBackupAlert=   [UIAlertController
                                                   alertControllerWithTitle:@"Restore Backup"
                                                   message:@"Your device will revert to the selected backup! Please wait for your device to respring."
                                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction okActionWithHandler:^(UIAlertAction * action)
                             {
                                 
                                 //RUN RESTORE SCRIPT
                                 
                                 NSTask *restoreTask = [[NSTask alloc] init];
                                 [restoreTask setLaunchPath:@"/bin/bash"];
                                 [restoreTask setArguments:@[ @"FBRestore", backupNameSelected, stringTweaksEnabled, stringIconsEnabled, stringWallpaperEnabled]];
                                 [restoreTask launch];
                                 
                                 UIAlertController * finishedRestoreAlert=   [UIAlertController
                                                                              alertControllerWithTitle:@"Restoring from backup"
                                                                              message:@"Your device will respring when the process is completed."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                                 [self presentViewController:finishedRestoreAlert animated:YES completion:nil];
                                 
                                 [restoreBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [restoreBackupAlert addAction:ok];
        [restoreBackupAlert addAction:[UIAlertAction cancelAction]];
        
        [self presentViewController:restoreBackupAlert animated:YES completion:nil];
    }
}

- (IBAction)updateBackup:(id)sender {
    
    if (backupNameSelected == nil){
        
        UIAlertController * updateBackupAlert=   [UIAlertController
                                                  alertControllerWithTitle:@"Select a Backup!"
                                                  message:@"Scroll through the list then let it settle on an item to select the backup."
                                                  preferredStyle:UIAlertControllerStyleAlert];

        [updateBackupAlert addAction:[UIAlertAction okAction]];
        
        [self presentViewController:updateBackupAlert animated:YES completion:nil];
        
    }
    else{
        
        UIAlertController * updateBackupAlert=   [UIAlertController
                                                  alertControllerWithTitle:@"Update Backup"
                                                  message:@"The selected backup will be overwritten! Please wait until the completion pop-up appears"
                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction okActionWithHandler:^(UIAlertAction * action)
                             {
                                 
                                 
                                 [updateBackupAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 NSTask *deleteTask = [[NSTask alloc] init];
                                 [deleteTask setLaunchPath:@"/bin/bash"];
                                 [deleteTask setArguments:@[ @"FBDelete", backupNameSelected]];
                                 [deleteTask launch];
                                 [deleteTask waitUntilExit];
                                 
                                 NSTask *createTask = [[NSTask alloc] init];
                                 [createTask setLaunchPath:@"/bin/bash"];
                                 [createTask setArguments:@[ @"FBCreate", backupNameSelected, stringTweaksEnabled, stringIconsEnabled, stringWallpaperEnabled]];
                                 [createTask launch];
                                 [createTask waitUntilExit];
                                 
                                 UIAlertController * finishedUpdateAlert=   [UIAlertController
                                                                             alertControllerWithTitle:@"Backup Update Completed"
                                                                             message:@"The backup has been successfully updated!"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                 
                                 UIAlertAction* ok = [UIAlertAction okActionWithHandler:^(UIAlertAction * action)
                                                      {
                                                          
                                                          _backupFolderArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Library/FlashBack/Backups/" error:nil];
                                                          [self->selectedBackupPickerView reloadAllComponents];
                                                      }];
                                 [finishedUpdateAlert addAction:ok];
                                 
                                 [self presentViewController:finishedUpdateAlert animated:YES completion:nil];
                                 
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction cancelAction];
        
        [updateBackupAlert addAction:cancel];
        [updateBackupAlert addAction:ok];
        
        [self presentViewController:updateBackupAlert animated:YES completion:nil];
    }
}

- (IBAction)packageBackup:(id)sender {
    
    if (backupNameSelected == nil){
            
            UIAlertController * selectBackupAlert=   [UIAlertController
                                                      alertControllerWithTitle:@"Select a Backup!"
                                                      message:@"Scroll through the list then let it settle on an item to select the backup."
                                                      preferredStyle:UIAlertControllerStyleAlert];
            [selectBackupAlert addAction:[UIAlertAction okAction]];
            
            [self presentViewController:selectBackupAlert animated:YES completion:nil];
            
        }
        else{
            
            UIAlertController * packageBackupAlert=   [UIAlertController
                                                       alertControllerWithTitle:@"Package Backup"
                                                       message:@"This will package the selected backup to a .deb file."
                                                       preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction okActionWithHandler:^(UIAlertAction * action)
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
            UIAlertAction* cancel = [UIAlertAction cancelAction];
            
            [packageBackupAlert addAction:cancel];
            [packageBackupAlert addAction:ok];
            
            [self presentViewController:packageBackupAlert animated:YES completion:nil];
        }
}

- (IBAction)deleteBackup:(id)sender {
    
    if (backupNameSelected == nil){
        
        UIAlertController * selectBackupAlert=   [UIAlertController
                                                  alertControllerWithTitle:@"Select a Backup!"
                                                  message:@"Scroll through the list then let it settle on an item to select the backup."
                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        [selectBackupAlert addAction:[UIAlertAction okAction]];
        
        [self presentViewController:selectBackupAlert animated:YES completion:nil];
        
    }
    
    UIAlertController * deleteBackupAlert=   [UIAlertController
                                              alertControllerWithTitle:@"Delete Backup"
                                              message:@"The selected backup will be deleted!"
                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction okActionWithHandler:^(UIAlertAction * action)
                         {
                             
                             NSTask *deleteTask = [[NSTask alloc] init];
                             [deleteTask setLaunchPath:@"/bin/bash"];
                             [deleteTask setArguments:@[ @"FBDelete", backupNameSelected]];
                             [deleteTask launch];
                             [deleteTask waitUntilExit];
                             
                             UIAlertController * deleteFinishedAlert=   [UIAlertController
                                                                         alertControllerWithTitle:@"Backup Deleted"
                                                                         message:@"The backup has been deleted successfully."
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction* okey = [UIAlertAction okActionWithHandler:^(UIAlertAction * action)
                                                    {
                                                        
                                                        _backupFolderArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Library/FlashBack/Backups/" error:nil];
                                                        [self->selectedBackupPickerView reloadAllComponents];
                                                        
                                                        [deleteFinishedAlert dismissViewControllerAnimated:YES completion:nil];
                                                        
                                                    }];
                             
                             [deleteFinishedAlert addAction:okey];
                             
                             [self presentViewController:deleteFinishedAlert animated:YES completion:nil];
                         }];
    
    [deleteBackupAlert addAction:ok];
    [deleteBackupAlert addAction:[UIAlertAction cancelAction]];
    
    [self presentViewController:deleteBackupAlert animated:YES completion:nil];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    
        return UIStatusBarStyleLightContent;
    }


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        if (self.navigationController.navigationBar.prefersLargeTitles){
            UIButton *createBackupButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [createBackupButton addTarget:self action:@selector(createBackup:) forControlEvents:UIControlEventTouchUpInside];
            [createBackupButton setImage:[UIImage imageNamed:@"create"] forState:UIControlStateNormal];
            createBackupButton.tintColor = [UIColor systemBlueColor];
            self.navigationItem._largeTitleAccessoryView = createBackupButton;
        }
        else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"create"] style:UIBarButtonItemStylePlain target:self action:@selector(createBackup:)];
        }
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"create"] style:UIBarButtonItemStylePlain target:self action:@selector(createBackup:)];
    }

        
    
    // Do any additional setup after loading the view.
    
    selectedBackupPickerView.delegate=self;
    selectedBackupPickerView.dataSource=self;
    
    // MARK: List of Backups is found and added to this array
    //_backupFolderArray = @[@"one",@"two",@"three"];
    _backupFolderArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Library/FlashBack/Backups/" error:nil];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [[selectedBackupPickerView.subviews objectAtIndex:1] setBackgroundColor:[UIColor colorWithWhite:25.f/225.f alpha:0.5]];
    [[selectedBackupPickerView.subviews objectAtIndex:2] setBackgroundColor:[UIColor colorWithWhite:25.f/225.f alpha:0.5]];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_backupFolderArray == nil) return;
    
    backupNameSelected = [_backupFolderArray objectAtIndex:row];
    selectedBackupText.text=backupNameSelected;
    
    selectedBackupURL = [NSMutableString stringWithString: @"/var/mobile/Library/FlashBack/Backups/"];
    [selectedBackupURL appendString: backupNameSelected];
    
    selectedBackupImageURL=selectedBackupURL;
    
    [selectedBackupImageURL appendString: @"/SBFolder/LockBackgroundThumbnail.jpg"];
    NSLog(@"%@", selectedBackupImageURL);
    NSURL *url = [NSURL fileURLWithPath:selectedBackupImageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    selectedBackupImage.image = [UIImage imageWithData:data];
    
    NSLog(@"%@", backupNameSelected);
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _backupFolderArray.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *name = _backupFolderArray[row];
    return [[NSAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}
@end

