//
//  Contention.h
//  huaxiajishi
//
//  Created by qm on 16/4/26.
//  Copyright © 2016年 LJ. All rights reserved.
//

#ifndef Contention_h
#define Contention_h

#define HTTP_TITLE @"http://"
//@"192.168.222.200"
#define IP_OR_DOMAIN [userDefaults objectForKey:IPADD]
#define HUAXIA_PORT @""
//#define HUAXIA_PORT @":9999"
#define PROJECT @"/hxlz"

//#define HTTP_TITLE @"http://"
//#define IP_OR_DOMAIN @"192.168.9.110"
//#define HUAXIA_PORT @":9999"
//#define PROJECT @"/hxlz"

#define HTTPADDRESS  [NSString stringWithFormat:@"%@%@%@%@",HTTP_TITLE,IP_OR_DOMAIN,HUAXIA_PORT,PROJECT]
#define REQUESTADDRESS HTTPADDRESS

/* 接口名称：
 * 请求地址：
 * 请求方式：
 * 请求参数：
 */



/* 接口名称：登录
 * 请求地址：/reception/login/login
 * 请求方式：POST
 * 请求参数：userId password
 */
#define RECEPRIONLOGIN [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/login/login/"]


/* 接口名称：房态图
 * 请求地址：/reception/room/roomIndex
 * 请求方式：GET
 * 请求参数：
 */
#define ROOMINDEX [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/room/roomIndex/"]


/* 接口名称：房间内消费单列表
 * 请求地址：/reception/room/getRoomOrder
 * 请求方式：GET
 * 请求参数：saleManCd   roomCd
 */
#define RECEPTIONGETROOMORDER [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/room/getRoomOrder/"]


/* 接口名称：开单接待员列表客户类型数据
 * 请求地址：/reception/consumerOrder/new
 * 请求方式：GET
 * 请求参数：userId
 */
#define RECEPTIONCUSTOMERTYPE [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/new/"]

/* 接口名称：新增  推销员列表客户类型数据
 * 请求地址：/reception/employee/customerNew/
 * 请求方式：GET
 * 请求参数：userId
 */
#define SALESMANLIST [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/employee/customerNew/"]

/* 接口名称：创建消费单
 * 请求地址：/reception/consumerOrder/insert
 * 请求方式：POST
 * 请求参数：manQty womanQty  customerQty  salemanCd  salemanName customerType  orderCd
 */
#define RECEPTIONCONSUMERORDERINDSERT [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/insert/"]

/* 接口名称：新增消费单客户
 * 请求地址：/reception/consumerOrder/addCustomer
 * 请求方式：POST
 * 请求参数：manQty womanQty  customerQty  salemanCd  salemanName customerType  orderCd
 */
#define RECEPTIONCONSUMERADDCUSTOMER [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/addCustomer/"]

/* 接口名称：消费订单详情
 * 请求地址：/reception/room/toEditOrder
 * 请求方式：GET
 * 请求参数：orderCd
 */
#define RECEPTIONEDITORDER [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/toEditOrder/"]
/* 接口名称：消费订单详情
 * 请求地址：/reception/room/toEditRoomOrder
 * 请求方式：GET
 * 请求参数：roomCd
 */
#define RECEPTIONEDITROOMORDER [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/toEditRoomOrder/"]


/* 接口名称：房间内接待单列表
 * 请求地址：/reception/receptionOrderHead/list/
 * 请求方式：GET
 * 请求参数：userId   keyWords
 */
#define RECEPTIONORDERHEADERLIST [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/receptionOrderHead/list/"]

/* 接口名称：消费删除客户
 * 请求地址：/reception/consumerOrder/deleteCustomer
 * 请求方式：POST
 * 请求参数：manQty womanQty  customerQty  salemanCd  salemanName customerType  orderCd
 */
#define RECEPTIONORDERHEADERDELETECUSTOMER [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/deleteCustomer/"]

/* 接口名称：接待订单-新增保存基本信息
 * 请求地址：/reception/receptionOrderHead/create/
 * 请求方式：POST
 * 请求参数：userId  orderCd customerCds
 */
#define RECEPTIONORDERHEADERCREATE [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/receptionOrderHead/create/"]

/* 接口名称：删除消费单明细
 * 请求地址：/reception/consumerOrder/delectDetil
 * 请求方式：POST
 * 请求参数：userId  orderCd customerCds
 */
#define RECEPTIONORDERHEADERDELETEDETAIL [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/delectDetil/"]

/* 接口名称：删除接待单明细
 * 请求地址：/reception/receptionOrderHead/deleteReceptionDetail/
 * 请求方式：delete
 * 请求参数：userId  orderCd customerCds
 */
