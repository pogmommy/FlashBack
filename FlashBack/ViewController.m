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

NSArray *_backupFolderArray;
NSString *_backupDirectory;
NSMutableString *selectedBackupImageURL;
NSMutableString *selectedBackupURL;
NSString *backupNameSelected;
int itFuckingCounts = 0;

//CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

@implementation ViewController


- (IBAction)secretButton:(id)sender {
    
    itFuckingCounts++;
    
    if (itFuckingCounts==13) {
    
    UIAlertController * secretButtonAlert=   [UIAlertController
                                                alertControllerWithTitle:@"Secret found!"
                                                message:@"Thanks for supporting FlashBack, and congratulations on finding the secret button!"
                                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@":)"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             NSURL *myPicURL = [NSURL fileURLWithPath:@"/Library/FlashBack/.mg.png"];
                             NSLog(@"%@", myPicURL);
                             NSData *myPicData = [NSData dataWithContentsOfURL:myPicURL];
                             selectedBackupImage.image = [UIImage imageWithData:myPicData];
                             
                             [secretButtonAlert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [secretButtonAlert addAction:ok];
    
    [self presentViewController:secretButtonAlert animated:YES completion:nil];
    
    }
}



- (IBAction)createBackup:(id)sender {
    
    UIAlertController *createBackupAlert = [UIAlertController alertControllerWithTitle:@"Enter the Backup Name" message:@"Please do not use special symbols. Use only letters and numbers, no spaces." preferredStyle:UIAlertControllerStyleAlert];
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
                             
                             //RUN RESTORE SCRIPT
                             
                             [packageBackupAlert dismissViewControllerAnimated:YES completion:nil];
                             
                             NSTask *packageTask = [[NSTask alloc] init];
                             [packageTask setLaunchPath:@"/bin/bash"];
                             [packageTask setArguments:@[ @"FBPackage", backupNameSelected]];
                             [packageTask launch];
                             [packageTask waitUntilExit];
                             
                             UIAlertController * finishedPackageAlert=   [UIAlertController
                                                                          alertControllerWithTitle:@"Packaging Complete"
                                                                          message:@"The package can be found in [/User/Documents/FlashBackDEBs/]."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                             
                             
                             
                             UIAlertAction* ok = [UIAlertAction
                                                  actionWithTitle:@"ok"
                                                  style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                                                  {
                                                      [finishedPackageAlert dismissViewControllerAnimated:YES completion:nil];
                                                      
                                                  }];
                             
                             [finishedPackageAlert addAction:ok];
                             
                             [self presentViewController:finishedPackageAlert animated:YES completion:nil];
                             
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
                                                               message:@"\nScrolling through the picker view with no backups will crash the app.\n\nSometimes, wallpapers are incorrectly applied after restoring a backup\n\nFor bug reports, please contact me via Twitter or the email available in the next pop-up dialogue."
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
    
    //_backupFolderArray = @[@"one",@"two",@"three"];
    _backupFolderArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/FlashBack/Backups/" error:nil];
    NSLog(@"%d", itFuckingCounts);
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    //NEED TO FIGURE OUT HOW TO CHECK FOR EMPTY LIST
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
    //[selectedBackupImageURL appendString: @"/SBFolder/LockBackground.cpbitmap"];
    NSLog(@"%@", selectedBackupImageURL);
    NSURL *url = [NSURL fileURLWithPath:selectedBackupImageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    /*NSData *homeData = [NSData dataWithContentsOfFile:selectedBackupImageURL];
    CFArrayRef homeArrayRef = CPBitmapCreateImagesFromData((__bridge CFDataRef)homeData, NULL, 1, NULL);
    NSArray *homeArray = (__bridge NSArray*)homeArrayRef;
    UIImage *homeWallpaper = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef)(homeArray[0])];*/
        
    selectedBackupImage.image = [UIImage imageWithData:data];
    //selectedBackupImage.image = [UIImage imageWithContentsOfCPBitmapFile:selectedBackupImageURL flags:kNilOptions];
        
    
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

