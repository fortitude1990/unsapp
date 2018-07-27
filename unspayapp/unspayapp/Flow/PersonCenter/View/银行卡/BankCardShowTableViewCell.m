//
//  BankCardShowTableViewCell.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/27.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BankCardShowTableViewCell.h"
@interface BankCardShowTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *bankImageView;
@property (strong, nonatomic) IBOutlet UILabel *bankNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *bankNoLabel;

@end


@implementation BankCardShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
