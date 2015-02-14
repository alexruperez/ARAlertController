//
//  ARAlertController.m
//  ARAlertController
//
//  Created by alexruperez on 14/2/15.
//  Copyright (c) 2015 alexruperez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ARAlertController.h"

@interface ARAlertAction ()

@property (nonatomic, copy) ARAlertActionHandler handler;

@end

@implementation ARAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(ARAlertActionStyle)style handler:(ARAlertActionHandler)handler
{
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(ARAlertActionStyle)style handler:(ARAlertActionHandler)handler
{
    self = [super init];
    
    if (self)
    {
        _title = title;
        _style = style;
        _handler = handler;
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[ARAlertAction allocWithZone:zone] initWithTitle:self.title.copy style:self.style handler:self.handler];
}

@end

@interface ARAlertController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIViewController *alertController;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIActionSheet *actionSheet;

@property (nonatomic, strong) NSMutableArray *mutableActions;
@property (nonatomic, strong) NSMutableArray *mutableTextFields;
@property (nonatomic, strong) NSMutableDictionary *configurationHandlers;

@property (nonatomic, copy) void (^presentCompletion)(void);
@property (nonatomic, copy) void (^dismissCompletion)(void);

@end

@implementation ARAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(ARAlertControllerStyle)preferredStyle
{
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(ARAlertControllerStyle)preferredStyle
{
    self = [super init];
    
    if (self)
    {
        _title = title;
        _message = message;
        _preferredStyle = preferredStyle;
        
        _mutableActions = NSMutableArray.new;
        _mutableTextFields = NSMutableArray.new;
        _configurationHandlers = NSMutableDictionary.new;
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    ARAlertController *alertController = [[ARAlertController allocWithZone:zone] initWithTitle:self.title.copy message:self.message.copy preferredStyle:self.preferredStyle];
    
    for (ARAlertAction *alertAction in self.actions)
    {
        [alertController addAction:alertAction.copy];
    }
    
    for (UITextField *textField in self.textFields)
    {
        [alertController addTextFieldWithConfigurationHandler:self.configurationHandlers[[NSString stringWithFormat:@"%ld", (unsigned long)textField.hash]]];
    }
    
    alertController.alertController = self.alertController.copy;
    alertController.alertView = self.alertView.copy;
    alertController.actionSheet = self.actionSheet.copy;
    
    alertController.presentCompletion = self.presentCompletion;
    alertController.dismissCompletion = self.dismissCompletion;
    
    return alertController;
}

- (NSArray *)actions
{
    return self.mutableActions.copy;
}

- (NSArray *)textFields
{
    return self.mutableTextFields.copy;
}

- (void)addAction:(ARAlertAction *)action
{
    NSObject *alertAction;
    
    if (NSClassFromString(@"UIAlertAction"))
    {
        alertAction = [UIAlertAction actionWithTitle:action.title style:(UIAlertActionStyle)action.style handler:^(UIAlertAction *alertAction) {
            if (action.handler)
            {
                action.handler(action);
            }
        }];
    }
    else
    {
        alertAction = action;
    }
    
    [self.mutableActions addObject:alertAction];
}

- (void)addTextFieldWithConfigurationHandler:(ARAlertControllerConfigurationHandler)configurationHandler
{
    NSAssert(self.preferredStyle == ARAlertControllerStyleAlert, @"Text fields can only be added to an alert controller of style ARAlertControllerStyleAlert");
    
    UITextField *textField = UITextField.new;
    [self.mutableTextFields addObject:textField];
    
    if (configurationHandler)
    {
        [self.configurationHandlers setObject:configurationHandler forKey:[NSString stringWithFormat:@"%ld", (unsigned long)textField.hash]];
    }
}

- (void)presentInViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (NSClassFromString(@"UIAlertController"))
    {
        self.alertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:(UIAlertControllerStyle)self.preferredStyle];
        UIAlertController *alertController = (UIAlertController *)self.alertController;
        
        for (UIAlertAction *action in self.actions)
        {
            [alertController addAction:action];
        }
        
        for (UITextField *textFieldSaved in self.textFields)
        {
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                NSString *textFieldSavedHash = [NSString stringWithFormat:@"%ld", (unsigned long)textFieldSaved.hash];
                ARAlertControllerConfigurationHandler handler = self.configurationHandlers[textFieldSavedHash];
                
                if (handler)
                {
                    handler(textField);
                    
                    [self.configurationHandlers removeObjectForKey:textFieldSavedHash];
                    
                    [self.configurationHandlers setObject:handler forKey:[NSString stringWithFormat:@"%ld", (unsigned long)textField.hash]];
                }
                
                [self.mutableTextFields replaceObjectAtIndex:[self.mutableTextFields indexOfObject:textFieldSaved] withObject:textField];
            }];
        }
        
        [viewController presentViewController:alertController animated:animated completion:completion];
    }
    else
    {
        if (self.preferredStyle == ARAlertControllerStyleAlert)
        {
            self.alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            
            for (ARAlertAction *action in self.actions)
            {
                [self.alertView addButtonWithTitle:action.title];
                
                if (self.alertView.cancelButtonIndex == -1 && action.style == ARAlertActionStyleCancel)
                {
                    self.alertView.cancelButtonIndex = self.alertView.numberOfButtons-1;
                }
                
                action.enabled = YES;
            }
            
            if (self.textFields.count == 1)
            {
                UITextField *textFieldSaved = self.textFields[0];
                
                self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                
                UITextField *textField = [self.alertView textFieldAtIndex:0];
                
                NSString *textFieldSavedHash = [NSString stringWithFormat:@"%ld", (unsigned long)textFieldSaved.hash];
                ARAlertControllerConfigurationHandler handler = self.configurationHandlers[textFieldSavedHash];
                
                if (handler)
                {
                    handler(textField);
                    
                    [self.configurationHandlers removeObjectForKey:textFieldSavedHash];
                    
                    [self.configurationHandlers setObject:handler forKey:[NSString stringWithFormat:@"%ld", (unsigned long)textField.hash]];
                }
                
                [self.mutableTextFields replaceObjectAtIndex:[self.mutableTextFields indexOfObject:textFieldSaved] withObject:textField];
            }
            else if (self.textFields.count > 1)
            {
                UITextField *firstTextFieldSaved = self.textFields[0];
                UITextField *secondTextFieldSaved = self.textFields[1];
                
                self.alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
                
                UITextField *firstTextField = [self.alertView textFieldAtIndex:0];
                UITextField *secondTextField = [self.alertView textFieldAtIndex:1];
                
                firstTextField.placeholder = nil;
                secondTextField.placeholder = nil;
                secondTextField.secureTextEntry = NO;
                
                NSString *firstTextFieldSavedHash = [NSString stringWithFormat:@"%ld", (unsigned long)firstTextFieldSaved.hash];
                NSString *secondTextFieldSavedHash = [NSString stringWithFormat:@"%ld", (unsigned long)secondTextFieldSaved.hash];
                
                ARAlertControllerConfigurationHandler firstHandler = self.configurationHandlers[firstTextFieldSavedHash];
                ARAlertControllerConfigurationHandler secondHandler = self.configurationHandlers[secondTextFieldSavedHash];
                
                if (firstHandler)
                {
                    firstHandler(firstTextField);
                    
                    [self.configurationHandlers removeObjectForKey:firstTextFieldSavedHash];
                    
                    [self.configurationHandlers setObject:firstHandler forKey:[NSString stringWithFormat:@"%ld", (unsigned long)firstTextField.hash]];
                }
                
                if (secondHandler)
                {
                    secondHandler(secondTextField);
                    
                    [self.configurationHandlers removeObjectForKey:secondTextFieldSavedHash];
                    
                    [self.configurationHandlers setObject:secondHandler forKey:[NSString stringWithFormat:@"%ld", (unsigned long)secondTextField.hash]];
                }
                
                [self.mutableTextFields replaceObjectAtIndex:[self.mutableTextFields indexOfObject:firstTextFieldSaved] withObject:firstTextField];
                [self.mutableTextFields replaceObjectAtIndex:[self.mutableTextFields indexOfObject:secondTextFieldSaved] withObject:secondTextField];
            }
            
            [self.alertView show];
        }
        else if (self.preferredStyle == ARAlertControllerStyleActionSheet)
        {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:self.title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            
            for (ARAlertAction *action in self.actions)
            {
                [self.actionSheet addButtonWithTitle:action.title];
                
                if (self.actionSheet.cancelButtonIndex == -1 && action.style == ARAlertActionStyleCancel)
                {
                    self.actionSheet.cancelButtonIndex = self.actionSheet.numberOfButtons-1;
                }
                
                if (self.actionSheet.destructiveButtonIndex == -1 && action.style == ARAlertActionStyleDestructive)
                {
                    self.actionSheet.destructiveButtonIndex = self.actionSheet.numberOfButtons-1;
                }
                
                action.enabled = YES;
            }
            
            [self.actionSheet showInView:viewController.view];
        }
        
        self.presentCompletion = completion;
        self.dismissCompletion = nil;
    }
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (self.alertController)
    {
        [self.alertController dismissViewControllerAnimated:animated completion:completion];
    }
    else
    {
        if (self.alertView)
        {
            [self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:animated];
        }
        else if (self.actionSheet)
        {
            [self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:animated];
        }
        
        self.dismissCompletion = completion;
        self.presentCompletion = nil;
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (self.presentCompletion)
    {
        self.presentCompletion();
    }
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    if (self.presentCompletion)
    {
        self.presentCompletion();
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ARAlertAction *action = self.actions[buttonIndex];
    if (action.handler)
    {
        action.handler(action);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ARAlertAction *action = self.actions[buttonIndex];
    if (action.handler)
    {
        action.handler(action);
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.dismissCompletion)
    {
        self.dismissCompletion();
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.dismissCompletion)
    {
        self.dismissCompletion();
    }
}

@end
