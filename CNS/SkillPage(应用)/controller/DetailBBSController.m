//
//  DetailBBSController.m
//  CNS
//
//  Created by Mac on 16/5/24.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "DetailBBSController.h"

#import "inputCommentView.h"

static const NSInteger onePageMaxComment = 10;

@interface DetailBBSController ()<UITableViewDelegate,UITableViewDataSource,addCommentControllerDelegate,inputCommentViewDelegate>

@property (nonatomic,retain) NSMutableArray *answerArray;

@property (nonatomic,assign) NSIndexPath *currentIndexPath;

@property (nonatomic,assign) NSInteger curPage;

@property (nonatomic,retain) inputCommentView *inputView;

/**
 *  发送评论的按钮
 */
@property (nonatomic,retain) UIButton *commentButton;

/**
 *  是否在添加评论过程中
 */
@property (nonatomic,assign) BOOL isAdding;

@property (nonatomic,retain) detailBBSmodel *impModel;

/**
 *  是否是发帖人--即 回复权限
 */
@property (nonatomic,assign,getter=isAdmin) BOOL admin;

@end

@implementation DetailBBSController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.answerArray = [NSMutableArray array];
    
    
    self.impModel = [[detailBBSmodel alloc] init];
    
    self.impModel.basicModel = self.basicModel;
    
    self.title = @"帖子详情";
    
    [self setUpTableView];
    
    
    [self setComentButtonUp];
    
    [self setUpInputView];
    
    self.curPage = 1;
    
    
    [self setUpBBSInfo];
    
    __weak __typeof__(self) weakSelf = self;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf setUpBBSInfo];
        
        [weakSelf.tableView.mj_footer beginRefreshing];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)isAdmin{

    return [[[NSUserDefaults standardUserDefaults]valueForKey:@"loginName"] isEqualToString:self.basicModel.tureLoginName];

}

-(void)setUpTableView{
    
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.width,self.view.height);
    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    

    
    UIImageView *backrounView = [[UIImageView alloc] init];
    
    [backrounView setFrame:CGRectMake(0, 0, self.view.width, JSFrame.size.height)];
    
    backrounView.image = [UIImage imageNamed:@"底色"];
    
    [self.tableView setValue:backrounView forKeyPath:@"backgroundView"];
}

-(void)setUpBBSInfo{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"loginName"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginName"];
    
    dic[@"token"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    
    dic[@"id"] = self.basicModel.num;
    
    dic[@"curPage"] = [NSString stringWithFormat:@"%ld",self.curPage];

    [[INetworking shareNet] GET:getCardById withParmers:dic do:^(id returnObject, BOOL isSuccess) {
    
        if (!isSuccess) {
            [MBProgressHUD showError:@"连接失败"];
            return ;
        }
        if (self.curPage == 1) {
            [self.answerArray removeAllObjects];
        }
        self.answerArray = [self.answerArray subarrayWithRange:NSMakeRange(0, (self.curPage -1 ) * 10)].mutableCopy;
        
        NSArray *answers = returnObject[@"list"];
        
        for (NSDictionary *dic in answers) {
            answerModel *model = [[answerModel alloc] init];
            
            model.commentContent = dic[@"content"];
            
            model.commentCreattime = dic[@"createtime"];
            
            model.commentLoginName = dic[@"nickName"];
            
            model.answerContent = dic[@"r_content"];
            
            model.answerLoginName = dic[@"r_nickName"];
            
            model.answerCreatTime = dic[@"r_creattime"];
            
            model.commentHeaderImageSStr = dic[@"img"];
            
            model.commentID = dic[@"id"];
            
            [model getFrame];
            
            [self.answerArray addObject:model];
            
        }
        
        [self.tableView.mj_footer endRefreshing];
        
        if (answers.count == 0) {
            
            return;
        }
        
        if (answers.count >= onePageMaxComment) {
           
            self.curPage ++;  //修改好了的
        }
        
        [self.tableView reloadData];
        
        
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self setUpBBSInfo];

}


-(void)setComentButtonUp{

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:@"addComment"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(writeComment:) forControlEvents:UIControlEventTouchUpInside];
    
    button.width = button.height = 40;
    
    button.layer.cornerRadius = 20;
    
    button.layer.masksToBounds = YES;
    
    button.centerX = self.view.width * .85;
    
    button.centerY = self.view.height * .8;
    
    [self.view addSubview:button];
    
    
    self.commentButton = button;

}

-(void)writeComment:(UIButton *)but{
    if (!_isAdding) {
        
        _isAdding = YES;
        
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        [commentButton setTag:2];
        
        
        commentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        [commentButton setTitle:@"添加评论" forState: UIControlStateNormal];
        
        [commentButton setBackgroundColor:JSCOLOR];
        
        
        
        [commentButton sizeToFit];
        
        commentButton.layer.cornerRadius = 5;
        
        commentButton.layer.masksToBounds = YES;
        
        commentButton.centerX = but.centerX;
        
        commentButton.centerY = but.centerY - 60;
        
        [self.view addSubview:commentButton];
        
        
        [commentButton addTarget:self action:@selector(clickPushToComment) forControlEvents:UIControlEventTouchUpInside];
        
        
        commentButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        
        
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            but.transform = CGAffineTransformMakeRotation(M_PI+M_PI_4);
            
            /**
             制造蒙版
             */
            
            UIView *menban = [[UIView alloc] initWithFrame:self.view.bounds];
            
            menban.tag = 1;
            
            [self.view addSubview:menban];
            
            [self.view insertSubview:menban belowSubview:but];
            
            menban.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0];
            
            menban.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
            
            /**
             *  按钮donghua
             */
            commentButton.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            /**
             *  动画完成
             */
            
            
        }];
    }else if(_isAdding){
        [UIView animateWithDuration:0.4 animations:^{
            
            but.transform = CGAffineTransformIdentity;
            
            UIView *v = [self.view viewWithTag:1];
            
            v.alpha = 0;
            
            
            UIView *b = [self.view viewWithTag:2];
            
            b.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
            
        } completion:^(BOOL finished) {
            UIView *v = [self.view viewWithTag:1];
            
            [v removeFromSuperview];
            
            v = nil;
            
            
            UIView *b = [self.view viewWithTag:2];

            
            [b removeFromSuperview];
            
            b = nil;
            
            _isAdding = NO;
            
        }];

        
        
    }
}