#define RECEPTIODELETEDETAIL [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/receptionOrderHead/deleteReceptionDetail/"]

/* 接口名称：删除接待单
 * 请求地址：/reception/receptionOrderHead/delete/
 * 请求方式：DELETE
 * 请求参数：orderCd
 */
#define RECEPTIONORDERHEADERDELETE [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/receptionOrderHead/delete/"]

/* 接口名称：删除消费单
 * 请求地址：/reception/room/deleteOrder/
 * 请求方式：DELETE
 * 请求参数：orderCd
 */
#define XIAOFEILISTELETE [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/room/deleteOrder/"]

/* 接口名称：新增消费单客户
 * 请求地址：/reception/receptionOrderHead/customerCreate/
 * 请求方式：POST
 * 请求参数：manQty womanQty  customerQty  salemanCd  salemanName customerType  orderCd
 */
#define RECEPTIONORDERHEADERCREATECUSTOMER [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/receptionOrderHead/customerCreate/"]


/* 接口名称：删除接待单客户
 * 请求地址：/reception/receptionOrderHead/customerDelete/
 * 请求方式：POST
 * 请求参数：manQty womanQty  customerQty  salemanCd  salemanName customerType  orderCd
 */
#define RECEPTIONORDERHEADERCUSTOMERDELETE [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/receptionOrderHead/customerDelete/"]

/* 接口名称：消费接待详情
 * 请求地址：/reception/receptionOrderHead/edit/
 * 请求方式：GET
 * 请求参数：orderCd
 */
#define RECEPTIONORDERHEADEREDIT [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/receptionOrderHead/edit/"]


/* 接口名称：删除消费单明细
 * 请求地址：/reception/consumerOrder/delectDetil
 * 请求方式：post
 * 请求参数：orderCd
 */
#define XIAOFEIDELETEDETIL [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/delectDetil/"]

/* 接口名称：新增消费单明细
 * 请求地址：/reception/consumerOrder/addProject
 * 请求方式：post
 * 请求参数：orderCd
 */
#define XIAOFEIADDDETIL [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/addProject/"]

/* 接口名称：消费单加钟
 * 请求地址：/reception/consumerOrder/plusTime
 * 请求方式：post
 * 请求参数：orderCd
 */
#define XIAOFEIPLUSTIME [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/plusTime/"]



/* 接口名称：更新接待单
 * 请求地址：/reception/receptionOrderHead/updateReceptionOrder/
 * 请求方式：post
 * 请求参数：orderCd
 */
#define RECEPTIONUPDATE [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/receptionOrderHead/updateReceptionOrder/"]


/* 接口名称：更新消费单
 * 请求地址：/reception/consumerOrder/saveDetial/
 * 请求方式：post
 * 请求参数：orderCd
 */
#define XIAOFEIUPDATE [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/saveDetial/"]

/* 接口名称：接待订单-新增接待明细
 * 请求地址：/reception/receptionOrderHead/addReceptionDetail/
 * 请求方式：POST
 * 请求参数：orderCd
 */
#define RECEPTIONADDRECEPIONDETAIL [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/receptionOrderHead/addReceptionDetail/"]

/* 接口名称：项目列表
 * 请求地址：/reception/project/projectList/
 * 请求方式：GET
 * 请求参数：storeCd fastCode
 */
#define RECEPTIONPROJECTLIST [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/project/projectList/"]



/* 接口名称：技师列表
 * 请求地址：/reception/artificer/list/
 * 请求方式：GET
 * 请求参数：storeCd
 */
#define RECEPTIONARTFICERLIST [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/artificer/list/"]


/* 接口名称：技师列表点击事件
 * 请求地址：/reception/artificer/appointArtificerDetail/
 * 请求方式：GET
 * 请求参数：artificerCd
 */
#define CLICKJISHI [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/artificer/appointArtificerDetail/"]

/* 接口名称：房间列表
 * 请求地址：/reception/room/getRoom
 * 请求方式：GET
 * 请求参数：storeCd  param
 */
#define RECEPTIONGETROOMS [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/getRoom/"]





/* 接口名称：起钟
 * 请求地址：/reception/artificer/startTime/
 * 请求方式：POST
 * 请求参数：
 */
#define XIAOFEISTARTTIME [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/artificer/startTime/"]



/* 接口名称：落钟
 * 请求地址：/reception/artificer/endTime/
 * 请求方式：POST
 * 请求参数：
 */
#define XIAOFEIENDTIME [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/artificer/endTime/"]



/* 接口名称：技师工作列表
 * 请求地址：/reception/artificer/list/
 * 请求方式：POST
 * 请求参数：
 */
#define XIAOFEIWORKLIST [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/artificer/workList/"]




