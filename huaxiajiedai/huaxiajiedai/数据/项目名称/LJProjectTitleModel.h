//
//  LJProjectTitleModel.h
//  huaxiajiedai
//
//  Created by qm on 16/5/3.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJRootModel.h"
#import "LJProjectModel.h"

@interface LJProjectTitleModel : LJRootModel

@property (nonatomic, strong) NSString *typeCd;

@property (nonatomic, strong) NSString *typeName;

@property (nonatomic, strong) NSMutableArray *projectList;

@end
