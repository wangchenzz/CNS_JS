//
//  NewsCell.m
//  CNS
//
//  Created by Mac on 16/5/11.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "NewsCell.h"

@interface NewsCell ()

@property (nonatomic,retain) UIImageView *photoInfoImage;

@property (nonatomic,retain) UILabel *newsTitleLabel;

@property (nonatomic,retain) UILabel *contentInfoLabel;

@end

@implementation NewsCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *backround = [[UIView alloc] init];
        
        [backround setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.3]];

        backround.frame = CGRectMake(0, 0, JSFrame.size.width, 100);
        
        [self.contentView addSubview:backround];

        UIImageView *imageview  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        
        imageview.contentMode = UIViewContentModeCenter;
        
        imageview.clipsToBounds = YES;
        
        [self.contentView addSubview:imageview];
        
        self.photoInfoImage = imageview;
        
        
        
        UILabel *tit = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, JSFrame.size.width - 120, 30)];
        
        [tit setTextColor:[UIColor whiteColor]];
        
        [tit setFont:[UIFont boldSystemFontOfSize:15]];
        
        self.newsTitleLabel = tit;
        
        
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, JSFrame.size.width - 120, 50)];
        
        [infoLabel setNumberOfLines:0];
        
        infoLabel.textColor = [UIColor whiteColor];
        
        [infoLabel setFont:[UIFont systemFontOfSize:14]];
        
        self.contentInfoLabel = infoLabel;
        
        [self.contentView addSubview:tit];
        
        [self.contentView addSubview:infoLabel];
        
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

+(NewsCell*)cellForTableview:(UITableView*)tableview{
    
    NSString *const identif = @"NewsCell";
    
    NewsCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    
    if (!cell) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setModel:(JSNewsModel *)model{
    if (_model != model) {
        _model = model;
        
        self.contentInfoLabel.text = _model.content;
        
        self.newsTitleLabel.text = _model.title;
        
        NSString*imageString = _model.images;
        
        NSArray *imageArray = [imageString componentsSeparatedByString:@","];
        
        NSString *imastr = [NSString stringWithFormat:@"%@%@",basicUrlStr,imageArray[0]];
        
        
        [self.photoInfoImage sd_setImageWithURL:[NSURL URLWithString:imastr]];
        
    }
}




@end
