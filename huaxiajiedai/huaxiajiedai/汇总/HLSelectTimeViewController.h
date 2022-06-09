//
//  HLSelectTimeViewController.h
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/24.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HLSearchView.h"
#import "CustomTopNavigationView.h"

@interface HLSelectTimeViewController : UIViewController <CustomTopNavigationViewDelegate>
@property (nonatomic, strong) CustomTopNavigationView *topView;
//@property (nonatomic, strong) HLSearchView *mySearchView;

@end
