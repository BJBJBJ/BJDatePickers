//
//  BJProvinces.m
//  城市
//
//  Created by zbj on 15-4-16.
//  Copyright (c) 2015年 zbj. All rights reserved.
//

#import "BJProvinces.h"
@implementation BJCities
-(instancetype)initWithdic:(NSDictionary *)dic{
    if (self=[super init]){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+(instancetype)citiesWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithdic:dic];
}
+(NSMutableArray*)citiesWithArray:(NSArray*)dataArray{
    NSMutableArray*mut=[NSMutableArray array];
    for (NSDictionary*dict in dataArray) {
        BJCities*model=[BJCities citiesWithDic:dict];
        [mut addObject:model];
    }
    return mut;
}
@end
@implementation BJProvinces
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self=[super init]){
        [self setValuesForKeysWithDictionary:dic];
        self.cities=[BJCities citiesWithArray:self.cities];
    }
    return self;
}
+(instancetype)provinceWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

+(NSMutableArray*)provinceWithArray:(NSArray*)dataArray{
    NSMutableArray *mut=[NSMutableArray array];
    for (NSDictionary*dict in dataArray) {
        
       BJProvinces*model=[BJProvinces provinceWithDic:dict];
        [mut addObject:model];
    }
    return mut;
}
@end
