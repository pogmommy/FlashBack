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


@interface ViewController ()

@end

NSArray *_backupFolderArray;
NSString *_backupDirectory;
NSMutableString *selectedBackupImageURL;


@implementation ViewController


- (IBAction)createBackup:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter the Backup Name" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Backup Name";
        textField.secureTextEntry = NO;
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Backup name is :%@", [[alertController textFields][0] text]);
        NSString *newBackupName=[[alertController textFields][0] text];
        
        if([[[alertController textFields][0] text] isEqual:@""]){
            NSLog(@"empty backup name!");
        }
        else{
            NSLog(@"Backup name is good!");
            
            /*NSString *content = @"Put this in a file please.";
            NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
            [[NSFileManager defaultManager] createFileAtPath:@"/Applications/test.txt"
                                                    contents:fileContents
                                                  attributes:nil];*/
            
            NSLog(@"Running NSTask");
            
            NSTask *task = [[NSTask alloc] init];
            [task setLaunchPath:@"/usr/bin/bash"];
            [task setArguments:@[ @"_FBCreate", newBackupName]];
            [task launch];
            
            NSLog(@"Running NSTask failed, running posix_spawn");
            
            /*pid_t pid;
            int status;
            const char* args[] = {"killall", "backboardd", NULL, NULL};
            posix_spawn(&pid, "/bin/bash", NULL, NULL, (char* const*)args, NULL);
            waitpid(pid, &status, WEXITED);*/
            
        }
        
        
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}



- (IBAction)restoreBackup:(id)sender {

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Restore Backup"
                                  message:@"Your device will revert to the selected backup!"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)updateBackup:(id)sender {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Update Backup"
                                  message:@"The selected backup will be overwritten!"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (IBAction)deleteBackup:(id)sender {

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Delete BAckup"
                                  message:@"The selected backup will be deleted!"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedBackupText.text=@"Select a Backup";
    //selectedBackupImage.backgroundColor=[UIColor grayColor];
    
    selectedBackupPickerView.delegate=self;
    selectedBackupPickerView.dataSource=self;
    
    //_backupFolderArray = @[@"one",@"two",@"three"];
    _backupFolderArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/FlashBack/Backups/" error:nil];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSString *backupNameSelected = [_backupFolderArray objectAtIndex:row];
    selectedBackupText.text=backupNameSelected;
    
    selectedBackupImageURL = [NSMutableString stringWithString: @"/Library/FlashBack/Backups/"];
    [selectedBackupImageURL appendString: backupNameSelected];
    [selectedBackupImageURL appendString: @"/bgimage.png"];
    NSLog(@"%@", selectedBackupImageURL);
    
    selectedBackupImage.image=[UIImage imageNamed:selectedBackupImageURL];
    
    NSLog(@"%@", backupNameSelected);
    
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

