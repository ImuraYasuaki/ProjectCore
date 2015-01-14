//
//  PCService.m
//
//  Created by myuon on 2014/12/20.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "PCService.h"

@interface PCService ()

@property (nonatomic, strong) NSMutableDictionary *services;

@end

@implementation PCService

+ (instancetype)sharedService {
    static PCService *service = nil;
    if (!service) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            service = [[PCService alloc] init];
        });
    }
    NSString *className = NSStringFromClass(self);
    
    BOOL isRootServiceClass = [className isEqualToString:NSStringFromClass([PCService class])];
    if (isRootServiceClass) {
        return nil;
    }
    PCService *instantce = [[service services] objectForKey:className];
    if (!instantce) {
        instantce = [[self alloc] init];
        [[service services] setObject:instantce forKey:className];
    }
    return instantce;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setServices:[NSMutableDictionary dictionary]];
    }
    return self;
}

@end
