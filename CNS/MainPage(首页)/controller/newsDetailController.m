//
//  newsDetailController.m
//  CNS
//
//  Created by Mac on 16/5/12.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "newsDetailController.h"

#import "newsDtailCell.h"

#import "JSComentModel.h"

#import "commentCell.h"

#import "inputCommentView.h"

typedef NS_ENUM(NSInteger,JSRefreshState){
    JSRefreshStateNormal = 1,
    JSRefreshStateLoading
};

@interface newsDetailController ()<inputCommentViewDelegate>

@property (nonatomic,strong) JSNewsFrameModel *model;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) NSMutableArray *commentModelArray;

@property (nonatomic,retain) UIView *mengBan;

@property (nonatomic,assign) NSInteger totalPage;

@property (nonatomic,assign) JSRefreshState JSRefreshState;

@property (nonatomic,retain) inputCommentView *commentView;

@end

@implementation newsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    
    self.commentModelArray = [NSMutableArray array];
    
    self.title = @"新闻";
    
    //    [self setUpTablevewBackColor];
    
//    self.tableView.bounces = NO;//禁止tableView弹性效果
    
    /**
     *  添加一个脚
     */
    UIView *footerView = [[UIView alloc] init];
    
    footerView.height = 50;
    footerView.width = 1;
    
    self.tableView.tableFooterView = footerView;
    
    
   
    
}


-(void)setCurrentModel:(JSNewsModel *)currentModel{
    
    if (_currentModel != currentModel) {
        
        _currentModel = currentModel;
        
        JSNewsFrameModel *model = [[JSNewsFrameModel alloc] initWithModel:self.currentModel];
        
        self.model = model;
        
        NSMutableDictionary *infoDic =[NSMutableDictionary dictionary];
        
        infoDic[@"loginName"] = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginName"];
        
        
        infoDic[@"token"] = [[NSUserDefaults standardUserDefaults]valueForKey:@"token"];
        
        infoDic[@"id"] = self.currentModel.num;
        
        infoDic[@"curPage"] = @"1";
        
        
        [[INetworking shareNet] GET:DetailNews withParmers:infoDic do:^(id returnObject, BOOL isSuccess) {
            
            
            JSLog(@"%@",returnObject);
            
            if (isSuccess) {
                NSString *num = returnObject[@"countPage"];
                self.totalPage = num.integerValue;
                
                self.model.commentNum = [NSString stringWithFormat:@"评论 %@",returnObject[@"countPage"]];
                self.model.likeNum = [NSString stringWithFormat:@"赞 %@",returnObject[@"zanCount"]];
                self.model.commentArray = returnObject[@"list"];
                self.model.isLike = [returnObject[@"msg"]isEqualToString:@"您已经点过赞"];
                
                for(NSDictionary *dic in self.model.commentArray){
                    JSComentModel *model = [JSComentModel modelForDic:dic];
                    
                    [self.commentModelArray addObject:model];
                    
                    
                }
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                self.JSRefreshState = JSRefreshStateNormal;
            }
        }];
    }
}



-(inputCommentView *)commentView{
    if (!_commentView) {
        
        inputCommentView *viewT = [inputCommentView put];
        
        viewT.tipsSting = @"添加评论";
        
        viewT.delegate = self;
        
        viewT.y = CGRectGetMaxY(self.tableView.frame) - viewT.height;
        
        [self.view addSubview:viewT];
        
        _commentView = viewT;
    
    }
    return _commentView;
}

-(UIView *)mengBan{
    if (!_mengBan) {
        _mengBan = [[UIView alloc] init];
        [_mengBan setFrame:JSFrame];
//        _mengBan.backgroundColor = [UIColor redColor];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchMB)];
        
        [_mengBan addGestureRecognizer:tap];
        
    }
    return _mengBan;
}

-(void)touchMB{
    
    [self.view endEditing:YES];
    
}

#pragma mark - tableviewDelegate

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        newsDtailCell *cell = [newsDtailCell cellForTableview:tableView];
        return cell;
    }else{
        commentCell *cell = [commentCell cellForTableview:self.tableView];
        return cell;
    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }else{
        return self.commentModelArray.count;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        newsDtailCell *rail = (newsDtailCell *)cell;
        rail.model = self.model;
    }else{
        JSComentModel *model = self.commentModelArray[indexPath.row];
        commentCell *rail = (commentCell *)cell;
        rail.model = model;
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return self.model.totalHeight;
    }else{
        JSComentModel *model = self.commentModelArray[indexPath.row];
        return model.totalHeight;
    }
}

