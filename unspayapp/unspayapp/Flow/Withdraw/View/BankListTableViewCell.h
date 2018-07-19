//
//  BankListTableViewCell.h
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bankImageView;
@property (strong, nonatomic) IBOutlet UILabel *bankCardNumLabel;

@property (strong, nonatomic) IBOutlet UILabel *bankTypeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *indicatorImagView;
@property (strong, nonatomic) IBOutlet UIView *backView;

@end
