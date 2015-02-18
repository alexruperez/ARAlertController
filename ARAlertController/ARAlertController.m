//
//  ARAlertController.m
//  ARAlertController
//
//  Created by alexruperez on 14/2/15.
//  Copyright (c) 2015 alexruperez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ARAlertController.h"


#pragma mark - ARAlertControllerStorage

@interface ARAlertControllerStorage : NSObject

+ (instancetype)sharedStorage;

@property (strong, nonatomic) NSMutableArray *alertControllers;

@end


@implementation ARAlertControllerStorage

#pragma mark - Initializers

+ (instancetype)sharedStorage
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = self.new;
    });
    
    return sharedInstance;
}

#pragma mark - Properties

- (NSMutableArray *)alertControllers
{
    if (!_alertControllers)
    {
        _alertControllers = NSMutableArray.new;
    }
    
    return _alertControllers;
}

@end


#pragma mark - ARAlertAction

@interface ARAlertAction ()

@property (nonatomic, copy) ARAlertActionHandler handler;

@end


@implementation ARAlertAction

#pragma mark - Initializers

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

#pragma mark - Helpers

+ (instancetype)actionWithTitle:(NSString *)title style:(ARAlertActionStyle)style
{
    return [self actionWithTitle:title style:style handler:nil];
}

+ (instancetype)defaultActionWithTitle:(NSString *)title handler:(ARAlertActionHandler)handler
{
    return [self actionWithTitle:title style:ARAlertActionStyleDefault handler:handler];
}

+ (instancetype)cancelActionWithTitle:(NSString *)title handler:(ARAlertActionHandler)handler
{
    return [self actionWithTitle:title style:ARAlertActionStyleCancel handler:handler];
}

+ (instancetype)destructiveActionWithTitle:(NSString *)title handler:(ARAlertActionHandler)handler
{
    return [self actionWithTitle:title style:ARAlertActionStyleDestructive handler:handler];
}

+ (instancetype)defaultActionWithTitle:(NSString *)title
{
    return [self defaultActionWithTitle:title handler:nil];
}

+ (instancetype)cancelActionWithTitle:(NSString *)title
{
    return [self cancelActionWithTitle:title handler:nil];
}

+ (instancetype)destructiveActionWithTitle:(NSString *)title
{
    return [self destructiveActionWithTitle:title handler:nil];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[ARAlertAction allocWithZone:zone] initWithTitle:self.title.copy style:self.style handler:self.handler];
}

@end


#pragma mark - ARAlertController

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

#pragma mark - Initializers

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

