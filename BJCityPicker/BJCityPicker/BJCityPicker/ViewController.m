//
//  ViewController.m
//  BJCityPicker
//
//  Created by zbj-mac on 16/4/8.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import "ViewController.h"
#import "BJCityPickerView.h"
@interface ViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UIButton*testBtn;
@property(nonatomic,strong)UITextField*textField;
/**
 *  有遮盖
 */
@property(nonatomic,strong)BJCityPickerView*cityPickerView;
/**
 *  无遮盖 替代键盘
 */
@property(nonatomic,strong)BJCityPicker*cityPicker;
@end

@implementation ViewController
-(UIButton*)testBtn{
    if (!_testBtn) {
        _testBtn=[[UIButton alloc] init];
        _testBtn.frame=CGRectMake(KDeviceWidth*0.5-100, 230, 200, 60);
        [_testBtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_testBtn setTitle:@"测试" forState:UIControlStateNormal];
        [_testBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _testBtn;
}
-(UITextField *)textField{
    if (!_textField) {
        _textField=[[UITextField alloc] init];
        _textField.frame=CGRectMake(KDeviceWidth*0.5-100,150, 200, 30);
        _textField.delegate=self;
        _textField.placeholder=@"cityPicker";
        _textField.backgroundColor=[UIColor lightGrayColor];
        _textField.adjustsFontSizeToFitWidth=YES;
    }
    return _textField;
}
-(BJCityPickerView *)cityPickerView{
    if (!_cityPickerView) {
        WS(ws);
        _cityPickerView=[BJCityPickerView shareCityPickerView];
        [_cityPickerView cityPicekrViewDidSelected:^(NSString *province, NSString *city, NSString *local) {
            //赋值
            ws.textField.text=[NSString stringWithFormat:@"%@%@%@",province,city,local];
        }];
    }
    return _cityPickerView;

}
-(BJCityPicker *)cityPicker{
    if (!_cityPicker) {
        _cityPicker=[BJCityPicker cityPicker];
        WS(ws);
        [_cityPicker cityPickerDidSelected:^(NSString *province, NSString *city, NSString *local) {
            //收键盘
            [ws.textField resignFirstResponder];
            //赋值
            ws.textField.text=[NSString stringWithFormat:@"%@%@%@",province,city,local];
        }];
      
    }
    return _cityPicker;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.testBtn];
    [self.view addSubview:self.textField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)BtnClicked:(UIButton*)btn{
    [self.cityPickerView show];
}
#pragma mark----UITextFieldDelegate----
//无遮盖 输入框进入编辑状态 BJCityPicker替换键盘
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField==self.textField) {
        self.textField.inputView=self.cityPicker;
    }
}
//收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //刷新数据防止数据不对应
    [self.cityPicker reloadCityData];
    [self.textField resignFirstResponder];
}

@end
