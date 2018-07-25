//
//  RechargeRecordTableViewCell.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RechargeRecordTableViewCell.h"

@interface RechargeRecordTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;


@end

@implementation RechargeRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
