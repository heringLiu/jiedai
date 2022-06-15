//
//  LJConsumptionHeaderModel.m
//  huaxiajiedai
//
//  Created by qm on 16/4/29.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJConsumptionHeaderModel.h"

@implementation LJConsumptionHeaderModel

- (instancetype)init {
    if (self = [super init]) {
        self.saleDate = @"";
        self.salemanCd = @"";
        self.salemanName = @"";
        self.salemanPosition = @"";
        
        self.createDate = @"";
        self.createUser = @"";
        self.createUserName = @"";
        self.createUserPosition = @"";
        
        self.updateDate = @"";
        self.updateUser = @"";
        self.updateUserName= @"";
        self.updateUserPosition = @"";
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
