//
//  mainPanelViewController.h
//  Knote
//
//  Created by Allen X on 11/5/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LiveFrost/LiveFrost.h>
#import <sqlite3.h>

@interface mainPanelViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    NSString *dbPath;
    UIImageOrientation scrollOrientation;
    CGPoint lastPos;
}
@property (strong, nonatomic) IBOutlet UIImageView *backGroundPic;
@property sqlite3 *dataBase;
@property (copy, nonatomic)NSMutableArray *axKnotes;
@property (copy, nonatomic)NSMutableArray *notesName;
@property (copy, nonatomic)NSMutableArray *notesTime;

@property (strong, nonatomic) IBOutlet UITableView *tableOfNotes;
- (IBAction)searchButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableOfInfos;
- (IBAction)addNote:(id)sender;
@end
