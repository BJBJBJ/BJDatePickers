//
//  BJCityPicker.h
//  BJCityPicker
//
//  Created by zbj-mac on 16/4/8.
//  Copyright © 2016年 zbj. All rights reserved.
//
//weakSelf
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define KDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#import <UIKit/UIKit.h>
//height=226 无遮盖(可替代键盘使用)
typedef void(^citySelected)(NSString*province,NSString*city,NSString*local);
@interface BJCityPicker : UIView
/**
 *  选中回调
 */
@property(nonatomic,copy)citySelected citySelected;
/**
 *  单例创建
 */
+(BJCityPicker*)shareCityPicker;
/**
 *  实例创建
 */
+(instancetype)cityPicker;
/**
 *  更新城市数据(防止非正常操作导致的崩溃及数据不对应)
 */
-(void)reloadCityData;
@end
