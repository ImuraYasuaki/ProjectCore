//
//  PCAlertService.h
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import "PCService.h"

@class UIViewController;

typedef void (^PCAlertActionBlock)(NSString *title);

@interface PCAlertService : PCService

- (id)alertActionWithTitle:(NSString *)title action:(PCAlertActionBlock)actionBlock;

- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle actions:(NSArray *)actions;
- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;
- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message actions:(NSArray *)actions;

@end
