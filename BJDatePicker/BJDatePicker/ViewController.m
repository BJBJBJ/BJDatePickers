//
//  ViewController.m
//  BJDatePicker
//
//  Created by zbj-mac on 16/4/8.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import "ViewController.h"
#import "BJDatePickerView.h"
@interface ViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UIButton*testBtn;
@property(nonatomic,strong)UITextField*textField;
/**
 *  有遮盖
 */
@property(nonatomic,strong)BJDatePickerView*datePickerView;
/**
 *  无遮盖 替代键盘
 */
@property(nonatomic,strong)BJDatePicker*datePicker;
@end

@implementation ViewController

-(UIButton*)testBtn{
    if (!_testBtn) {
        _testBtn=[[UIButton alloc] init];
        _testBtn.frame=CGRectMake(KDeviceWidth*0.5-75, 230, 150, 60);
        [_testBtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_testBtn setTitle:@"测试" forState:UIControlStateNormal];
        [_testBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _testBtn;
}
-(UITextField *)textField{
    if (!_textField) {
        _textField=[[UITextField alloc] init];
        _textField.frame=CGRectMake(KDeviceWidth*0.5-75, 150, 150, 30);
        _textField.delegate=self;
        _textField.placeholder=@"datePicker";
        _textField.backgroundColor=[UIColor lightGrayColor];
    }
    return _textField;
}
-(BJDatePickerView *)datePickerView{
    if (!_datePickerView) {
        WS(ws);
        _datePickerView=[BJDatePickerView shareDatePickerView];
        _datePickerView.dateSelected=^(NSString*date){
            //赋值
            ws.textField.text=date;
        };
    }
    return _datePickerView;
}
-(BJDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker=[BJDatePicker datePicker];
         WS(ws);
        _datePicker.dateSelected=^(NSString*date){
              //赋值
            ws.textField.text=date;
            //收键盘
            [ws.textField resignFirstResponder];
        };
 
    }
    return _datePicker;
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
//有遮盖
-(void)BtnClicked:(UIButton*)btn{
    [self.datePickerView show];
}
#pragma mark----UITextFieldDelegate----
//无遮盖 输入框进入编辑状态 BJDatePicker替换键盘
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField==self.textField) {
        self.textField.inputView=self.datePicker;
    }
}
//收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}
@end
