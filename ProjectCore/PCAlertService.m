//
//  PCAlertService.m
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCAlertService.h"
#import "PCSystemService.h"

@interface PCAlertAction : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) PCAlertActionBlock actionBlock;
+ (instancetype)actionWithTitle:(NSString *)title action:(PCAlertActionBlock)actionBlock;
@end
@implementation PCAlertAction
+ (instancetype)actionWithTitle:(NSString *)title action:(PCAlertActionBlock)actionBlock {
    PCAlertAction *action = [PCAlertAction init];
    if (action) {
        [action setTitle:title];
        [action setActionBlock:actionBlock];
    }
    return action;
}
- (void)dealloc {
    [self setActionBlock:nil];
}
@end

@interface PCAlertService ()
@property (nonatomic, strong) NSArray *actions; // use in iOS7.x
@end
@interface PCAlertService (AlertView) <UIAlertViewDelegate>
@end

@implementation PCAlertService

- (id)alertActionWithTitle:(NSString *)title action:(PCAlertActionBlock)actionBlock {
    __block id action = nil;
    [[PCSystemService sharedService] OSMajorVersionBranching:8 lessBlock:^{
        action = [PCAlertAction actionWithTitle:title action:actionBlock];
    } laterBlock:^{
        action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            actionBlock(action.title);
        }];
    }];
    return action;
}

- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle actions:(NSArray *)actions {
    [[PCSystemService sharedService] OSMajorVersionBranching:8 lessBlock:^{
        BOOL showingAlertView = [self actions] != nil;
        if (showingAlertView) {
            return;
        }
        [self setActions:actions];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        for (PCAlertAction *action in self.actions) {
            [alertView addButtonWithTitle:action.title];
        }
        [alertView show];
    } laterBlock:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        for (UIAlertAction *action in actions) {
            [alertController addAction:action];
        }
        if (cancelButtonTitle) {
            [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }]];
        }
        [viewController presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    [self showAlertViewFromViewController:viewController title:title message:message cancelButtonTitle:cancelButtonTitle actions:nil];
}

- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message actions:(NSArray *)actions {
    [self showAlertViewFromViewController:viewController title:title message:message cancelButtonTitle:nil actions:actions];
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation PCAlertService (AlertView)

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    PCAlertAction *action = [self.actions objectAtIndex:buttonIndex];
    action.actionBlock(action.title);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self setActions:nil];
}

@end