-(void)clickPushToComment{
    
    addCommentController *vc = [[addCommentController alloc] init];
    
    vc.BBSid = self.impModel.basicModel.num;
    
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [self writeComment:self.commentButton];
}

-(void)setUpInputView{

    self.inputView = [inputCommentView put];
    
    self.inputView.hidden = YES;
    
    self.inputView.delegate = self;
    
    self.inputView.frame = CGRectMake(0, self.view.height-50, self.inputView.width, self.inputView.height);
    
    
    [self.view addSubview:self.inputView];
}


-(void)tapHideKeyBoard:(UITapGestureRecognizer *)tap{

    [self.inputView.inputTextView resignFirstResponder];

}

#pragma mark - delegate;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.impModel.totalHeight;
    }else{
        answerModel *model = self.answerArray[indexPath.row - 1];
        
        return model.commentTotalHeight + model.answerTotalHeight;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    detailInfoCell *cell = [detailInfoCell cellForTableview:tableView];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return self.answerArray.count + 1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    detailInfoCell *ce = (detailInfoCell *)cell;
    
    if (indexPath.row == 0) {
        ce.obj = self.impModel;
    }else{
        ce.obj = self.answerArray[indexPath.row - 1];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        return;
    }

    answerModel *model = self.answerArray[indexPath.row - 1];
    
    if (!self.admin || model.isAnswer) {
        return;
    }
    self.inputView.hidden = NO;
    
    _currentIndexPath = indexPath;
    
    
    self.inputView.tipsSting = [NSString stringWithFormat:@"回复:%@",model.commentLoginName];
    
    
    [self.inputView.inputTextView becomeFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    static BOOL isAnimation;
    static BOOL isHidden;
    
    if (scrollView.contentOffset.y > 10&&!isAnimation&&!isHidden) {
        isAnimation = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -CGRectGetMaxY(JSNavigationBounds));
            self.navigationController.navigationBar.alpha = 0.5;

//            [self.navigationController setNavigationBarHidden:YES animated:YES];
        } completion:^(BOOL finished) {
            isAnimation = NO;
            isHidden = YES;
        }];
    }else if(scrollView.contentOffset.y < 10&&!isAnimation&&isHidden){
        isAnimation = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBar.transform = CGAffineTransformIdentity;

            self.navigationController.navigationBar.alpha = 1;
            
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
        } completion:^(BOOL finished) {
            isAnimation = NO;
            isHidden = NO;
        }];
    }
}


#pragma mark - vcdelegate  点击发送了评论的回调

-(void)addCommentController:(addCommentController *)comment didSendComment:(NSMutableDictionary *)dic{
    
    [self setUpBBSInfo];

    
}

#pragma mark - inputCommentViewDelegate  回复栏的回调;

-(void)inputCommentViewShowKeyBord:(inputCommentView *)view with:(CGFloat)heght{

    [UIView animateWithDuration:0.4 animations:^{
        
        
        self.inputView.transform = CGAffineTransformMakeTranslation(0, -heght);
        
    } completion:^(BOOL finished) {
        
        UIView *menb = [[UIView alloc] initWithFrame:self.view.bounds];
        
        [self.view addSubview:menb];
        
        menb.backgroundColor = [UIColor clearColor];
        
        menb.tag = 1;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyBoard:)];
    
        [menb addGestureRecognizer:tap];
        
        [self.view insertSubview:menb belowSubview:self.inputView];
        
    }];
    
    
}

-(void)inputCommentViewHideKeyBord:(inputCommentView *)view{

    [UIView animateWithDuration:0.4 animations:^{
        
        
        self.inputView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        UIView *view = [self.view viewWithTag:1];
        
        [view removeFromSuperview];
        
        self.inputView.hidden = YES;
        
    }];
    
}

-(void)clickSend:(inputCommentView *)view{
    
    answerModel *model = self.answerArray[_currentIndexPath.row - 1];
    
    model.answerContent = view.inputTextView.text;
    
    model.answerCreatTime = @"刚刚";
    
    model.answerLoginName = self.basicModel.loginName;
    
    [model getFrame];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"loginName"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginName"];
    
    dic[@"token"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    
    dic[@"r_nickName"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"nickName"];
    
    dic[@"id"] = model.commentID;
    
    dic[@"r_content"] = model.answerContent;
    
    #warning message ' ' 成功才显示. 但是要先获得数据.不然可能会发生变化.    碰到异步就要想清楚会发什么什么事情
    [[INetworking shareNet] GET:addAnser withParmers:dic do:^(id returnObject, BOOL isSuccess) {
       
        if (isSuccess) {
            
//            NSLog(@"%@",returnObject);
            
            

            
            [self.tableView reloadRowsAtIndexPaths:@[_currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        
    }];

}



@end
