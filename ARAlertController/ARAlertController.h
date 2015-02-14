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


typedef NS_ENUM(NSInteger, ARAlertActionStyle) {
    ARAlertActionStyleDefault = 0,
    ARAlertActionStyleCancel,
    ARAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, ARAlertControllerStyle) {
    ARAlertControllerStyleActionSheet = 0,
    ARAlertControllerStyleAlert
};


@class ARAlertAction;

typedef void (^ARAlertActionHandler)(ARAlertAction *action);

typedef void (^ARAlertControllerConfigurationHandler)(UITextField *textField);


@interface ARAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title style:(ARAlertActionStyle)style handler:(ARAlertActionHandler)handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) ARAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end


@interface ARAlertController : NSObject <NSCopying>

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(ARAlertControllerStyle)preferredStyle;

- (void)addAction:(ARAlertAction *)action;

@property (nonatomic, readonly) NSArray *actions;

- (void)addTextFieldWithConfigurationHandler:(ARAlertControllerConfigurationHandler)configurationHandler;

@property (nonatomic, readonly) NSArray *textFields;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, readonly) ARAlertControllerStyle preferredStyle;

- (void)presentInViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
