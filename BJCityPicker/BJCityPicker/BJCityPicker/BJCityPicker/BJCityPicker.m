//
//  BJCityPicker.m
//  BJCityPicker
//
//  Created by zbj-mac on 16/4/8.
//  Copyright © 2016年 zbj. All rights reserved.
//
#define kPROVINCE_COMPONENT  0
#define kCITY_COMPONENT      1
#define kLOCAL_COMPONENT  2

#import "BJCityPicker.h"
#import "BJProvinces.h"
@interface BJCityPicker()<UIPickerViewDataSource,UIPickerViewDelegate>
{
 
    NSInteger provinceIndex;
    NSInteger cityIndex;
    NSInteger localIndex;
}
/**
 *  确认按钮size=(50,40)
 */
@property(nonatomic,strong)UIButton*confirmBtn;
/**
 *  地址Picker height=186
 */
@property(nonatomic,strong)UIPickerView*pickerView;


/**
 *  选中回调
 */
@property(nonatomic,copy)citySelected citySelected;
#pragma mark----数据源----
/**
 *  省份
 */
@property(nonatomic,strong)NSMutableArray *provincesArr;
/**
 *  城市
 */
@property(nonatomic,strong)NSMutableArray *cityArr;
/**
 *  地区
 */
@property(nonatomic,strong)NSMutableArray *localArr;
@end
@implementation BJCityPicker
#pragma mark-----这里修改控件属性-----
-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn=[[UIButton alloc] init];
        _confirmBtn.frame=CGRectMake( KDeviceWidth-70,0, 50, 40);
        [_confirmBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _confirmBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.layer.cornerRadius=5;
        _confirmBtn.layer.masksToBounds=YES;
    }
    return _confirmBtn;
}

-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView=[[UIPickerView alloc] init];
        _pickerView.frame=CGRectMake(0, 40, KDeviceWidth, 186);
        _pickerView.delegate=self;
        _pickerView.dataSource=self;
        _pickerView.backgroundColor=[UIColor whiteColor];
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

#pragma mark----创建-----
static BJCityPicker* instance;
+(BJCityPicker *)shareCityPicker{
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[BJCityPicker alloc] init];
        });
    }
    return instance;
}

+(instancetype)cityPicker{
    return [[self alloc] init];
}
-(instancetype)init{
    if (self=[super init]) {
        [self addSubview:self.pickerView];
        [self addSubview:self.confirmBtn];
        [self initData];
        self.backgroundColor=[UIColor lightGrayColor];
        self.frame=CGRectMake(0, KDeviceHeight, KDeviceWidth, 226);
    }
    return self;
}

