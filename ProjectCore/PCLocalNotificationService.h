//
//  PCLocalNotificationService.h
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import "PCService.h"

@class UILocalNotification;

@interface PCLocalNotificationService : PCService

- (NSArray *)scheduledLocalNotifications;
- (BOOL)didScheduleLocalNotificationAtDate:(NSDate *)date;
- (void)scheduleLocalNotification:(UILocalNotification *)notification;
- (void)scheduleLocalNotificationWithMessage:(NSString *)message atDate:(NSDate *)date;
- (void)scheduleLocalNotificationWithMessage:(NSString *)message atDate:(NSDate *)date userInfo:(NSDictionary *)userInfo;
- (void)cancelScheduledLocalNotificationAtDate:(NSDate *)date;

@end
