//
//  tousuJubaoController.m
//  CNS
//
//  Created by Mac on 16/7/12.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "tousuJubaoController.h"

@interface tousuJubaoController ()<UITextViewDelegate>

@property (nonatomic,retain) UILabel *placeLabel;

@end

@implementation tousuJubaoController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"投诉,举报";
    
    
    self.placeLabel = [[UILabel alloc] init];
    
    self.placeLabel.text = @"您可以在这里对影响了您用户体验的信息进行投诉和举报,如果举报内容是新闻,请提供新闻的日期和新闻标题.如果对象是论坛的发言,请提供发言人的姓名和所处帖子的标题与日期.我们将会在24小时之内对举报内容进行审核和检查.如果确实存在未发内容,或者影响到用户的使用,我们将会对其进行处理";
    
    self.placeLabel.numberOfLines = 0;
    
    self.placeLabel.textColor = [UIColor darkGrayColor];
    
    self.placeLabel.textAlignment = NSTextAlignmentLeft;
    
    self.placeLabel.frame = self.commentView.frame;
    
    [self.view addSubview:self.placeLabel];
    
    self.commentView.delegate = self;
    
}


-(void)sureSend:(UIBarButtonItem *)item{
    
    if (!self.commentView.text.length) {
        [MBProgressHUD showError:@"未填写任何内容"];
    }else{
        NSMutableDictionary *dic = [[JSUserManager shareManager] getUserDic];
        [[INetworking shareNet] setErrorDolowdToDo:^{
        }];
        
        dic[@"context"] = self.commentView.text;
        dic[@"type"] = @"0";
        
        WeakObject(self);
        
        [[INetworking shareNet] GET:addSug withParmers:dic do:^(id returnObject, BOOL isSuccess) {
            
            if (isSuccess) {
                [MBProgressHUD showSuccess:@"发送成功,我们会尽快处理"];
                [selfWeak.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@1 afterDelay:1];
            }else{
                [MBProgressHUD showError:@"发送失败"];
            }
        }];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeLabel.hidden = YES;
}




@end
