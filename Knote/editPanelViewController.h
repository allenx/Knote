//
//  editPanelViewController.h
//  Knote
//
//  Created by Allen X on 11/1/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LiveFrost/LiveFrost.h>
#import <sqlite3.h>

@interface editPanelViewController : UIViewController
{
    NSString *dbPath;
}
@property BOOL editStatus;
@property sqlite3 *dataBase;
@property (copy, nonatomic)NSString *detailText;
@property (copy, nonatomic)NSString *detailName;
- (IBAction)cancelNote:(id)sender;
- (IBAction)saveNote:(id)sender;
@end