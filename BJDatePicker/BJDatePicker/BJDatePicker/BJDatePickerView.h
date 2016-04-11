//
//  BJDatePickerView.h
//  BJDatePicker
//
//  Created by zbj-mac on 16/4/8.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BJDatePicker.h"
//有遮盖，添加在window
@interface BJDatePickerView : UIView
/**
 *  选中回调
 */
@property(nonatomic,copy)dateSelected dateSelected;
/**
 *  单例创建
 */
+(BJDatePickerView*)shareDatePickerView;
/**
 *  实例创建
 */
+(instancetype)datePickerView;
/**
 *  展示
 */
-(void)show;
/**
 *  移除
 */
-(void)hidden;
@end
