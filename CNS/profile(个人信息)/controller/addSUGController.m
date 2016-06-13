//
//  addSUGController.m
//  CNS
//
//  Created by Mac on 16/6/3.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "addSUGController.h"

@interface addSUGController ()

@end

@implementation addSUGController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentView.width = self.commentView.width - 10;
    self.commentView.height = self.commentView.height - 10;
    
    self.commentView.x = self.commentView.x + 5;
    
    self.commentView.y = self.commentView.y + 5;
    
    self.commentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    
}


-(void)sureSend:(UIBarButtonItem *)item{
    
    if (!self.commentView.text.length) {
        [MBProgressHUD showError:@"未填写任何内容"];
    }else{
        NSMutableDictionary *dic = [[JSUserManager shareManager] getUserDic];
        [[INetworking shareNet] setErrorDolowdToDo:^{
        }];
        
        dic[@"context"] = self.commentView.text;
        
        [[INetworking shareNet] GET:addSug withParmers:dic do:^(id returnObject, BOOL isSuccess) {
            
            if (isSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:@"发送失败"];
            }
        }];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
