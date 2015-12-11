//
//  archiveViewController.m
//  Knote
//
//  Created by Allen X on 11/19/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import "archiveViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "AppDelegate.h"

@interface archiveViewController ()

@end

@implementation archiveViewController

@synthesize imageChangingView, archivedNotesCount, backToMainPanel, archivedNotesNameArray, archivedNotesContentArray, tableOfArchivedNotes, dataBase;

- (NSString *)findDocuments
{
    NSArray *document_path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [document_path objectAtIndex:0];
    return path;
}

- (void)openSQLite
{
    NSString *path = [self findDocuments];
    dbPath = [[NSString alloc] initWithString:[path stringByAppendingPathComponent:@"axKnotes.db"]];
    int result = sqlite3_open([dbPath UTF8String], &dataBase);
    if(result != SQLITE_OK)
    {
        NSLog(@"open fail:result is %d",result);
    }
}

- (int)execSQL:(NSString *)sql
{
    char *errmsg;
    int result = sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &errmsg);
    return result;
}

- (void)createDatabase
{
    NSString *createsql = @"CREATE TABLE IF NOT EXISTS axKnotes (ID INTEGER PRIMARY KEY AUTOINCREMENT, NOTESNAME TEXT, NOTESCONTENT TEXT, NOTESTIME TEXT, STATUS TEXT)";
    int result = [self execSQL:createsql];
    if (result == SQLITE_OK)
    {
        NSLog(@"createTable SUCCESS,result is %d",result);
    }
}

- (void)deleteObjects:(NSString *) objects{
    
    const char *dbpath = [dbPath UTF8String];
    
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *deleteSql = [[NSString alloc]initWithFormat:@"DELETE FROM axKnotes WHERE NOTESCONTENT = '%@'", objects];
        if ([self execSQL:deleteSql] == SQLITE_OK) {
            NSLog(@"delete from DB.");
        }
        else {
            NSLog( @"delete failed!");
        }
        sqlite3_close(dataBase);
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *url = [[NSMutableArray alloc] initWithObjects:@"http://2.bp.blogspot.com/-Fuw_-ImxH08/Vk2yIflAFdI/AAAAAAAABNI/QebSqQOUXT4/s1600/IMG_2105.JPG",@"http://1.bp.blogspot.com/-1h_eBDDaAe8/Vk2zAUI6HdI/AAAAAAAABNU/rvdVqLIHxJA/s1600/IMG_2106.JPG",@"http://4.bp.blogspot.com/-32k6V5qrYQw/Vk2zAlH2l8I/AAAAAAAABNY/f5lYr4Pxl_A/s1600/IMG_2107.JPG",@"http://4.bp.blogspot.com/-FgDX7wl47VU/Vk2zBBLHTVI/AAAAAAAABNc/X3I_7rCm5Vk/s1600/IMG_2108.JPG",@"http://4.bp.blogspot.com/-2KyzC2yS2q0/Vk2zB2PjImI/AAAAAAAABNo/6iJbeoCfI8k/s1600/IMG_2109.JPG", nil];
    int i = arc4random()%5;
    
    [imageChangingView setImageWithURL:[NSURL URLWithString:url[i]]];
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-20);
    verticalMotionEffect.maximumRelativeValue = @(20);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [imageChangingView addMotionEffect:group];//parallax
    
    archivedNotesNameArray = [[NSMutableArray alloc]initWithCapacity:1000];
    archivedNotesContentArray = [[NSMutableArray alloc]initWithCapacity:1000];
    [self openSQLite];
    [self createDatabase];
    //NSLog(@"done");
    
    const char *dbpath = [dbPath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK)
    {
        NSString *querySQL = @"SELECT NOTESNAME, NOTESCONTENT, STATUS from axKnotes";
        const char *querystatement = [querySQL UTF8String];
        if (sqlite3_prepare_v2(dataBase, querystatement, -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *Status = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                if ([Status isEqualToString:@"ARCHIVED"]) {
                    [archivedNotesContentArray addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                    [archivedNotesNameArray addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                    //[notesTime addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]];
                }
                
            }
        }
        else
        {
            NSLog(@"did not find you need.");
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    [tableOfArchivedNotes reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{archivedNotesCount.text=[[NSString alloc] initWithFormat:@"(%lu)",(unsigned long)[archivedNotesContentArray count]];
    return [archivedNotesNameArray count];
    
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isDragging) {
        UIView *myView = cell.contentView;
        CALayer *layer = myView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        if (scrollOrientation == UIImageOrientationDown) {
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI*1.5, 2.0f, 0.3f, 0.0f);
        } else {
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI*1.5, 2.0f, 0.3f, 0.0f);
        }
        layer.transform = rotationAndPerspectiveTransform;
        [UIView animateWithDuration:.5 animations:^{
            layer.transform = CATransform3DIdentity;
        }];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollOrientation = scrollView.contentOffset.y > lastPos.y?UIImageOrientationDown:UIImageOrientationUp;
    lastPos = scrollView.contentOffset;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"Cell";
    customArchivedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.archivedNotesInfo.tag=indexPath.row;
    cell.backgroundColor = [UIColor clearColor];//transparent
    cell.backgroundView = [UIView new];//transparent
    cell.selectedBackgroundView = [UIView new];//transparent
        if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.archivedNotesName.text = archivedNotesNameArray[indexPath.row];
    cell.archivedNotesContent.text = archivedNotesContentArray[indexPath.row];
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) changeObejectStatus:(NSString *)content{
    if(sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK){
        NSString *sql = [[NSString alloc] initWithFormat:@"UPDATE axKnotes SET STATUS = 'Normal' WHERE NOTESCONTENT = '%@'",content];
        int result = [self execSQL:sql];
        if(result == SQLITE_OK){
            NSLog(@"Update succeeded");
        }
    }
    sqlite3_close(dataBase);
    [self.tableOfArchivedNotes reloadData];
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Trash" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        customArchivedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self deleteObjects: cell.archivedNotesContent.text];
        [archivedNotesContentArray removeObjectAtIndex:indexPath.row];
        [archivedNotesNameArray removeObjectAtIndex:indexPath.row];
        
        //NSLog(@"%lu",[archivedNotesContentArray count]);
        [self.tableOfArchivedNotes reloadData];
        
    }];
    
    UITableViewRowAction *unarchive = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Unarchive" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

        customArchivedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self changeObejectStatus: cell.archivedNotesContent.text];
        [archivedNotesContentArray removeObjectAtIndex:indexPath.row];
        [archivedNotesNameArray removeObjectAtIndex:indexPath.row];
        [self.tableOfArchivedNotes reloadData];

    }];
    
    delete.backgroundColor = [UIColor redColor];
    
    return @[delete, unarchive];
    
}

- (IBAction)archivedNotesInfo:(id)sender {
}
@end
