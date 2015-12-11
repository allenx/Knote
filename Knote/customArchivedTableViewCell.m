//
//  customArchivedTableViewCell.m
//  Knote
//
//  Created by Allen X on 11/19/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import "customArchivedTableViewCell.h"
#import "AppDelegate.h"

AppDelegate * appDelegate1;

@implementation customArchivedTableViewCell

- (void)awakeFromNib {
    //appDelegate1=(AppDelegate*)[UIApplication sharedApplication].delegate;//flipCode
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