/* 接口名称：验证技师是否空闲
 * 请求地址：/reception/consumerOrder/verifiArtificer/
 * 请求方式：GET
 * 请求参数：
 */
#define XIAOFEIVERIFIJISHI [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/verifiArtificer/"]

/* 接口名称：插入消费单技师
 * 请求地址：/reception/consumerOrder/saveArt/
 * 请求方式：POST
 * 请求参数：OrderFag
 */
#define XIAOFEIINSERTJISHI [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/saveArt/"]




/* 接口名称：获取沙发
 * 请求地址：/reception/artificer/getSofa
 * 请求方式：GET
 * 请求参数：
 */
#define XIAOFEIGETSOFA [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/artificer/getSofa"]

/* 接口名称：选择沙发
 * 请求地址：/reception/artificer/selectSofa
 * 请求方式：POST
 * 请求参数：
 */
#define XIAOFEIPOSTSOFA [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/artificer/selectSofa"]


/* 接口名称：转消费单
 * 请求地址：/reception/consumerOrder/rectptionToConsumeOrder/
 * 请求方式：POST
 * 请求参数：
 */
#define JIEDAIXIAOFEI [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/rectptionToConsumeOrder/"]


/* 接口名称：修改房间
 * 请求地址：/reception/consumerOrder/editOrderRoom/
 * 请求方式：POST
 * 请求参数：
 */

#define XIAOFEICHANGEROOM [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/editOrderRoom/"]

/* 接口名称：拆单
 * 请求地址：/reception/consumerOrder/dismantleOrder/
 * 请求方式：POST
 * 请求参数：
 */
#define XIAOFEICHAIDAN [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/dismantleOrder/"]


/* 接口名称：保存项目 消费单
 * 请求地址：/reception/consumerOrder/dismantleOrder/
 * 请求方式：POST
 * 请求参数：
 */
#define XIAOFEISAVEPROJECT [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/saveProject/"]


/* 接口名称：保存项目 接待单
 * 请求地址：/reception/receptionOrderHead/updateProject/
 * 请求方式：POST
 * 请求参数：
 */
#define JIEDAISAVEPROJECT [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/receptionOrderHead/updateProject/"]






/* 接口名称：转消费单
 * 请求地址：/reception/consumerOrder/rectptionToConsumeOrderAll/
 * 请求方式：POST
 * 请求参数：
 */
#define JIEDAIXIAOFEIALL [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/rectptionToConsumeOrderAll/"]


/* 接口名称：消费单打印
 * 请求地址：/reception/print/consumePrint/
 * 请求方式：get
 * 请求参数：
 */
#define XIAOFEIPRINT [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/print/consumePrint/"]

/* 接口名称：更改性别
 * 请求地址：/reception/consumerOrder/updateSex/
 * 请求方式：post
 * 请求参数：
 */
#define UPDATESEX [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/updateSex/"]


/* 接口名称：取消点钟
 * 请求地址：/reception/artificer/updateArtificerType/
 * 请求方式：post
 * 请求参数： orderCd，projectCd，customerCd，detailNo，artificer1Cd/artificer2Cd，userId
 */
#define CANCELCALL [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/artificer/updateArtificerType/"]

/* 接口名称：更换技师的原因列表
 * 请求地址：reception/artificer/getArtificerChange
 * 请求方式：post
 * 请求参数：
 */
#define RESONLIST [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/artificer/getArtificerChange/"]


/* 接口名称：
 * 请求地址：/reception/employee/testSelectJishi/
 * 请求方式：post
 * 请求参数：userId
 */
#define testSelectJishi [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/employee/testSelectJishi/"]



/* 接口名称：双技师能否选择项目
 * 请求地址：/reception/artificer/testDoubleArt/
 * 请求方式：get
 * 请求参数：
 */
#define testDoubleArt [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/artificer/testDoubleArt/"]




/* 接口名称：双技师能否选择房间
 * 请求地址：/reception/employee/testUpdateRoom/
 * 请求方式：post
 * 请求参数：
 */
#define testUpdateRoom [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/employee/testUpdateRoom/"]



/* 接口名称：登录人开单统计：
 * 请求地址：/reception/room/countConsumeTable/
 * 请求方式：get
 * 请求参数：
 */
#define countConsumeTable [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/room/countConsumeTable/"]




/* 接口名称：接待部长列表：
 * 请求地址：/reception/room/empLIst/
 * 请求方式：get
 * 请求参数：
 */
#define empLIst [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/room/empLIst/"]

/* 接口名称：套盒信息  扫码
 * 请求地址：/hxlz/reception/consumerOrder/selectBoxProvideByBoxCd/
 * 请求方式：POST
 * 请求参数：
 */
#define BOXCDINFO [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/selectBoxProvideByBoxCd/"]


