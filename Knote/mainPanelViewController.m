//
//  mainPanelViewController.m
//  Knote
//
//  Created by Allen X on 11/5/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import "mainPanelViewController.h"
#import "customTableViewCell.h"
#import "editPanelViewController.h"
#import "AppDelegate.h"//flipCode

@interface mainPanelViewController()
{
    AppDelegate* appDelegate;//flipCode
}

@property UISearchBar *searchBar;
@property LFGlassView *searchView;
@property NSInteger times;
//@property(strong, nonatomic) RLMResults *axKnotes;（realm practice）
@end

@implementation mainPanelViewController
@synthesize tableOfNotes, axKnotes, notesName, notesTime, dataBase, backGroundPic, searchBar, times, searchView;

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
    //NSLog(dbPath);
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
    if (result != SQLITE_OK)
    {
        NSLog(@"createTable failed,result is %d",result);
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    customTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.axKnotes removeObjectAtIndex:indexPath.row];
    [self.notesName removeObjectAtIndex:indexPath.row];
    [self deleteObjects:(NSString *) cell.noteContentInCustomCell.text];
    //[self deleteObjects:(NSString *) cell.noteNameInCustomCell.text];
    //[axKnotes removeObjectAtIndex:indexPath.row];
    //customTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //const char *dbpath = [dbPath UTF8String];
    
    [tableOfNotes reloadData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    times=0;
    /*UIViewController *leftDrawer = [[UIViewController alloc] init];
    UIViewController * center = [[UIViewController alloc] init];
    MMDrawerController *drawer = [[MMDrawerController alloc] initWithCenterViewController: center leftDrawerViewController:leftDrawer];(The Drawer thing)*/
    
    //Parallax Motion
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-20);
    verticalMotionEffect.maximumRelativeValue = @(20);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [backGroundPic addMotionEffect:group];//Parallax Motion

    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;//flipCode
    axKnotes = [[NSMutableArray alloc]initWithCapacity:1000];
    notesName = [[NSMutableArray alloc]initWithCapacity:1000];
    [self openSQLite];
    [self createDatabase];
    
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
                if ([Status isEqualToString:@"Normal"]) {
                    [axKnotes addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                    [notesName addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                    //[notesTime addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]];
                }
                
                //NSLog([[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]);
            }
        }
        else
        {
            NSLog(@"did not find you need.");
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    [tableOfNotes reloadData];
    
    //Realm Database Practice
    /*RLMRealm *defaultRealm = [RLMRealm defaultRealm];
    allNotes *note1;
    note1.notesName = @"first knote";
    note1.notesContent=@"this looks not bad";
    [defaultRealm beginWriteTransaction];
    [defaultRealm addObject:note1];
    [defaultRealm commitWriteTransaction];
    self.axKnotes = [allNotes allObjects];*/
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [axKnotes count];
}

//Cell Animations while scrolling
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
}//Cell Animations while scrolling

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    customTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];{
        editPanelViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
        vc.detailText = cell.noteContentInCustomCell.text;
        vc.detailName = cell.noteNameInCustomCell.text;
        vc.editStatus = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) selectObject: (NSString *)notes{
    [axKnotes removeAllObjects];
    [notesName removeAllObjects];
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT NOTESNAME, NOTESCONTENT, STATUS FROM axKnotes WHERE NOTESCONTENT LIKE '%%%@%%'", notes];
    //NSLog(sql);
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *ch0=(char *)sqlite3_column_text(statement, 0);
            NSString *name = [[NSString alloc]initWithUTF8String:ch0];
            [notesName addObject:name];
            //content
            char *ch1= (char*)sqlite3_column_text(statement, 1);
            NSString *content = [[NSString alloc]initWithUTF8String:ch1];
            [axKnotes addObject:content];
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"Cell";
    customTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.info.tag=indexPath.row;
    cell.back.tag=indexPath.row;
    cell.backgroundColor = [UIColor clearColor];//transparent
    cell.backgroundView = [UIView new];//transparent
    cell.selectedBackgroundView = [UIView new];//transparent
    if([[appDelegate.viewMaintainedDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] isEqualToString:@"1"])
    {
        [cell.contentView insertSubview:cell.infoCell aboveSubview:cell.noteCell];
    }
    else if([[appDelegate.viewMaintainedDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] isEqualToString:@"0"])
    {
        [cell.contentView insertSubview:cell.noteCell aboveSubview:cell.infoCell];
        
    }
    if (cell == nil){
        cell = [[customTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.noteContentInCustomCell.text = axKnotes[indexPath.row];
    cell.noteNameInCustomCell.text = notesName[indexPath.row];
    
    return cell;

}

//Archive
- (void) archiveObjects: (NSString *)object{
    if(sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK){
        NSString *sql = [[NSString alloc] initWithFormat:@"UPDATE axKnotes SET STATUS = 'ARCHIVED' WHERE NOTESCONTENT = '%@'", object];
        
        int result = [self execSQL:sql];
        if(result == SQLITE_OK){
            NSLog(@"Update succeeded");
        }
    }
    sqlite3_close(dataBase);
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Trash" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        customTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [axKnotes removeObjectAtIndex:indexPath.row];
        [notesName removeObjectAtIndex:indexPath.row];
        [self deleteObjects:(NSString *)cell.noteContentInCustomCell.text];
        
        [self.tableOfNotes reloadData];
    
    }];
    
        delete.backgroundColor = [UIColor redColor];
    
    
    UITableViewRowAction *archive = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Archive" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
        customTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self archiveObjects:(NSString *)cell.noteContentInCustomCell.text];
        [notesName removeObjectAtIndex:indexPath.row];
        [axKnotes removeObjectAtIndex:indexPath.row];
        [self.tableOfNotes reloadData];
    }];
    
        archive.backgroundColor = [UIColor orangeColor];
    
    return @[delete, archive];
    
}
    
- (void) searchBar: (UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self selectObject:searchText];
    [self.tableOfNotes reloadData];
}
//Buttons
- (IBAction)addNote:(id)sender {
    editPanelViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    vc.detailText = NULL;
    vc.editStatus = YES;
}

//search button
- (IBAction)searchButton:(id)sender {
    if (times==0){
        times=1;
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 375, 40)];
        searchBar.delegate = self;
        [self.view addSubview:searchBar];
    }
    else if (times == 1){
        times=0;
        [searchBar removeFromSuperview];
    }
}


@end