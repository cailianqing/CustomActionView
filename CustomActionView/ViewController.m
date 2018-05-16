//
//  ViewController.m
//  CustomActionView
//
//  Created by cailianqing on 2018/5/16.
//  Copyright © 2018年 didi. All rights reserved.
//

#import "ViewController.h"
#import "ONESelectAddressErrorActionView.h"
@interface ViewController ()
@property(nonatomic,strong)ONESelectAddressErrorActionView *customActionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.customActionView showInView:self.view animated:YES];
}

#pragma -
#pragma - setter/getter
- (ONESelectAddressErrorActionView *)customActionView {
    if (_customActionView == nil) {
        ONESelectAddressErrorActionItem *itemFirst = [ONESelectAddressErrorActionItem actionSheetViewItemWithTag:0 itemTitle:@"first_Blood" itemImage:[UIImage imageNamed:@"common_icon_sug_History"]];
        ONESelectAddressErrorActionItem *itemSecond = [ONESelectAddressErrorActionItem actionSheetViewItemWithTag:1 itemTitle:@"double_kill" itemImage:[UIImage imageNamed:@"common_icon_sug_History"]];
        ONESelectAddressErrorActionItem *itemThird = [ONESelectAddressErrorActionItem actionSheetViewItemWithTag:1 itemTitle:@"triple_kill" itemImage:[UIImage imageNamed:@"common_icon_sug_History"]];
        
        _customActionView = [ONESelectAddressErrorActionView actionSheetViewWithTitle:@"测试ActioinView" cancelTitle:@"取消" destructiveTitle:nil items:@[itemFirst,itemSecond,itemThird] didSelectedBlock:^(ONESelectAddressErrorActionView *actionSheetView, ONESelectAddressErrorActionItem *item) {
            
        } cancelBlock:^(ONESelectAddressErrorActionView *actionSheetView) {
            
        } destructiveBlock:^(ONESelectAddressErrorActionView *actionSheetView) {
            
        }];
    }
    return _customActionView;
}
@end
