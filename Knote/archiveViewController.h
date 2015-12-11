//
//  archiveViewController.h
//  Knote
//
//  Created by Allen X on 11/19/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customArchivedTableViewCell.h"
#import <sqlite3.h>

@interface archiveViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSString *dbPath;
    UIImageOrientation scrollOrientation;
    CGPoint lastPos;
}
@property sqlite3 *dataBase;
@property (strong, nonatomic) IBOutlet UIImageView *imageChangingView;
@property (strong, nonatomic) IBOutlet UILabel *archivedNotesCount;
@property (strong, nonatomic) IBOutlet UIButton *backToMainPanel;
@property (copy, nonatomic) NSMutableArray *archivedNotesNameArray;
@property (copy, nonatomic) NSMutableArray *archivedNotesContentArray;
@property (strong, nonatomic) IBOutlet UITableView *tableOfArchivedNotes;

@end
