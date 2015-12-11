//
//  customTableViewCell.h
//  Knote
//
//  Created by Allen X on 11/7/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface customTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *noteNameInCustomCell;
@property (strong, nonatomic) IBOutlet UILabel *noteContentInCustomCell;
@property (strong, nonatomic) IBOutlet UIView *noteCell;
@property (strong, nonatomic) IBOutlet UIView *infoCell;
@property (strong, nonatomic) IBOutlet UIButton *back;
@property (strong, nonatomic) IBOutlet UIButton *info;


@end
