//
//  customArchivedTableViewCell.h
//  Knote
//
//  Created by Allen X on 11/19/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customArchivedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *archivedNotesName;
@property (strong, nonatomic) IBOutlet UILabel *archivedNotesContent;
@property (strong, nonatomic) IBOutlet UIButton *archivedNotesInfo;

@end