#pragma mark - Helpers

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(ARAlertControllerStyle)preferredStyle actions:(NSArray *)actions
{
    ARAlertController *alertController = [self alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    for (ARAlertAction *alertAction in actions)
    {
        if ([alertAction isKindOfClass:ARAlertAction.class])
        {
            [alertController addAction:alertAction];
        }
    }
    
    return alertController;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(ARAlertControllerStyle)preferredStyle actions:(NSArray *)actions textFieldConfigurationHandlers:(NSArray *)configurationHandlers
{
    ARAlertController *alertController = [self alertControllerWithTitle:title message:message preferredStyle:preferredStyle actions:actions];
    
    for (ARAlertControllerConfigurationHandler configurationHandler in configurationHandlers)
    {
        [alertController addTextFieldWithConfigurationHandler:configurationHandler];
    }
    
    return alertController;
}

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message
{
    return [self actionSheetWithTitle:title message:message actions:nil];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions
{
    return [self actionSheetWithTitle:title message:message actions:actions textFieldConfigurationHandlers:nil];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions textFieldConfigurationHandlers:(NSArray *)configurationHandlers
{
    return [self alertControllerWithTitle:title message:message preferredStyle:ARAlertControllerStyleActionSheet actions:actions textFieldConfigurationHandlers:configurationHandlers];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [self alertWithTitle:title message:message actions:nil];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions
{
    return [self alertWithTitle:title message:message actions:actions textFieldConfigurationHandlers:nil];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions textFieldConfigurationHandlers:(NSArray *)configurationHandlers
{
    return [self alertControllerWithTitle:title message:message preferredStyle:ARAlertControllerStyleAlert actions:actions textFieldConfigurationHandlers:configurationHandlers];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    ARAlertController *alertController = [[ARAlertController allocWithZone:zone] initWithTitle:self.title.copy message:self.message.copy preferredStyle:self.preferredStyle];
    
    for (ARAlertAction *alertAction in self.actions)
    {
        [alertController addAction:alertAction.copy];
    }
    
    for (UITextField *textField in self.textFields)
    {
        NSString *textFieldHash = [NSString stringWithFormat:@"%ld", (unsigned long)textField.hash];
        [alertController addTextFieldWithConfigurationHandler:self.configurationHandlers[textFieldHash]];
    }
    
    alertController.alertController = self.alertController.copy;
    alertController.alertView = self.alertView.copy;
    alertController.actionSheet = self.actionSheet.copy;
    
    alertController.presentCompletion = self.presentCompletion;
    alertController.dismissCompletion = self.dismissCompletion;
    
    return alertController;
}

#pragma mark - Properties

- (NSArray *)actions
{
    return self.mutableActions.copy;
}

- (NSArray *)textFields
{
    return self.mutableTextFields.copy;
}

#pragma mark - Configuration Methods

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
        NSString *textFieldHash = [NSString stringWithFormat:@"%ld", (unsigned long)textField.hash];
        [self.configurationHandlers setObject:configurationHandler forKey:textFieldHash];
    }
}

#pragma mark - Presentation Methods

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
                [self replaceTextField:textFieldSaved withTextField:textField];
            }];
        }
        
        [viewController presentViewController:alertController animated:animated completion:completion];
    }
    else
    {
        [[ARAlertControllerStorage sharedStorage].alertControllers addObject:self];
        
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
                
                [self replaceTextField:textFieldSaved withTextField:textField];
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
                
                [self replaceTextField:firstTextFieldSaved withTextField:firstTextField];
                [self replaceTextField:secondTextFieldSaved withTextField:secondTextField];
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

#pragma mark - Delegates

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    [self performPresentCompletion];
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    [self performPresentCompletion];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performActionAtIndex:buttonIndex];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performActionAtIndex:buttonIndex];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self performDismissCompletion];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self performDismissCompletion];
}

#pragma mark - Private Methods

- (void)performPresentCompletion
{
    if (self.presentCompletion)
    {
        self.presentCompletion();
    }
}

- (void)performActionAtIndex:(NSInteger)actionIndex
{
    ARAlertAction *action = self.actions[actionIndex];
    if (action.handler)
    {
        action.handler(action);
    }
}

- (void)performDismissCompletion
{
    if (self.dismissCompletion)
    {
        self.dismissCompletion();
    }
    
    [[ARAlertControllerStorage sharedStorage].alertControllers removeObject:self];
}

- (void)replaceTextField:(UITextField *)textFieldSaved withTextField:(UITextField *)textField
{
    NSString *textFieldSavedHash = [NSString stringWithFormat:@"%ld", (unsigned long)textFieldSaved.hash];
    ARAlertControllerConfigurationHandler handler = self.configurationHandlers[textFieldSavedHash];
    
    if (handler)
    {
        handler(textField);
        
        [self.configurationHandlers removeObjectForKey:textFieldSavedHash];
        
        NSString *textFieldHash = [NSString stringWithFormat:@"%ld", (unsigned long)textField.hash];
        
        [self.configurationHandlers setObject:handler forKey:textFieldHash];
    }
    
    [self.mutableTextFields replaceObjectAtIndex:[self.mutableTextFields indexOfObject:textFieldSaved] withObject:textField];
}

@end