-(void)inputCommentViewShowKeyBord:(inputCommentView *)view with:(CGFloat)heght{
    

    [self.view addSubview:self.mengBan];
//
    [self.view bringSubviewToFront:self.commentView];

    self.commentView.y = CGRectGetMaxY(self.tableView.frame) - 50 - heght;
    
    //[self.view insertSubview:self.mengBan aboveSubview:self.commentView];

    
//    CGFloat sum = JSFrame.size.height - (heght + 50);
//    
//    CGFloat rum = self.model.totalHeight - self.tableView.contentOffset.y;
//    
//    
//    CGFloat offset = sum - rum;
//    
//    if (offset <=0) {
//        self.tableView.contentOffset  = CGPointMake(0, self.tableView.contentOffset.y - offset);
//    }
}

-(void)inputCommentViewHideKeyBord:(inputCommentView *)view{
    self.commentView.y = CGRectGetMaxY(self.tableView.frame) - 50;
    [_mengBan removeFromSuperview];
    
}
-(void)clickSend:(inputCommentView *)view{
    
    
    if (!view.inputTextView.text.length) {
        return;
    }
    
    
    NSString *comment = view.inputTextView.text;
    NSString *loginName = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginName"];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:@"token"];
    NSString *num = self.model.lmodel.num;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"content"] = comment;
    dic[@"loginName"] = loginName;
    dic[@"token"] = token;
    dic[@"newsid"] = num;
    
    
    [[INetworking shareNet] GET:addComment withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        
        if (isSuccess) {
            
            [MBProgressHUD showSuccess:@"发表成功"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            dic[@"nickName"] = [[NSUserDefaults standardUserDefaults] objectForKey :@"nickName"];
            dic[@"content"] = comment;
            dic[@"createtime"] = @"刚刚";
            dic[@"img"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"img"];
            
            
            JSComentModel *model = [JSComentModel modelForDic:dic];
            
            [self.commentModelArray insertObject:model atIndex:0];
            
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            
            //            JSLog(@"%@",[NSThread currentThread]);
            
            if (_commentModelArray.count == 1) {
                return ;
            }
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]  atScrollPosition:(UITableViewScrollPositionMiddle) animated:NO];
            
            [self.tableView setNeedsDisplay];
            
        }else{
            
            [MBProgressHUD showError:@"发表失败"];
        }
    }];
    
}


/**
 *  加载新闻评论的方法;
 */

-(void)loadSomeComment{
    self.JSRefreshState = JSRefreshStateLoading;
    self.currentPage ++;
    
    NSMutableDictionary *infoDic =[NSMutableDictionary dictionary];
    
    infoDic[@"loginName"] = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginName"];
    
    
    infoDic[@"token"] = [[NSUserDefaults standardUserDefaults]valueForKey:@"token"];
    
    infoDic[@"id"] = self.currentModel.num;
    
    infoDic[@"curPage"] = [NSString stringWithFormat:@"%ld",self.currentPage];
    
    
    [[INetworking shareNet] GET:DetailNews withParmers:infoDic do:^(id returnObject, BOOL isSuccess) {
        
        if (isSuccess) {
            NSArray *ary =returnObject[@"list"];
            [self.model.commentArray addObjectsFromArray:ary];
            for(NSDictionary *dic in self.model.commentArray){
                JSComentModel *model = [JSComentModel modelForDic:dic];
                [self.commentModelArray addObject:model];
            }
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:nil];
            self.JSRefreshState = JSRefreshStateNormal;
            
        }else{
            
            self.currentPage --;
            
        }
    }];
}

/**
 *  刷新功能
 */

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat newsHeight = self.model.totalHeight;
    
    self.commentView.hidden = YES;
    if (newsHeight - self.tableView.contentOffset.y < JSFrame.size.height) {
    self.commentView.hidden = NO;
    }
    
    
    if (self.currentPage * 10 >= self.totalPage||self.JSRefreshState == JSRefreshStateLoading) {
        return;
    }
    
    CGFloat commentHight = 0;
    for (JSComentModel*model in self.commentModelArray) {
        commentHight += model.totalHeight;
    }
    
    CGFloat zh = self.model.totalHeight+commentHight;
    
    if (zh - self.tableView.contentOffset.y - JSFrame.size.height < JSFrame.size.height * .5) {
        
        [self loadSomeComment];
        
    }
    
    

    
}








@end
