//
//  ViewController.m
//  ARAlertControllerExample
//
//  Created by alexruperez on 14/2/15.
//  Copyright (c) 2015 alexruperez. All rights reserved.
//

#import "ViewController.h"

#import <ARAlertController/ARAlertController.h>


@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showAlert];
}

- (IBAction)showAlert
{
    NSString *versionString = UIDevice.currentDevice.systemVersion;
    
    ARAlertController* alert = [ARAlertController alertControllerWithTitle:@"My Alert"
                                                                   message:[NSString stringWithFormat:@"This is an alert on iOS %@", versionString]
                                                            preferredStyle:ARAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"First";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Second";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Third";
    }];
    
    ARAlertAction* defaultAction = [ARAlertAction actionWithTitle:@"OK" style:ARAlertActionStyleDefault
                                                          handler:^(ARAlertAction *action) {
                                                              [self logTextFields:alert.textFields action:action];
                                                          }];
    
    [alert addAction:defaultAction];
    
    ARAlertAction* cancelAction = [ARAlertAction actionWithTitle:@"Cancel" style:ARAlertActionStyleCancel
                                                         handler:^(ARAlertAction *action) {
                                                             [self logTextFields:alert.textFields action:action];
                                                         }];
    
    [alert addAction:cancelAction];
    
    ARAlertAction* destroyAction = [ARAlertAction actionWithTitle:@"Destroy" style:ARAlertActionStyleDestructive
                                                          handler:^(ARAlertAction *action) {
                                                              [self logTextFields:alert.textFields action:action];
                                                          }];
    
    [alert addAction:destroyAction];
    
    ARAlertAction* destroyActionExtra = [ARAlertAction actionWithTitle:@"Destroy Extra" style:ARAlertActionStyleDestructive
                                                               handler:^(ARAlertAction *action) {
                                                                   [self logTextFields:alert.textFields action:action];
                                                               }];
    
    [alert addAction:destroyActionExtra];
    
    [alert presentInViewController:self animated:YES completion:nil];
}

- (IBAction)showActionSheet
{
    NSString *versionString = UIDevice.currentDevice.systemVersion;
    
    ARAlertController* actionSheet = [ARAlertController alertControllerWithTitle:@"My Alert"
                                                                   message:[NSString stringWithFormat:@"This is an alert on iOS %@", versionString]
                                                            preferredStyle:ARAlertControllerStyleActionSheet];
    
    ARAlertAction* defaultAction = [ARAlertAction actionWithTitle:@"OK" style:ARAlertActionStyleDefault
                                                          handler:^(ARAlertAction *action) {
                                                              [self logTextFields:actionSheet.textFields action:action];
                                                          }];
    
    [actionSheet addAction:defaultAction];
    
    ARAlertAction* cancelAction = [ARAlertAction actionWithTitle:@"Cancel" style:ARAlertActionStyleCancel
                                                         handler:^(ARAlertAction *action) {
                                                             [self logTextFields:actionSheet.textFields action:action];
                                                         }];
    
    [actionSheet addAction:cancelAction];
    
    ARAlertAction* destroyAction = [ARAlertAction actionWithTitle:@"Destroy" style:ARAlertActionStyleDestructive
                                                          handler:^(ARAlertAction *action) {
                                                              [self logTextFields:actionSheet.textFields action:action];
                                                          }];
    
    [actionSheet addAction:destroyAction];
    
    ARAlertAction* destroyActionExtra = [ARAlertAction actionWithTitle:@"Destroy Extra" style:ARAlertActionStyleDestructive
                                                          handler:^(ARAlertAction *action) {
                                                              [self logTextFields:actionSheet.textFields action:action];
                                                          }];
    
    [actionSheet addAction:destroyActionExtra];
    
    [actionSheet presentInViewController:self animated:YES completion:nil];
}

- (void)logTextFields:(NSArray *)textFields action:(ARAlertAction *)action
{
    NSLog(@"=========================");
    NSLog(@"Action Title: %@", action.title);
    for (UITextField *textField in textFields)
    {
        NSLog(@"%@ UITextField Text: %@", textField.placeholder, textField.text.length ? textField.text : 0);
    }
    NSLog(@"=========================");
}

@end
