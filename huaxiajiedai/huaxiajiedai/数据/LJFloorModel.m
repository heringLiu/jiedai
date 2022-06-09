//
//  LJFloorModel.m
//  huaxiajiedai
//
//  Created by qm on 16/4/27.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJFloorModel.h"

@implementation LJFloorModel


- (void)setRooms:(NSMutableArray *)rooms {
    _rooms = [NSMutableArray array];
    for (NSDictionary *dic in rooms) {
        LJRoomModel *entity = [[LJRoomModel alloc] init];
        [entity setValuesForKeysWithDictionary:dic];
        [_rooms addObject:entity];
    }
}

@end
