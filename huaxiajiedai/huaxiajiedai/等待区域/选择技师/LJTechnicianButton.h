//
//  LJTechnicianButton.h
//  huaxiajiedai
//
//  Created by qm on 16/5/10.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJArtModel.h"

@class LJTechnicianButton;

@protocol TButtonDelegate <NSObject>

- (void) sendTButton:(LJTechnicianButton *)tButton;

@end

@interface LJTechnicianButton : UIButton

@property (nonatomic, strong) LJArtModel *technician;

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, strong) UIButton *closeBtn;

- (void) showButton;

- (void) closeButton;

@property (nonatomic, assign) id<TButtonDelegate> delegate;

@end