/* 接口名称：套盒信息  扫码更新
 * 请求地址：/reception/consumerOrder/saveDetialByBoxCd/
 * 请求方式：POST
 * 请求参数：
 */
#define BOXCDUPDATE [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/saveDetialByBoxCd/"]

/* 接口名称：汇总页面
 * 请求地址：http://47.93.240.77:8887/api/Crm/GetEmployeeWorkDetail
 * 请求方式：POST
 * 请求参数：StartDate EndDate EmployeeCD StoreCD
 */
#define TOTALLIST [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/technician/serve/getArtificerWorkAndSaleTotal/"]


/* 接口名称：个人做活明细
 * 请求地址：/hxlz/technician/serve/getArtificerWorkDetail/
 * 请求方式：POST
 * 请求参数：StartDate EndDate EmployeeCD StoreCD
 */
#define WORKSDETAILLIST [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/technician/serve/getArtificerWorkDetail/"]


/* 接口名称：个人点钟明细
 * 请求地址：/hxlz/technician/serve/getArtificerSelectDetail/
 * 请求方式：POST
 * 请求参数：StartDate EndDate EmployeeCD StoreCD
 */
#define SELECTEDDETAILLIST [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/technician/serve/getArtificerSelectDetail/"]


/* 接口名称：个人售卡明细
 * 请求地址：/hxlz/technician/serve/getArtificerCardSaleDetail/
 * 请求方式：POST
 * 请求参数：StartDate EndDate EmployeeCD StoreCD
 */
#define CARDDETAILLIST [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/technician/serve/getArtificerCardSaleDetail/"]

/* 接口名称：个人售票明细
 * 请求地址：/hxlz/technician/serve/getArtificerTicketSaleDetail/
 * 请求方式：POST
 * 请求参数：StartDate EndDate EmployeeCD StoreCD
 */
#define TICKETDETAILLIST [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/technician/serve/getArtificerTicketSaleDetail/"]


/* 接口名称：个人售盒明细
 * 请求地址：/hxlz/technician/serve/getArtificerBoxSaleDetail/
 * 请求方式：POST
 * 请求参数：StartDate EndDate EmployeeCD StoreCD
 */
#define BOXDETAILLIST [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/technician/serve/getArtificerBoxSaleDetail/"]

/* 接口名称：营业日查询
 * 请求地址：/hxlz/technician/serve/getBusinessDate/
 * 请求方式：POST
 * 请求参数：StartDate EndDate EmployeeCD StoreCD
 */
#define BUSINESSDATE [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/technician/serve/getBusinessDate/"]

// 2022年6月11日新增
/* 接口名称：获取手牌列表
 * 请求地址：/hxlz/reception/hand/handIndex/
 * 请求方式：GET
 * 请求参数：handCd
 */
#define HANDINDEX [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/hand/handIndex/"]

/* 接口名称：获取系统参数值
 * 请求地址：/hxlz/reception/consumerOrder/getSysSetValueBySetCd/
 * 请求方式：POST
 * 请求参数：setCd
 */
#define GETSYSTEMVALUEBYSETCD [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/getSysSetValueBySetCd/"]

/* 接口名称：根据手牌获取订单列表
 * 请求地址：/reception/hand/getHandOrder/
 * 请求方式：POST
 * 请求参数：handCd
 */
#define GETHANDERORDER [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/hand/getHandOrder/"]

/* 添加消费单（项目）
 * 请求地址：/reception/consumerOrder/addProjectWithPjcd/
 * 请求方式：POST
 * 请求参数：handCd
 */
#define ADDPROJECTWITHPJCD [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/addProjectWithPjcd/"]

/* 根据手牌增加项目（项目）
 * 请求地址：/reception/consumerOrder/insertWithPjcd/
 * 请求方式：POST
 * 请求参数：handCd
 */
#define INSERTWITHPJCD [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/insertWithPjcd/"]
/* 并入手牌
 * 请求地址：/reception/consumerOrder/bandHand/
 * 请求方式：POST
 * 请求参数：handCd
 */
#define BANDHAND [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/consumerOrder/bandHand/"]

// 2022年6月26日
/* 查询团购信息
 * 请求地址：/reception/group/getXMDInfoByGroupCd/
 * 请求方式：get
 * 请求参数：
 */
#define GETXMDINFO [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/group/getXMDInfoByGroupCd/"]
// 2022年6月30日
/* 团购转消费单
 * 请求地址：/reception/group/groupConsump/
 * 请求方式：post
 * 请求参数：
 */
#define GROUPCONSUMP [NSString stringWithFormat:@"%@%@",REQUESTADDRESS,@"/reception/group/groupConsump/"]


#endif /* Contention_h */
