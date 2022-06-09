//
//  LJProjectTitleModel.m
//  huaxiajiedai
//
//  Created by qm on 16/5/3.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJProjectTitleModel.h"

@implementation LJProjectTitleModel

- (void)setProjectList:(NSMutableArray *)projectList {
    _projectList = [NSMutableArray array];
    if ([projectList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in projectList) {
            LJProjectModel *entity = [[LJProjectModel alloc] init];
            [entity setValuesForKeysWithDictionary:dic];
            [_projectList addObject:entity];
        }
    }
    
}

@end
