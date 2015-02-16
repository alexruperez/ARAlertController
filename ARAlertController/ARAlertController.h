//
//  ARAlertController.h
//  ARAlertController
//
//  Created by alexruperez on 14/2/15.
//  Copyright (c) 2015 alexruperez. All rights reserved.
//

#import <UIKit/UIKit.h>


//! Project version number for ARAlertController.
FOUNDATION_EXPORT double ARAlertControllerVersionNumber;

//! Project version string for ARAlertController.
FOUNDATION_EXPORT const unsigned char ARAlertControllerVersionString[];

/**
 *  Alert Action Style
 */
typedef NS_ENUM(NSInteger, ARAlertActionStyle){
    /**
     *  Default Style
     */
    ARAlertActionStyleDefault = 0,
    /**
     *  Cancel Style
     */
    ARAlertActionStyleCancel,
    /**
     *  Destructive Style
     */
    ARAlertActionStyleDestructive
};

/**
 *  Alert Controller Style
 */
typedef NS_ENUM(NSInteger, ARAlertControllerStyle){
    /**
     *  Action Sheet Style
     */
    ARAlertControllerStyleActionSheet = 0,
    /**
     *  Alert Style
     */
    ARAlertControllerStyleAlert
};


@class ARAlertAction;

/**
 *  Alert Action Handler Block
 *
 *  @param action Alert Action
 */
typedef void (^ARAlertActionHandler)(ARAlertAction *action);

/**
 *  Alert Controller Text Field Configuration Handler
 *
 *  @param textField Text Field
 */
typedef void (^ARAlertControllerConfigurationHandler)(UITextField *textField);

#pragma mark - ARAlertAction

/**
 *  A ARAlertAction object represents an action that can be taken when tapping a button in an alert. You use this class to configure information about a single action, including the title to display in the button, any styling information, and a handler to execute when the user taps the button. After creating an alert action object, add it to a ARAlertController object before displaying the corresponding alert to the user.
 */
@interface ARAlertAction : NSObject <NSCopying>

#pragma mark - Initializers

/**
 *  Create and return an action with the specified title and behavior.
 Actions are enabled by default when you create them.
 *
 *  @param title   The text to use for the button title. The value you specify should be localized for the user’s current language. This parameter must not be nil.
 *  @param style   Additional styling information to apply to the button. Use the style information to convey the type of action that is performed by the button. For a list of possible values, see the constants in ARAlertActionStyle.
 *  @param handler A ARAlertActionHandler block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
 *
 *  @return A new alert action object.
 */
+ (instancetype)actionWithTitle:(NSString *)title style:(ARAlertActionStyle)style handler:(ARAlertActionHandler)handler;

#pragma mark - Helpers

+ (instancetype)actionWithTitle:(NSString *)title style:(ARAlertActionStyle)style;

+ (instancetype)defaultActionWithTitle:(NSString *)title handler:(ARAlertActionHandler)handler;

+ (instancetype)cancelActionWithTitle:(NSString *)title handler:(ARAlertActionHandler)handler;

+ (instancetype)destructiveActionWithTitle:(NSString *)title handler:(ARAlertActionHandler)handler;

+ (instancetype)defaultActionWithTitle:(NSString *)title;

+ (instancetype)cancelActionWithTitle:(NSString *)title;

+ (instancetype)destructiveActionWithTitle:(NSString *)title;

#pragma mark - Properties

/**
 *  The title of the action’s button. (read-only)
 */
@property (nonatomic, readonly) NSString *title;

/**
 *  The style (ARAlertActionStyle) that is applied to the action’s button. (read-only)
 */
@property (nonatomic, readonly) ARAlertActionStyle style;

/**
 *  A Boolean value indicating whether the action is currently enabled.
 */
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

#pragma mark - ARAlertController

/**
 *  A ARAlertController object displays an alert message to the user. This class replaces the UIActionSheet and UIAlertView classes for displaying alerts. After configuring the alert controller with the actions and style you want, present it using the presentInViewController:animated:completion: method
 */
@interface ARAlertController : NSObject <NSCopying>

#pragma mark - Initializers

/**
 *  Creates and returns a view controller for displaying an alert to the user.
 After creating the alert controller, configure any actions that you want the user to be able to perform by calling the addAction: method one or more times. When specifying a preferred style of ARAlertControllerStyleAlert, you may also configure one or more text fields to display in addition to the actions.
 *
 *  @param title          The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
 *  @param message        Descriptive text that provides additional details about the reason for the alert.
 *  @param preferredStyle The ARAlertControllerStyle style to use when presenting the alert controller. Use this parameter to configure the alert controller as an action sheet or as a modal alert.
 *
 *  @return An initialized alert controller object.
 */
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(ARAlertControllerStyle)preferredStyle;

#pragma mark - Helpers

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(ARAlertControllerStyle)preferredStyle actions:(NSArray *)actions;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(ARAlertControllerStyle)preferredStyle actions:(NSArray *)actions textFieldConfigurationHandlers:(NSArray *)configurationHandlers;

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message;

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions;

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions textFieldConfigurationHandlers:(NSArray *)configurationHandlers;

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message;

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions;

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions textFieldConfigurationHandlers:(NSArray *)configurationHandlers;

#pragma mark - Properties

/**
 *  The actions that the user can take in response to the alert or action sheet. (read-only)
 The actions are in the order in which you added them to the alert controller. This order also corresponds to the order in which they are displayed in the alert or action sheet. The second action in the array is displayed below the first, the third is displayed below the second, and so on.
 */
@property (nonatomic, readonly) NSArray *actions;

/**
 *  The array of text fields displayed by the alert. (read-only)
 */
@property (nonatomic, readonly) NSArray *textFields;

/**
 *  The title of the alert.
 */
@property (nonatomic, copy) NSString *title;

/**
 *  Descriptive text that provides more details about the reason for the alert.
 */
@property (nonatomic, copy) NSString *message;

/**
 *  The ARAlertControllerStyle style of the alert controller. (read-only)
 The value of this property is set to the value you specified in the alertControllerWithTitle:message:preferredStyle: method. This value determines how the alert is displayed onscreen.
 */
@property (nonatomic, readonly) ARAlertControllerStyle preferredStyle;

#pragma mark - Configuration Methods

/**
 *  Attaches an action object to the alert or action sheet.
 If your alert has multiple actions, the order in which you add those actions determines their order in the resulting alert or action sheet.
 *
 *  @param action The action object to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
 */
- (void)addAction:(ARAlertAction *)action;

/**
 *  Adds a text field to an alert.
 Calling this method adds an editable text field to the alert. You can call this method more than once to add additional text fields. The text fields are stacked in the resulting alert.
 You can add a text field only if the preferredStyle property is set to ARAlertControllerStyleAlert.
 *
 *  @param configurationHandler An ARAlertControllerConfigurationHandler block for configuring the text field prior to displaying the alert. This block has no return value and takes a single parameter corresponding to the text field object. Use that parameter to change the text field properties.
 */
- (void)addTextFieldWithConfigurationHandler:(ARAlertControllerConfigurationHandler)configurationHandler;

#pragma mark - Presentation Methods

/**
 *  Present the alert.
 *
 *  @param viewController The view controller to display the alert.
 *  @param animated       Pass YES to animate the presentation; otherwise, pass NO.
 *  @param completion     The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
 */
- (void)presentInViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 *  Dismiss the alert.
 *
 *  @param animated   Pass YES to animate the presentation; otherwise, pass NO.
 *  @param completion The block to execute after the view controller is dismissed. This block has no return value and takes no parameters. You may specify nil for this parameter.
 */
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
