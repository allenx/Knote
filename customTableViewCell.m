//
//  customTableViewCell.m
//  Knote
//
//  Created by Allen X on 11/7/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import "customTableViewCell.h"
#import "AppDelegate.h"

AppDelegate * appDelegate;

@implementation customTableViewCell

- (void)awakeFromNib {
    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;//flipCode
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)back:(id)sender {
    NSInteger tag=[sender tag];
    [appDelegate.viewMaintainedDict setObject:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)tag]];
    
    [UIView transitionWithView:self.contentView duration:0.6 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [self.contentView insertSubview:_noteCell aboveSubview:_infoCell];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (IBAction)info:(id)sender {
    
    NSInteger tag=[sender tag];
    [appDelegate.viewMaintainedDict setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",(long)tag]];
    [UIView transitionWithView:self.contentView duration:0.6 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [self.contentView insertSubview:_infoCell aboveSubview:_noteCell];
    } completion:^(BOOL finished) {
        
    }];
}


@end
