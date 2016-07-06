//
//  newsDtailCell.m
//  CNS
//
//  Created by Mac on 16/5/12.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "newsDtailCell.h"


@interface newsDtailCell ()

@property (nonatomic,retain) UILabel *titleLabel;

@property (nonatomic,retain) UILabel *timeLabel;

@property (nonatomic,retain) UILabel *authorLabel;

@property (nonatomic,retain) UILabel *contentLabel;


@property (nonatomic,retain) UIButton *likeButton;


@property (nonatomic,retain) UIButton *commentButton;


@property (nonatomic,retain) UIButton *likeButtonToo;


@end

@implementation newsDtailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *label = [[UILabel alloc] init];
        
        label.font = titleFont;
        
        label.textColor = [UIColor whiteColor];
        
        //        label.textAlignment = NSTextAlignmentCenter;
        [label setNumberOfLines:0];
        
        self.titleLabel = label;
        
        
        UILabel *label1 = [[UILabel alloc] init];
        
        label1.font = contentFont;
        
        label1.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        
        self.timeLabel = label1;
        
        UILabel *label2 = [[UILabel alloc] init];
        
        label2.font = contentFont;
        
        label2.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        
        self.authorLabel = label2;
        
        UILabel *label3 =[[UILabel alloc] init];
        
        label3.font = TruecontentFont;
        
        [label3 setNumberOfLines:0];
        
        label3.textColor = [UIColor whiteColor];
        
        self.contentLabel = label3;
        
        
        
        UIButton *buton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //        buton.backgroundColor = [UIColor clearColor];
        
        self.likeButton = buton;
        
        
        UIButton *buton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //        buton.backgroundColor = [UIColor clearColor];
        
        [buton1.titleLabel setFont:contentFont];
        
        [buton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.commentButton = buton1;
        
        UIButton *buton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [buton2.titleLabel setFont:contentFont];
        
        [buton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        //        buton.backgroundColor = [UIColor clearColor];
        
        self.likeButtonToo = buton2;
        
        [self.contentView addSubview:buton2];
        [self.contentView addSubview:buton1];
        [self.contentView addSubview:buton];
        [self.contentView addSubview:label3];
        [self.contentView addSubview:label2];
        [self.contentView addSubview:label1];
        [self.contentView addSubview:label];
        
        
        
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

+(newsDtailCell*)cellForTableview:(UITableView*)tableview{
    
    NSString *const identif = @"newsDtailCell";
    
    newsDtailCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    
    if (!cell) {
        cell = [[newsDtailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setModel:(JSNewsFrameModel *)model{
    //    if (_model != model||_model.isLike!=model.isLike||![model.likeNum isEqualToString:_model.likeNum]) {
    
    _model = model;
    
    self.titleLabel.text = _model.lmodel.title;
    
    self.authorLabel.text = _model.lmodel.author;
    
    self.contentLabel.text = _model.lmodel.content;
    
    self.timeLabel.text = _model.lmodel.createtime;
    
    self.titleLabel.frame = _model.titleRect;
    
    self.authorLabel.frame = _model.authorRect;
    
    self.contentLabel.frame = _model.contentRect;
    
    self.timeLabel.frame = _model.creatTimeRect;
    
    for (int i = 0 ;i < _model.imageArray.count;i++) {
        NSString *rec = _model.imageRectArray[i];
        CGRect re = CGRectFromString(rec);
        
        UIImageView *vie = [[UIImageView alloc] init];
        
        vie.frame = re;
        
        vie.contentMode = UIViewContentModeScaleAspectFit;;
        
        vie.clipsToBounds = YES;
        
        [self.contentView addSubview:vie];
        
        vie.image = _model.imageArray[i];
        
    }
    
    /**
     *  添加点赞按钮;
     */
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"aixin2"] forState:UIControlStateSelected];
    
    
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"aixin"] forState:UIControlStateNormal];
    
    
    self.likeButton.height = self.likeButton.width = self.likeButton.currentBackgroundImage.size.height*2;
    
    self.likeButton.selected = self.model.isLike;
    
    self.likeButton.centerX = JSFrame.size.width - 1*self.likeButton.height;
    
    self.likeButton.centerY = (CGRectGetMaxY(self.authorLabel.frame) - self.titleLabel.y)/2+ self.titleLabel.y;
    
    
    
    [self.likeButton addTarget:self action:@selector(isisIlIke) forControlEvents:UIControlEventTouchUpInside];
    
    //        首先通过读取验证码得到 cookie, 肉眼识别验证码,手动输入验证码后将得到新的 cookie.
    
    /**
     *  添加评论按钮和点赞按钮
     *
     */
    
    [self.commentButton setTitle:model.commentNum forState:UIControlStateNormal];
    
    //        [self.commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    
    [self.commentButton setFrame:model.commentButRect];
    
    [self.likeButtonToo setTitle:model.likeNum forState:UIControlStateNormal];
    
    [self.likeButtonToo setFrame:model.likeTooButRect];
    
    
}

-(void)isisIlIke{
    
    if (!self.likeButton.isSelected) {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.likeButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5 animations:^{
                self.likeButton.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.likeButton.selected = YES;
                
                self.model.isLike = YES;
                
                NSInteger tureNum = [[self.model.likeNum substringFromIndex:2]  integerValue ]+1;
                
                [self.model setLikeNum:[NSString stringWithFormat:@"赞 %ld",(long)tureNum]];
                
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                dic[@"loginName"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginName"];
                
                dic[@"token"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
                
                dic[@"id"] = self.model.lmodel.num;
                
                [[INetworking shareNet] GET:LikeAddUrl withParmers:dic do:^(id returnObject, BOOL isSuccess) {
                    
                    if (!isSuccess) {
                        
                        [MBProgressHUD showError:@"点赞失败"];
                        
                    }else{
                        
                        [self setModel:self.model];
                        
                    }
                    
                }];
                
            }];
            
        }];
    }
    
}


@end
