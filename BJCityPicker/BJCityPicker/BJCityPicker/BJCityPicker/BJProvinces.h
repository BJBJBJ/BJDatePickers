//
//  BJProvinces.h
//  城市
//
//  Created by zbj on 15-4-16.
//  Copyright (c) 2015年 zbj. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BJCities : NSObject
/**
 *  城市的名字
 */
@property(nonatomic ,copy)NSString *city;
/**
 *  该城市下的地区数组
 */
@property(nonatomic,copy)NSArray *local;
@end


@interface BJProvinces : NSObject
/**
 *  省份名字
 */
@property(nonatomic,copy)NSString* province;
/**
 *  该省份下的城市数组
 */
@property(nonatomic,strong)NSArray*cities;
-(instancetype)initWithDic:(NSDictionary*)dic;
+(instancetype)provinceWithDic:(NSDictionary *)dic;
+(NSMutableArray*)provinceWithArray:(NSArray*)dataArray;
@end