//初始数据
-(void)initData{
    self.provincesArr=[BJProvinces provinceWithArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"]]];
    BJProvinces *province=self.provincesArr[0];
    self.cityArr=(NSMutableArray*)province.cities;
    BJCities *city=self.cityArr[0];
    self.localArr=(NSMutableArray*)city.local;
    //刷新对应数据
    [self.pickerView reloadAllComponents];
    //设置默认选中
    [self.pickerView selectRow:0 inComponent: kPROVINCE_COMPONENT animated: YES];
}
//更新城市数据(防止非正常操作导致的崩溃及数据不对应)
-(void)reloadCityData{
    //  获取当前选中的索引
    provinceIndex = [self.pickerView selectedRowInComponent: kPROVINCE_COMPONENT];
    cityIndex = [self.pickerView selectedRowInComponent: kCITY_COMPONENT];
    localIndex = [self.pickerView selectedRowInComponent: kLOCAL_COMPONENT];
    //防止非正常操作导致的崩溃及数据不对应
    //索引是否为负值判断
    provinceIndex=provinceIndex<0?0:provinceIndex;
    cityIndex=cityIndex<0?0:cityIndex;
    localIndex=localIndex<0?0:localIndex;
    //索引大于数组count判断
    provinceIndex=provinceIndex>=[self.provincesArr count]?[self.provincesArr count]-1 :provinceIndex;
    //更换对应省份的城市数组
    BJProvinces *province=self.provincesArr[provinceIndex];
    self.cityArr=(NSMutableArray*)province.cities;
    //刷新城市数据
    [self.pickerView  reloadComponent: kCITY_COMPONENT];
    //更换对应城市的地区数组
    cityIndex=cityIndex>=[self.cityArr count]?[self.cityArr count]-1:cityIndex;
    BJCities*city=self.cityArr[cityIndex];
    self.localArr=(NSMutableArray*)city.local;
    //刷新地区数据
    [self.pickerView  reloadComponent: kLOCAL_COMPONENT];
    //索引判断
    localIndex=localIndex>=[self.localArr count]?[self.localArr count]-1:localIndex;
    
    //选中对应位置
    [self.pickerView selectRow:provinceIndex inComponent:kPROVINCE_COMPONENT animated:NO];
    [self.pickerView selectRow: cityIndex inComponent: kCITY_COMPONENT animated: NO];
    [self.pickerView  selectRow: localIndex inComponent: kLOCAL_COMPONENT animated: NO];
}


#pragma mark-----确认按钮点击事件-----
-(void)BtnClicked:(UIButton*)Btn{
    //防止非正常操作 首先刷新数据
    [self reloadCityData];
     //取值
    BJProvinces *province=self.provincesArr[provinceIndex];
    BJCities*city=self.cityArr[cityIndex];
    NSString *provinceStr = province.province;
    NSString *cityStr = city.city;
    NSString *localStr = [self.localArr objectAtIndex:localIndex];
    
    //过滤地址（可不加）
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: localStr]){
        cityStr = @"";
       localStr = @"";
    }
    else if ([cityStr isEqualToString: localStr])
    {
        localStr = @"";
    }
    //传出选中的地址
    !self.citySelected?:self.citySelected(provinceStr,cityStr,localStr);
}


-(void)cityPickerDidSelected:(citySelected)citySelected{
    self.citySelected=^(NSString*province,NSString*city,NSString*local){
        !citySelected?:citySelected(province,city,local);
    };
}
#pragma mark-----PickeView------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == kPROVINCE_COMPONENT){
        return [self.provincesArr count];
    }
    else if (component == kCITY_COMPONENT){
        return [self.cityArr count];
    }
    else {
        return [self.localArr count];
    }
}
//设置分组的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 100;
}

//每行文本
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == kPROVINCE_COMPONENT) {
        BJProvinces *province=self.provincesArr[row];
        return province.province;
    }
    else if (component == kCITY_COMPONENT) {
        BJCities*city=self.cityArr[row];
        return city.city;
    }
    else {
        return self.localArr[row];
    }
}

//替换text居中 这里可以解决地址显示不全问题（根据需要自行定义，颜色，frame，font）
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *  textLabel=[[UILabel alloc] init];
    if (component == kPROVINCE_COMPONENT){
        BJProvinces *province=self.provincesArr[row];
        textLabel.text = province.province;
    }
    else if (component == kCITY_COMPONENT){
        BJCities*city=self.cityArr[row];
        textLabel.text =city.city;
    }
    else {
        textLabel.text = [self.localArr objectAtIndex:row];
    }
    textLabel.frame=CGRectMake(0, 0, 98, 30);
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.backgroundColor = self.pickerView.backgroundColor;
    textLabel.adjustsFontSizeToFitWidth=YES;
    return textLabel;
}

#pragma mark----pickerView联动-----
//正常滑动结束
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == kPROVINCE_COMPONENT){
        BJProvinces *province=self.provincesArr[row];
        self.cityArr=(NSMutableArray*)province.cities;
        [self.pickerView  reloadComponent: kCITY_COMPONENT];
        BJCities*city=self.cityArr[0];
        self.localArr=(NSMutableArray*)city.local;
        [self.pickerView  reloadComponent: kLOCAL_COMPONENT];

        [self.pickerView selectRow: 0 inComponent: kCITY_COMPONENT animated: YES];
        [self.pickerView  selectRow: 0 inComponent: kLOCAL_COMPONENT animated: YES];
    }
    else if (component == kCITY_COMPONENT){
        BJCities *city=self.cityArr[row];
        self.localArr=(NSMutableArray*)city.local;
        [self.pickerView  reloadComponent: kLOCAL_COMPONENT];
        [self.pickerView selectRow: 0 inComponent: kLOCAL_COMPONENT animated: YES];
    }
}
@end
