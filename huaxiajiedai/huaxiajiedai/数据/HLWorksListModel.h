//
//  HLWorksListModel.h
//  
//
//  Created by gjhgj on 2017/9/17.
//
//

#import "LJRootModel.h"

@interface HLWorksListModel : LJRootModel


// 营业日期
@property (nonatomic, strong) NSString *businessDate;
// 项目类型
@property (nonatomic, strong) NSString *ProjectTypeName;
//项目名称
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) NSString *amtCategory;
@property (nonatomic, strong) NSString *amt;
@property (nonatomic, strong) NSString *amtTypeName;

@property (nonatomic, strong) NSString *workQty;

@property (nonatomic, strong) NSString *selectQty;

@property (nonatomic, strong) NSString *WorkDate;

@property (nonatomic, strong) NSString *WorkAmt;


@property (nonatomic, strong) NSString *leftName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *rightName;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *qty;
@property (nonatomic, assign) BOOL isTop;

@end
